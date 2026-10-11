import 'package:postgres/postgres.dart';

import '../itad/itad_client.dart';

/// Исторические минимумы цен в Steam (IsThereAnyDeal) — таблица
/// game_store_lows.
final class StoreLowsRepository {
  StoreLowsRepository(this._db);

  final Pool<void> _db;

  /// Игры, минимумы которых пора обновить (раз в сутки): топ, отслеживаемые
  /// и открытые за последнюю неделю. Сначала игры с подписчиками.
  Future<List<int>> due({required String region, required int limit}) async {
    final rows = await _db.execute(
      Sql.named('''
        SELECT g.app_id
        FROM games g
        LEFT JOIN game_store_lows l ON l.app_id = g.app_id AND l.region = @region:text
        WHERE (g.top_rank IS NOT NULL OR g.watchers_count > 0
               OR g.viewed_at > now() - interval '7 days')
          AND (l.checked_at IS NULL OR l.checked_at < now() - interval '1 day')
        ORDER BY g.watchers_count DESC, g.top_rank ASC NULLS LAST, g.app_id
        LIMIT @limit:int4
      '''),
      parameters: {'region': region, 'limit': limit},
    );
    return [for (final r in rows) r[0]! as int];
  }

  /// Уже известные ID игр в ITAD. Игра есть в ответе, если её уже искали;
  /// значение null — ITAD её не знает (повторно ищем раз в 30 дней).
  Future<Map<int, String?>> knownItadIds(List<int> appIds) async {
    if (appIds.isEmpty) return const {};
    final rows = await _db.execute(
      Sql.named('''
        SELECT DISTINCT ON (app_id) app_id, itad_id::text
        FROM game_store_lows
        WHERE app_id = ANY(@ids:_int4)
          AND (itad_id IS NOT NULL OR checked_at > now() - interval '30 days')
        ORDER BY app_id, itad_id NULLS LAST
      '''),
      parameters: {'ids': appIds},
    );
    return {for (final r in rows) r[0]! as int: r[1] as String?};
  }

  /// Сохраняет результат проверки: ID в ITAD и минимум (если есть).
  Future<void> save(
    String region,
    Map<int, ({String? itadId, ItadLow? low})> results,
  ) => _db.runTx((tx) async {
    for (final MapEntry(key: appId, value: r) in results.entries) {
      final low = r.low;
      await tx.execute(
        Sql.named('''
          INSERT INTO game_store_lows
            (app_id, region, itad_id, currency, low_price, regular_price, cut, low_at, checked_at)
          VALUES (@app:int4, @region:text, CAST(@itad:text AS uuid), @currency:text,
                  @price:int8, @regular:int8, @cut:int2, @at:timestamptz, now())
          ON CONFLICT (app_id, region) DO UPDATE SET
            itad_id = EXCLUDED.itad_id,
            currency = EXCLUDED.currency,
            low_price = EXCLUDED.low_price,
            regular_price = EXCLUDED.regular_price,
            cut = EXCLUDED.cut,
            low_at = EXCLUDED.low_at,
            checked_at = now()
        '''),
        parameters: {
          'app': appId,
          'region': region,
          'itad': r.itadId,
          'currency': low?.currency,
          'price': low?.price,
          'regular': low?.regular,
          'cut': low?.cut,
          'at': low?.at,
        },
      );
    }
  });
}
