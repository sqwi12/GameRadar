import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:logging/logging.dart';

import '../clock.dart';
import '../config.dart';
import '../db/games_repository.dart';
import '../db/steam_links_repository.dart';
import '../db/store_lows_repository.dart';
import '../itad/itad_client.dart';
import '../notifications/notification_service.dart';
import '../queue/markers.dart';
import '../queue/task_queue.dart';
import '../steam/steam_client.dart';

/// Имена периодических работ для [Markers].
abstract final class MarkerName {
  static const appList = 'app_list';
  static const topChart = 'top_chart';
  static const compaction = 'compaction';
  static const topRanks = 'top_ranks';
}

/// Обработчик одной задачи очереди.
typedef TaskHandler = Future<void> Function(QueueTask task);

/// Выполнение задач: запрос к Steam → запись в БД → уведомления.
final class TaskHandlers {
  TaskHandlers({
    required this._steam,
    required this._games,
    required this._notifications,
    required this._markers,
    required this._config,
    required this._steamLinks,
    this._itad,
    this._storeLows,
    this._clock = const SystemClock(),
  });

  static final _log = Logger('Tasks');

  final SteamClient _steam;
  final GamesRepository _games;
  final NotificationService _notifications;
  final Markers _markers;
  final WorkerConfig _config;
  final SteamLinksRepository _steamLinks;

  /// Есть, только если задан ITAD_API_KEY.
  final ItadClient? _itad;
  final StoreLowsRepository? _storeLows;
  final Clock _clock;

  /// Свежесть замеров онлайна для места в топе.
  static const topFreshness = Duration(hours: 3);

  Future<void> handle(QueueTask task) => switch (task.kind) {
    TaskKind.prices => _prices(task),
    TaskKind.players => _players(task),
    TaskKind.details => _details(task),
    TaskKind.reviews => _reviews(task),
    TaskKind.appList => _appList(),
    TaskKind.topChart => _topChart(),
    TaskKind.image => _image(task),
    TaskKind.wishlist => _wishlist(task),
    TaskKind.storeLows => _storeLowsTask(task),
    TaskKind.notify => _notifications.evaluateOne(
      task.payload['user_id']! as String,
      task.payload['app_id']! as int,
    ),
    _ => throw StateError('Неизвестный вид задачи: ${task.kind}'),
  };

  Future<void> _prices(QueueTask task) async {
    final region = task.payload['region']! as String;
    final appIds = (task.payload['app_ids']! as List).cast<int>();
    final prices = await _steam.fetchPrices(appIds, region);
    await _games.savePrices(region, prices.values);
    // Игры, о которых Steam промолчал, отмечаем проверенными, иначе
    // они будут попадать в каждый следующий пакет.
    final missing = appIds.where((id) => !prices.containsKey(id)).toList();
    await _games.touchPricesChecked(region, missing);
    await _notifications.evaluateApps(prices.keys.toList(), region);
  }

  Future<void> _players(QueueTask task) async {
    final appId = task.payload['app_id']! as int;
    await _games.savePlayers(appId, await _steam.fetchCurrentPlayers(appId));
  }

  Future<void> _details(QueueTask task) async {
    final appId = task.payload['app_id']! as int;
    final details = await _steam.fetchAppDetails(appId, region: _config.region);
    final descriptions = <String, String>{'en': ?details?.shortDescription};
    if (details != null) {
      final ru = await _steam.fetchShortDescription(
        appId,
        steamLanguage: 'russian',
        region: _config.region,
      );
      if (ru != null) descriptions['ru'] = ru;
    }
    await _games.saveDetails(appId, details, descriptions);
  }

  Future<void> _reviews(QueueTask task) async {
    final appId = task.payload['app_id']! as int;
    await _games.saveReviews(appId, await _steam.fetchReviews(appId));
  }

  Future<void> _image(QueueTask task) async {
    final appId = task.payload['app_id']! as int;
    final url = task.payload['url']! as String;
    try {
      final image = await _steam.fetchImage(Uri.parse(url));
      await _games.saveImage(appId, url, image.contentType, image.bytes);
    } on SteamPermanentException catch (e) {
      _log.warning('Обложка $appId недоступна: $e');
      await _games.dropImageUrl(appId, url);
    }
  }

  /// Импорт списка желаемого: ник → SteamID, открытость профиля, список.
  /// Все запросы — через очередь и лимит worker'а (правило 2).
  /// Исторические минимумы в Steam (IsThereAnyDeal) для пакета игр:
  /// ID неизвестных игр ищутся одним запросом, минимумы — вторым.
  Future<void> _storeLowsTask(QueueTask task) async {
    final itad = _itad;
    final repo = _storeLows;
    if (itad == null || repo == null) return; // Ключ убрали после планирования.
    final region = task.payload['region']! as String;
    final appIds = (task.payload['app_ids']! as List).cast<int>();

    final ids = {...await repo.knownItadIds(appIds)};
    final missing = [
      for (final id in appIds)
        if (!ids.containsKey(id)) id,
    ];
    if (missing.isNotEmpty) ids.addAll(await itad.lookupSteamApps(missing));

    final byUuid = {
      for (final MapEntry(:key, :value) in ids.entries) ?value: key,
    };
    final lows = byUuid.isEmpty
        ? const <String, ItadLow>{}
        : await itad.steamLows(byUuid.keys.toList(), region);
    await repo.save(region, {
      for (final appId in appIds)
        appId: (
          itadId: ids[appId],
          low: ids[appId] == null ? null : lows[ids[appId]],
        ),
    });
    _log.fine('ITAD: ${appIds.length} игр, минимумов ${lows.length}');
  }

  Future<void> _wishlist(QueueTask task) async {
    final job = await _steamLinks.job(task.payload['user_id']! as String);
    if (job == null) return; // Привязку уже удалили.

    var steamId = job.steamId;
    if (steamId == null) {
      steamId = switch (SteamProfileRef.tryParse(job.profileInput)) {
        SteamId64(:final value) => value,
        SteamVanity(:final name) => await _steam.resolveVanity(name),
        null => null,
      };
      if (steamId == null) {
        await _steamLinks.markStatus(job.userId, 'not_found');
        return;
      }
    }

    final profile = await _steam.playerSummary(steamId);
    if (profile == null) {
      await _steamLinks.markStatus(job.userId, 'not_found');
      return;
    }
    if (!profile.isPublic) {
      await _steamLinks.markStatus(
        job.userId,
        'private_profile',
        steamId: steamId,
        personaName: profile.personaName,
      );
      return;
    }
    final appIds = await _steam.wishlist(steamId);
    // Скрытый список Steam отдаёт так же, как пустой. Принять его за пустой
    // нельзя: синхронизация удалила бы уже импортированные игры.
    if (appIds.isEmpty && await _steam.wishlistCount(steamId) == null) {
      await _steamLinks.markStatus(
        job.userId,
        'private_profile',
        steamId: steamId,
        personaName: profile.personaName,
      );
      return;
    }
    final imported = await _steamLinks.importWishlist(
      job,
      steamId,
      profile.personaName,
      appIds,
    );
    _log.info(
      'Список желаемого ${job.userId}: ${appIds.length} игр, в отслеживаемых $imported',
    );
  }

  Future<void> _appList() async {
    int? lastAppId;
    var total = 0;
    var changed = 0;
    while (true) {
      final page = await _steam.fetchAppList(lastAppId: lastAppId);
      total += page.apps.length;
      changed += await _games.upsertAppList(page.apps);
      final next = page.lastAppId;
      if (!page.haveMoreResults || next == null || next == lastAppId) break;
      lastAppId = page.lastAppId;
    }
    await _markers.setLastRun(MarkerName.appList, _clock.now());
    _log.info(
      'Список игр: получено $total, добавлено или переименовано $changed',
    );
  }

  Future<void> _topChart() async {
    final chart = await _steam.fetchConcurrentChart();
    await _games.ensureGamesExist(chart.map((e) => e.appId));
    // Чарт — это 100 бесплатных замеров онлайна одним запросом.
    await _games.savePlayerBatch({
      for (final e in chart) e.appId: e.concurrentInGame,
    });
    await _games.recomputeTopRanks(
      topSize: _config.topSize,
      freshness: topFreshness,
    );
    await _markers.setLastRun(MarkerName.topChart, _clock.now());
    _log.info('Чарт Steam: ${chart.length} игр');
  }
}
