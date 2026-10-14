import 'dart:async';
import 'dart:io';

import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:timezone/data/latest.dart' as tzdata;

/// Точка входа worker: читает настройки из окружения, подключается
/// к PostgreSQL и Redis (если задан) и запускает планировщик и полосы очереди.
Future<void> main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((r) {
    final error = r.error == null ? '' : ' | ${r.error}';
    stdout.writeln(
      '${r.time.toUtc().toIso8601String()} ${r.level.name} ${r.loggerName}: ${r.message}$error',
    );
    if (r.stackTrace != null && r.level >= Level.SEVERE) {
      stdout.writeln(r.stackTrace);
    }
  });
  final log = Logger('Worker');

  tzdata.initializeTimeZones();
  final WorkerConfig config;
  try {
    config = WorkerConfig.fromEnvironment();
  } on StateError catch (e) {
    stderr.writeln('Ошибка конфигурации: ${e.message}');
    exit(64);
  }
  const clock = SystemClock();

  final db = Pool<void>.withUrl(config.databaseUrl);
  final redisUrl = config.redisUrl;
  final redis = redisUrl == null ? null : await RedisClient.connect(redisUrl);
  final httpClient = http.Client();

  // Без Redis (одна копия worker'а на хостинге): очередь и лимит запросов —
  // в памяти, отметки периодических работ — в PostgreSQL.
  final TaskQueue queue = redis == null
      ? InMemoryTaskQueue(clock)
      : RedisTaskQueue(redis);
  final Markers markers = redis == null
      ? PostgresMarkers(db)
      : RedisMarkers(redis);
  RateLimiter limiter(Duration interval) => redis == null
      ? InMemoryRateLimiter(interval: interval, clock: clock)
      : RedisRateLimiter(redis, interval: interval);
  log.info(
    redis == null ? 'Очередь: в памяти (REDIS_URL не задан)' : 'Очередь: Redis',
  );
  final games = GamesRepository(db);
  final steam = SteamClient(
    httpClient: httpClient,
    rateLimiter: limiter(config.requestInterval),
    apiKey: config.steamApiKey,
    clock: clock,
  );
  final Notifier notifier;
  if (config.fcmConfigured) {
    final json = config.fcmServiceAccountJson;
    notifier = json != null
        ? await FcmNotifier.fromServiceAccountJson(
            projectId: config.fcmProjectId!,
            json: json,
            devices: DevicesRepository(db),
          )
        : await FcmNotifier.fromServiceAccountFile(
            projectId: config.fcmProjectId!,
            path: config.fcmServiceAccountFile!,
            devices: DevicesRepository(db),
          );
    log.info('Уведомления: FCM, проект ${config.fcmProjectId}');
  } else {
    notifier = LoggingNotifier();
    log.warning(
      'Уведомления: FCM не настроен (FCM_PROJECT_ID и FCM_SERVICE_ACCOUNT_FILE '
      'или FCM_SERVICE_ACCOUNT_JSON) — только журнал',
    );
  }
  final notifications = NotificationService(
    watchlist: WatchlistRepository(db),
    notifier: notifier,
    queue: queue,
    clock: clock,
  );
  // Исторические минимумы цен (IsThereAnyDeal) — только с ключом.
  final itadKey = config.itadApiKey;
  final storeLows = itadKey == null ? null : StoreLowsRepository(db);
  final itad = itadKey == null
      ? null
      : ItadClient(
          httpClient: httpClient,
          // Лимит ключа ITAD — 100 запросов за 5 минут: не чаще раза в 3,5 с.
          rateLimiter: limiter(const Duration(milliseconds: 3500)),
          apiKey: itadKey,
          clock: clock,
        );
  log.info(
    itad == null
        ? 'Исторические минимумы: ITAD_API_KEY не задан — выключены'
        : 'Исторические минимумы: IsThereAnyDeal',
  );
  final handlers = TaskHandlers(
    steam: steam,
    games: games,
    notifications: notifications,
    markers: markers,
    config: config,
    clock: clock,
    steamLinks: SteamLinksRepository(db),
    itad: itad,
    storeLows: storeLows,
    fx: config.compareRegions.isEmpty
        ? null
        : FxClient(
            httpClient: httpClient,
            rateLimiter: limiter(config.requestInterval),
            clock: clock,
          ),
  );

  final scheduler = Scheduler(
    games: games,
    queue: queue,
    markers: markers,
    config: config,
    steamLinks: SteamLinksRepository(db),
    storeLows: storeLows,
  );
  final lanes = [
    for (final lane in Lane.values)
      LaneRunner(
        lane: lane,
        queue: queue,
        handler: handlers.handle,
        clock: clock,
      ),
  ];

  final stopping = Completer<void>();
  void stop(ProcessSignal signal) {
    if (stopping.isCompleted) return;
    log.info('Получен $signal, завершаем текущие задачи…');
    scheduler.stop();
    for (final lane in lanes) {
      lane.stop();
    }
    stopping.complete();
  }

  ProcessSignal.sigint.watch().listen(stop);
  if (!Platform.isWindows) ProcessSignal.sigterm.watch().listen(stop);

  log.info('Worker запущен');
  unawaited(scheduler.run());
  await Future.wait([for (final lane in lanes) lane.run()]);

  httpClient.close();
  await redis?.close();
  await db.close();
  log.info('Worker остановлен');
  exit(0);
}
