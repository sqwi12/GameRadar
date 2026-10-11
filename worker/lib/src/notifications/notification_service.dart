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
    await _evaluateRecordLows(appIds, region);
  }

  /// Рекордно низкие цены: уведомление один раз на каждую новую рекордную
  /// цену. Если по порогам об этой цене уже уведомили — второе не шлём.
  /// В тихие часы ничего не отмечаем: после них следующая проверка цены
  /// найдёт рекорд снова и уведомит.
  Future<void> _evaluateRecordLows(List<int> appIds, String region) async {
    final now = _clock.now();
    for (final row in await _watchlist.recordLowRows(appIds, region)) {
      final price = row.input.finalPrice;
      final record = recordLowOf(row.input, nowUtc: now);
      if (record == null) {
        if (row.notifiedPrice != null) {
          await _watchlist.markRecordLowNotified(row.userId, row.appId, null);
        }
        continue;
      }
      final notified = row.notifiedPrice;
      if (notified != null && price >= notified) continue;
      if (row.lastNotifiedPrice == price) {
        // Уведомление по порогу уже пришло — второго о той же цене не нужно.
        await _watchlist.markRecordLowNotified(row.userId, row.appId, price);
        continue;
      }
      if (inQuietHours(row.quietHours, row.timezone, now)) continue;
      final sent = await _notifier.sendPriceAlert((
        userId: row.userId,
        appId: row.appId,
        gameName: row.gameName,
        locale: row.locale,
        finalPrice: price,
        initialPrice: row.initialPrice,
        discountPct: row.input.discountPct,
        currency: row.input.currency,
        recordLow: record.kind,
        trackedDays: record.trackedDays,
      ));
      if (sent) {
        await _watchlist.markRecordLowNotified(row.userId, row.appId, price);
        _log.info(
          'Рекорд: ${row.userId}/${row.appId} $price (${record.kind.name})',
        );
      }
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
          recordLow: null,
          trackedDays: null,
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
