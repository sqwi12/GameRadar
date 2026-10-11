import 'dart:math' as math;

import 'package:logging/logging.dart';

import '../clock.dart';
import '../config.dart';
import '../db/games_repository.dart';
import '../db/steam_links_repository.dart';
import '../db/store_lows_repository.dart';
import '../itad/itad_client.dart';
import '../queue/markers.dart';
import '../queue/task_queue.dart';
import '../steam/steam_client.dart';
import '../tasks/task_handlers.dart';

/// Приоритет задачи: крайний срок обновления минус бонус за подписчиков.
/// Очередь выдаёт задачи с наименьшим значением, то есть по ближайшему
/// сроку (EDF). Если лимита запросов не хватает, все интервалы растягиваются
/// равномерно, а игры с большим числом подписчиков идут раньше (правило 5).
int taskPriority({
  required DateTime now,
  required DateTime? checkedAt,
  required Duration maxAge,
  required int watchers,
}) {
  // Никогда не проверявшиеся игры считаются просроченными на сутки.
  final due = (checkedAt ?? now.subtract(const Duration(days: 1))).add(maxAge);
  return due.millisecondsSinceEpoch - watcherBonus(watchers).inMilliseconds;
}

/// 10 минут за каждое удвоение числа подписчиков: 1 → 10 мин, 3 → 20, 1023 → 100.
Duration watcherBonus(int watchers) => watchers <= 0
    ? Duration.zero
    : Duration(minutes: (10 * math.log(1 + watchers) / math.ln2).round());

/// Раз в [tick] выбирает из БД игры, которым пора обновиться (правило 6),
/// и ставит задачи в очередь. Дубли отсекает сама очередь по id задачи,
/// поэтому планировщик можно безопасно запускать в нескольких копиях worker.
final class Scheduler {
  Scheduler({
    required this._games,
    required this._queue,
    required this._markers,
    required this._config,
    required this._steamLinks,
    this._storeLows,
    this._clock = const SystemClock(),
    this.tick = const Duration(minutes: 1),
  });

  static final _log = Logger('Scheduler');

  final GamesRepository _games;
  final TaskQueue _queue;
  final Markers _markers;
  final WorkerConfig _config;
  final SteamLinksRepository _steamLinks;

  /// Есть, только если задан ITAD_API_KEY.
  final StoreLowsRepository? _storeLows;
  final Clock _clock;
  final Duration tick;

  /// Задачи онлайна для «разведки» добавляются, только если в полосе api
  /// почти нет работы, — разведка не отнимает лимит у топа и подписок.
  static const discoveryBacklogLimit = 20;
  static const discoveryBatch = 50;
  static const discoveryMinAge = Duration(days: 30);

  bool _stopped = false;

  void stop() => _stopped = true;

  Future<void> run() async {
    _log.info(
      'Запущен, регион ${_config.region}, распродажа: ${_config.saleMode}',
    );
    while (!_stopped) {
      try {
        await planOnce();
      } catch (e, st) {
        _log.severe('Ошибка планирования', e, st);
      }
      await _clock.sleep(tick);
    }
  }

  Future<void> planOnce() async {
    final now = _clock.now();
    await _planPeriodic(now);
    await _planPrices(now);
    await _planPlayers(now);
    await _planPerGame(
      now,
      TaskKind.details,
      Lane.store,
      _config.schedule.details,
    );
    await _planPerGame(
      now,
      TaskKind.reviews,
      Lane.store,
      _config.schedule.reviews,
    );
    await _planImages(now);
    await _planWishlists(now);
    await _planStoreLows(now);
    await _planRegionPrices(now);
  }

  /// Цены в регионах сравнения раз в 12 часов — только для отслеживаемых
  /// и недавно открытых игр (на каждые 50 игр — запрос на регион).
  Future<void> _planRegionPrices(DateTime now) async {
    if (_config.compareRegions.isEmpty) return;
    if (await _queue.countKind(TaskKind.regionPrices) > 0) return;
    for (final region in _config.compareRegions) {
      if (region == _config.region) continue;
      final due = await _games.dueRegionPrices(
        region: region,
        minAge: regionPricesInterval,
        limit: SteamClient.maxPriceBatch * 4,
      );
      for (var i = 0; i < due.length; i += SteamClient.maxPriceBatch) {
        final ids = due.sublist(
          i,
          math.min(i + SteamClient.maxPriceBatch, due.length),
        )..sort();
        await _queue.enqueue(
          QueueTask(
            id: '${TaskKind.regionPrices}:$region:${_batchKey(ids)}',
            kind: TaskKind.regionPrices,
            lane: Lane.store,
            // Ниже основных цен: сравнение — справочная информация.
            priority: now.add(const Duration(hours: 6)).millisecondsSinceEpoch,
            payload: {'region': region, 'app_ids': ids},
          ),
        );
      }
    }
  }

  static const regionPricesInterval = Duration(hours: 12);

  /// Исторические минимумы (IsThereAnyDeal) раз в сутки, пакетами по 200.
  /// Лимит ITAD — 1000 запросов за 5 минут, у нас ~10 запросов в сутки.
  Future<void> _planStoreLows(DateTime now) async {
    final repo = _storeLows;
    if (repo == null) return;
    if (await _queue.countKind(TaskKind.storeLows) > 0) return;
    final due = await repo.due(
      region: _config.region,
      limit: ItadClient.maxBatch * 10,
    );
    for (var i = 0; i < due.length; i += ItadClient.maxBatch) {
      final batch = due.sublist(
        i,
        math.min(i + ItadClient.maxBatch, due.length),
      )..sort();
      await _queue.enqueue(
        QueueTask(
          id: '${TaskKind.storeLows}:${_config.region}:${_batchKey(batch)}',
          kind: TaskKind.storeLows,
          lane: Lane.itad,
          priority: now.millisecondsSinceEpoch,
          payload: {'region': _config.region, 'app_ids': batch},
        ),
      );
    }
  }

  Future<void> _planPrices(DateTime now) async {
    // Пока предыдущие пакеты цен не обработаны, новые не формируем:
    // так одна игра не окажется в двух пакетах сразу.
    if (await _queue.countKind(TaskKind.prices) > 0) return;
    final window = _config.priceWindow;
    final due = await _games.duePrices(
      region: _config.region,
      minAge: window.min,
      limit: SteamClient.maxPriceBatch * 40,
    );
    for (var i = 0; i < due.length; i += SteamClient.maxPriceBatch) {
      final batch = due.sublist(
        i,
        math.min(i + SteamClient.maxPriceBatch, due.length),
      );
      final ids = [for (final g in batch) g.appId]..sort();
      await _queue.enqueue(
        QueueTask(
          id: 'prices:${_config.region}:${_batchKey(ids)}',
          kind: TaskKind.prices,
          lane: Lane.store,
          priority: batch
              .map(
                (g) => taskPriority(
                  now: now,
                  checkedAt: g.checkedAt,
                  maxAge: window.max,
                  watchers: g.watchers,
                ),
              )
              .reduce(math.min),
          payload: {'region': _config.region, 'app_ids': ids},
        ),
      );
    }
    if (due.isNotEmpty) _log.fine('Цены: ${due.length} игр в очередь');
  }

  Future<void> _planPlayers(DateTime now) async {
    final schedule = _config.schedule;
    final threshold = await _games.topThreshold(_config.topSize);
    final top = await _games.dueTopPlayers(
      threshold: threshold,
      minAge: schedule.topPlayers.min,
      limit: (_config.topSize * 1.5).round(),
    );
    final watched = await _games.dueWatchedPlayers(
      threshold: threshold,
      minAge: schedule.otherPlayers.min,
      limit: 2000,
    );
    for (final (games, window) in [
      (top, schedule.topPlayers),
      (watched, schedule.otherPlayers),
    ]) {
      for (final g in games) {
        await _enqueuePlayers(
          g.appId,
          taskPriority(
            now: now,
            checkedAt: g.checkedAt,
            maxAge: window.max,
            watchers: g.watchers,
          ),
        );
      }
    }

    if (await _queue.backlog(Lane.api) < discoveryBacklogLimit) {
      final discovery = await _games.discoveryCandidates(
        minAge: discoveryMinAge,
        limit: discoveryBatch,
      );
      // Самый поздний срок: разведка выполняется только в простое.
      final low = now.add(const Duration(days: 30)).millisecondsSinceEpoch;
      for (final appId in discovery) {
        await _enqueuePlayers(appId, low);
      }
    }
  }

  Future<void> _enqueuePlayers(int appId, int priority) => _queue.enqueue(
    QueueTask(
      id: 'players:$appId',
      kind: TaskKind.players,
      lane: Lane.api,
      priority: priority,
      payload: {'app_id': appId},
    ),
  );

  Future<void> _planPerGame(
    DateTime now,
    String kind,
    Lane lane,
    RefreshWindow window,
  ) async {
    final due = kind == TaskKind.details
        ? await _games.dueDetails(minAge: window.min, limit: 500)
        : await _games.dueReviews(minAge: window.min, limit: 500);
    for (final g in due) {
      await _queue.enqueue(
        QueueTask(
          id: '$kind:${g.appId}',
          kind: kind,
          lane: lane,
          priority: taskPriority(
            now: now,
            checkedAt: g.checkedAt,
            maxAge: window.max,
            watchers: g.watchers,
          ),
          payload: {'app_id': g.appId},
        ),
      );
    }
  }

  /// Импорт списков желаемого: новые привязки — сразу, остальные — раз в сутки.
  Future<void> _planWishlists(DateTime now) async {
    for (final userId in await _steamLinks.dueUserIds(limit: 100)) {
      await _queue.enqueue(
        QueueTask(
          id: '${TaskKind.wishlist}:$userId',
          kind: TaskKind.wishlist,
          lane: Lane.api,
          // Пользователь ждёт результат на экране — выше обычных замеров онлайна.
          priority: now
              .subtract(const Duration(hours: 2))
              .millisecondsSinceEpoch,
          payload: {'user_id': userId},
        ),
      );
    }
  }

  /// Обложки: скачиваются один раз и заново — только при смене адреса.
  Future<void> _planImages(DateTime now) async {
    for (final g in await _games.dueImages(limit: 200)) {
      await _queue.enqueue(
        QueueTask(
          id: '${TaskKind.image}:${g.appId}',
          kind: TaskKind.image,
          lane: Lane.cdn,
          priority:
              now.millisecondsSinceEpoch -
              watcherBonus(g.watchers).inMilliseconds,
          payload: {'app_id': g.appId, 'url': g.url},
        ),
      );
    }
  }

  Future<void> _planPeriodic(DateTime now) async {
    final schedule = _config.schedule;

    Future<bool> due(String marker, Duration every) async {
      final last = await _markers.lastRun(marker);
      return last == null || now.difference(last) >= every;
    }

    // Список игр и чарт — задачи к Steam, отметку ставит обработчик после успеха.
    if (await due(MarkerName.appList, schedule.appList)) {
      await _queue.enqueue(
        QueueTask(
          id: TaskKind.appList,
          kind: TaskKind.appList,
          lane: Lane.api,
          priority: now.millisecondsSinceEpoch,
        ),
      );
    }
    // Курсы НБК — раз в сутки, если включено сравнение регионов.
    if (_config.compareRegions.isNotEmpty &&
        await due(MarkerName.fxRates, const Duration(hours: 24))) {
      await _queue.enqueue(
        QueueTask(
          id: TaskKind.fxRates,
          kind: TaskKind.fxRates,
          lane: Lane.local,
          priority: now.millisecondsSinceEpoch,
        ),
      );
    }
    if (await due(MarkerName.topChart, schedule.topChart)) {
      await _queue.enqueue(
        QueueTask(
          id: TaskKind.topChart,
          kind: TaskKind.topChart,
          lane: Lane.api,
          // Чарт важнее обычных замеров: он даёт сразу 100 точек онлайна.
          priority: now
              .subtract(const Duration(hours: 1))
              .millisecondsSinceEpoch,
        ),
      );
    }

    // Работы только с БД выполняются прямо здесь.
    if (await due(MarkerName.topRanks, const Duration(minutes: 5))) {
      final changed = await _games.recomputeTopRanks(
        topSize: _config.topSize,
        freshness: TaskHandlers.topFreshness,
      );
      await _markers.setLastRun(MarkerName.topRanks, now);
      if (changed > 0) _log.fine('Топ: изменились места у $changed игр');
    }
    if (await due(MarkerName.compaction, schedule.compaction)) {
      final removed = await _games.compactPlayerCounts();
      await _markers.setLastRun(MarkerName.compaction, now);
      _log.info('Сжатие онлайна: свёрнуто $removed точек');
    }
  }

  /// Короткий устойчивый ключ пакета: одинаковые пакеты из разных копий
  /// worker получают одинаковый id и не дублируются.
  static String _batchKey(List<int> sortedIds) {
    var hash = 0x811c9dc5;
    for (final id in sortedIds) {
      hash = ((hash ^ id) * 0x01000193) & 0xffffffff;
    }
    return '${sortedIds.first}-${sortedIds.length}-${hash.toRadixString(16)}';
  }
}
