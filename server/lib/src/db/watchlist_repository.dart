import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:postgres/postgres.dart';

import 'rows.dart';

/// Список отслеживания пользователя.
final class WatchlistRepository {
  WatchlistRepository(this._db);

  final Pool<void> _db;

  /// Цена берётся в регионе, зафиксированном при добавлении игры.
  static const _select =
      '''
    SELECT $summaryColumns,
           w.region::text, w.target_price, w.min_discount_pct,
           w.last_notified_price, w.last_notified_at, w.created_at
    FROM watchlist w
    JOIN games g ON g.app_id = w.app_id
    $imageJoin
    LEFT JOIN game_prices p ON p.app_id = w.app_id AND p.region = w.region
  ''';

  static WatchlistItem _read(ResultRow r) {
    const at = summaryColumnCount;
    return WatchlistItem(
      game: readSummary(r),
      region: (r[at]! as String).trim(),
      targetPrice: r[at + 1] as int?,
      minDiscountPct: r[at + 2] as int?,
      lastNotifiedPrice: r[at + 3] as int?,
      lastNotifiedAt: r[at + 4] as DateTime?,
      createdAt: r[at + 5]! as DateTime,
    );
  }

  Future<List<WatchlistItem>> list(String userId) async {
    final rows = await _db.execute(
      Sql.named(
        '$_select WHERE w.user_id = CAST(@user:text AS uuid) ORDER BY w.created_at DESC',
      ),
      parameters: {'user': userId},
    );
    return rows.map(_read).toList();
  }

  Future<WatchlistItem?> find(String userId, int appId) async {
    final rows = await _db.execute(
      Sql.named(
        '$_select WHERE w.user_id = CAST(@user:text AS uuid) AND w.app_id = @app:int4',
      ),
      parameters: {'user': userId, 'app': appId},
    );
    return rows.isEmpty ? null : _read(rows.first);
  }

  Future<int> count(String userId) async {
    final rows = await _db.execute(
      Sql.named(
        'SELECT count(*) FROM watchlist WHERE user_id = CAST(@user:text AS uuid)',
      ),
      parameters: {'user': userId},
    );
    return rows.first[0]! as int;
  }

  /// Добавляет игру или меняет пороги. Если пороги изменились, отметка
  /// last_notified_price сбрасывается: новые условия — новое уведомление.
  /// Возвращает true, если запись создана.
  Future<bool> upsert({
    required String userId,
    required int appId,
    required String region,
    required WatchlistUpsertRequest request,
  }) async {
    final rows = await _db.execute(
      Sql.named('''
        INSERT INTO watchlist (user_id, app_id, region, target_price, min_discount_pct)
        VALUES (CAST(@user:text AS uuid), @app:int4, @region:text, @target:int8, @discount:int2)
        ON CONFLICT (user_id, app_id) DO UPDATE SET
          target_price = EXCLUDED.target_price,
          min_discount_pct = EXCLUDED.min_discount_pct,
          last_notified_price = CASE
            WHEN (watchlist.target_price, watchlist.min_discount_pct)
                 IS DISTINCT FROM (EXCLUDED.target_price, EXCLUDED.min_discount_pct)
            THEN NULL
            ELSE watchlist.last_notified_price
          END
        RETURNING (xmax = 0)
      '''),
      parameters: {
        'user': userId,
        'app': appId,
        'region': region,
        'target': request.targetPrice,
        'discount': request.minDiscountPct,
      },
    );
    return rows.first[0]! as bool;
  }

  /// false — такой записи не было.
  Future<bool> delete(String userId, int appId) async {
    final result = await _db.execute(
      Sql.named(
        'DELETE FROM watchlist WHERE user_id = CAST(@user:text AS uuid) AND app_id = @app:int4',
      ),
      parameters: {'user': userId, 'app': appId},
    );
    return result.affectedRows == 1;
  }
}
