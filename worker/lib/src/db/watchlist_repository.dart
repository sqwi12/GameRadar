import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:postgres/postgres.dart';

import '../notifications/notification_policy.dart';

/// Подписка вместе с текущей ценой и настройками пользователя.
typedef WatchRow = ({
  String userId,
  int appId,
  String gameName,
  String locale,
  WatchState watch,
  GamePrice? price,
});

/// Подписка для проверки рекордно низкой цены.
typedef RecordLowRow = ({
  String userId,
  int appId,
  String gameName,
  String locale,
  String timezone,
  QuietHours? quietHours,
  int? initialPrice,
  RecordLowInput input,

  /// О какой цене уже уведомили как о рекорде.
  int? notifiedPrice,

  /// О какой цене уведомили по порогам (чтобы не слать второе уведомление).
  int? lastNotifiedPrice,
});

/// Доступ worker'а к watchlist для уведомлений.
final class WatchlistRepository {
  WatchlistRepository(this._db);

  final Pool<void> _db;

  static const _select = '''
    SELECT w.user_id::text, w.app_id, g.name, u.locale,
           w.target_price, w.min_discount_pct, w.last_notified_price,
           u.notifications_enabled, u.timezone,
           to_char(u.quiet_hours_start, 'HH24:MI'), to_char(u.quiet_hours_end, 'HH24:MI'),
           p.region::text, p.is_available, p.currency::text, p.initial_price, p.final_price,
           p.discount_pct, p.checked_at, p.changed_at
    FROM watchlist w
    JOIN users u ON u.id = w.user_id
    JOIN games g ON g.app_id = w.app_id
    LEFT JOIN game_prices p ON p.app_id = w.app_id AND p.region = w.region
  ''';

  static WatchRow _row(ResultRow r) {
    final start = r[9] as String?;
    final end = r[10] as String?;
    final region = r[11] as String?;
    return (
      userId: r[0]! as String,
      appId: r[1]! as int,
      gameName: r[2]! as String,
      locale: r[3]! as String,
      watch: (
        targetPrice: r[4] as int?,
        minDiscountPct: r[5] as int?,
        lastNotifiedPrice: r[6] as int?,
        notificationsEnabled: r[7]! as bool,
        timezone: r[8]! as String,
        quietHours: start != null && end != null
            ? QuietHours(
                start: ClockTime.parse(start),
                end: ClockTime.parse(end),
              )
            : null,
      ),
      price: region == null
          ? null
          : GamePrice(
              region: region,
              isAvailable: r[12]! as bool,
              currency: r[13] as String?,
              initialPrice: r[14] as int?,
              finalPrice: r[15] as int?,
              discountPct: r[16]! as int,
              checkedAt: r[17]! as DateTime,
              changedAt: r[18]! as DateTime,
            ),
    );
  }

  /// Подписки на игры [appIds] в регионе [region], у которых заданы пороги
  /// или стоит отметка last_notified_price (её, возможно, нужно сбросить).
  Future<List<WatchRow>> forApps(List<int> appIds, String region) async {
    if (appIds.isEmpty) return const [];
    final rows = await _db.execute(
      Sql.named('''
        $_select
        WHERE w.app_id = ANY(@ids:_int4) AND w.region = @region:text
          AND (w.target_price IS NOT NULL OR w.min_discount_pct IS NOT NULL
               OR w.last_notified_price IS NOT NULL)
      '''),
      parameters: {'ids': appIds, 'region': region},
    );
    return rows.map(_row).toList();
  }

  /// Одна подписка (для отложенного уведомления после тихих часов).
  Future<WatchRow?> find(String userId, int appId) async {
    final rows = await _db.execute(
      Sql.named(
        '$_select WHERE w.user_id = CAST(@user:text AS uuid) AND w.app_id = @app:int4',
      ),
      parameters: {'user': userId, 'app': appId},
    );
    return rows.isEmpty ? null : _row(rows.first);
  }

  /// Запоминает цену, о которой уведомили. Условие на старое значение
  /// защищает от гонки двух параллельных проверок: уведомит только одна.
  Future<bool> markNotified(
    String userId,
    int appId,
    int price, {
    required int? previous,
  }) async {
    final result = await _db.execute(
      Sql.named('''
        UPDATE watchlist SET last_notified_price = @price:int8, last_notified_at = now()
        WHERE user_id = CAST(@user:text AS uuid) AND app_id = @app:int4
          AND last_notified_price IS NOT DISTINCT FROM @previous:int8
      '''),
      parameters: {
        'user': userId,
        'app': appId,
        'price': price,
        'previous': previous,
      },
    );
    return result.affectedRows == 1;
  }

  /// Подписки на игры [appIds] для проверки рекордно низкой цены: все
  /// (а не только с порогами), у пользователей с включённой настройкой,
  /// если игра сейчас продаётся со скидкой.
  Future<List<RecordLowRow>> recordLowRows(
    List<int> appIds,
    String region,
  ) async {
    if (appIds.isEmpty) return const [];
    final rows = await _db.execute(
      Sql.named('''
        SELECT w.user_id::text, w.app_id, g.name, u.locale, u.timezone,
               to_char(u.quiet_hours_start, 'HH24:MI'), to_char(u.quiet_hours_end, 'HH24:MI'),
               p.final_price, p.initial_price, p.discount_pct, p.currency::text,
               l.low_price, l.currency::text,
               (SELECT min(h.final_price) FROM price_history h
                WHERE h.app_id = w.app_id AND h.region = w.region
                  AND h.is_available AND h.recorded_at < p.changed_at),
               (SELECT min(h.recorded_at) FROM price_history h
                WHERE h.app_id = w.app_id AND h.region = w.region),
               w.record_low_notified_price, w.last_notified_price
        FROM watchlist w
        JOIN users u ON u.id = w.user_id
        JOIN games g ON g.app_id = w.app_id
        JOIN game_prices p ON p.app_id = w.app_id AND p.region = w.region
        LEFT JOIN game_store_lows l ON l.app_id = w.app_id AND l.region = w.region
        WHERE w.app_id = ANY(@ids:_int4) AND w.region = @region:text
          AND u.notify_record_low AND u.notifications_enabled
          AND p.is_available
      '''),
      parameters: {'ids': appIds, 'region': region},
    );
    return [
      for (final r in rows)
        (
          userId: r[0]! as String,
          appId: r[1]! as int,
          gameName: r[2]! as String,
          locale: r[3]! as String,
          timezone: r[4]! as String,
          quietHours: r[5] != null && r[6] != null
              ? QuietHours(
                  start: ClockTime.parse(r[5]! as String),
                  end: ClockTime.parse(r[6]! as String),
                )
              : null,
          initialPrice: r[8] as int?,
          input: (
            finalPrice: r[7]! as int,
            discountPct: r[9]! as int,
            currency: (r[10]! as String).trim(),
            allTimeLow: r[11] as int?,
            allTimeLowCurrency: (r[12] as String?)?.trim(),
            trackedLow: r[13] as int?,
            trackedSince: r[14] as DateTime?,
          ),
          notifiedPrice: r[15] as int?,
          lastNotifiedPrice: r[16] as int?,
        ),
    ];
  }

  /// Отметка уведомления о рекорде; null — сброс (цена больше не рекордная).
  Future<void> markRecordLowNotified(String userId, int appId, int? price) =>
      _db.execute(
        Sql.named('''
          UPDATE watchlist SET record_low_notified_price = @price:int8
          WHERE user_id = CAST(@user:text AS uuid) AND app_id = @app:int4
        '''),
        parameters: {'user': userId, 'app': appId, 'price': price},
      );

  Future<void> resetNotified(String userId, int appId) => _db.execute(
    Sql.named('''
      UPDATE watchlist SET last_notified_price = NULL
      WHERE user_id = CAST(@user:text AS uuid) AND app_id = @app:int4
    '''),
    parameters: {'user': userId, 'app': appId},
  );
}
