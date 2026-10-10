import 'package:logging/logging.dart';

import '../clock.dart';
import '../db/watchlist_repository.dart';
import '../queue/task_queue.dart';
import 'notification_policy.dart';
import 'notifier.dart';

/// Применяет решения [decideNotification] к подпискам: отправляет,
/// откладывает до конца тихих часов или сбрасывает отметку.
final class NotificationService {
  NotificationService({
    required this._watchlist,
    required this._notifier,
    required this._queue,
    required this._clock,
  });

  static final _log = Logger('Notifications');

  final WatchlistRepository _watchlist;
  final Notifier _notifier;
  final TaskQueue _queue;
  final Clock _clock;

  /// Проверяет подписки на игры после обновления их цен.
  Future<void> evaluateApps(List<int> appIds, String region) async {
    for (final row in await _watchlist.forApps(appIds, region)) {
      await _apply(row);
    }
  }

  /// Повторная проверка одной подписки (после тихих часов).
  Future<void> evaluateOne(String userId, int appId) async {
    final row = await _watchlist.find(userId, appId);
    if (row != null) await _apply(row);
  }

  Future<void> _apply(WatchRow row) async {
    final now = _clock.now();
    final decision = decideNotification(
      watch: row.watch,
      price: row.price,
      nowUtc: now,
    );
    switch (decision) {
      case NotifyNow(:final price):
        final p = row.price!;
        final sent = await _notifier.sendPriceAlert((
          userId: row.userId,
          appId: row.appId,
          gameName: row.gameName,
          locale: row.locale,
          finalPrice: price,
          initialPrice: p.initialPrice,
          discountPct: p.discountPct,
          currency: p.currency!,
        ));
        if (sent) {
          await _watchlist.markNotified(
            row.userId,
            row.appId,
            price,
            previous: row.watch.lastNotifiedPrice,
          );
        }
      case DeferUntil(:final until):
        final added = await _queue.enqueue(
          QueueTask(
            id: 'notify:${row.userId}:${row.appId}',
            kind: TaskKind.notify,
            lane: Lane.local,
            priority: until.millisecondsSinceEpoch,
            payload: {'user_id': row.userId, 'app_id': row.appId},
          ),
          delay: until.difference(now),
        );
        if (added) {
          _log.fine(
            'Тихие часы: ${row.userId}/${row.appId} отложено до $until',
          );
        }
      case ResetNotified():
        await _watchlist.resetNotified(row.userId, row.appId);
      case SkipNotification():
        break;
    }
  }
}
