import 'dart:convert';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:postgres/postgres.dart';

import 'rows.dart';

/// Чтение игр для экранов приложения. Только наша БД, без Steam.
final class GamesQueries {
  GamesQueries(this._db);

  final Pool<void> _db;

  /// Скидки старше этого не показываются: если игру перестали отслеживать,
  /// её цена больше не обновляется и закончившаяся распродажа «зависла» бы.
  static const discountFreshness = Duration(hours: 12);

  /// Поиск по названию: сначала точное совпадение, затем начало названия,
  /// затем популярность (подписчики, онлайн) и похожесть.
  Future<Paginated<GameSummary>> search(SearchQuery query) async {
    final text = query.text.trim();
    final rows = await _db.execute(
      Sql.named('''
        SELECT $summaryColumns
        FROM games g
        LEFT JOIN game_prices p ON p.app_id = g.app_id AND p.region = @region:text
        WHERE g.name ILIKE @contains:text
        ORDER BY lower(g.name) = lower(@text:text) DESC,
                 g.name ILIKE @prefix:text DESC,
                 g.watchers_count DESC,
                 g.current_players DESC NULLS LAST,
                 similarity(g.name, @text:text) DESC,
                 g.app_id
        LIMIT @limit:int4
      '''),
      parameters: {
        'region': query.region,
        'text': text,
        'contains': '%${escapeLike(text)}%',
        'prefix': '${escapeLike(text)}%',
        'limit': query.limit,
      },
    );
    return Paginated(
      items: [for (final row in rows) readSummary(row)],
      offset: 0,
      limit: query.limit,
    );
  }

  /// «Топ по онлайну».
  Future<Paginated<GameSummary>> top(TopQuery query) async {
    final order = switch (query.sort) {
      TopSort.current => 'g.top_rank',
      TopSort.peak24h => 'g.peak_24h DESC NULLS LAST, g.top_rank',
    };
    final rows = await _db.execute(
      Sql.named('''
        SELECT $summaryColumns, count(*) OVER ()
        FROM games g
        LEFT JOIN game_prices p ON p.app_id = g.app_id AND p.region = @region:text
        WHERE g.top_rank IS NOT NULL
          AND (NOT @only_discounted:boolean OR (p.is_available AND p.discount_pct > 0))
        ORDER BY $order
        LIMIT @limit:int4 OFFSET @offset:int4
      '''),
      parameters: {
        'region': query.region,
        'only_discounted': query.onlyDiscounted,
        'limit': query.limit,
        'offset': query.offset,
      },
    );
    return _page(rows, query.offset, query.limit);
  }

  /// «Скидки сейчас».
  Future<Paginated<GameSummary>> discounts(DiscountsQuery query) async {
    final order = switch (query.sort) {
      DiscountSort.discount =>
        'p.discount_pct DESC, g.current_players DESC NULLS LAST, g.app_id',
      DiscountSort.price => 'p.final_price ASC, p.discount_pct DESC, g.app_id',
      DiscountSort.players =>
        'g.current_players DESC NULLS LAST, p.discount_pct DESC, g.app_id',
    };
    final rows = await _db.execute(
      Sql.named('''
        SELECT $summaryColumns, count(*) OVER ()
        FROM game_prices p
        JOIN games g ON g.app_id = p.app_id
        WHERE p.region = @region:text
          AND p.is_available
          AND p.discount_pct >= @min_discount:int4
          AND (@max_price:int8 IS NULL OR p.final_price <= @max_price:int8)
          AND p.checked_at > now() - @fresh:int4 * interval '1 second'
        ORDER BY $order
        LIMIT @limit:int4 OFFSET @offset:int4
      '''),
      parameters: {
        'region': query.region,
        'min_discount': query.minDiscountPct,
        'max_price': query.maxPrice,
        'fresh': discountFreshness.inSeconds,
        'limit': query.limit,
        'offset': query.offset,
      },
    );
    return _page(rows, query.offset, query.limit);
  }

  static Paginated<GameSummary> _page(Result rows, int offset, int limit) =>
      Paginated(
        items: [for (final row in rows) readSummary(row)],
        offset: offset,
        limit: limit,
        total: rows.isEmpty ? 0 : rows.first[summaryColumnCount]! as int,
      );

  /// Экран игры или null, если такой игры нет.
  Future<GameDetails?> details(int appId, String region) async {
    final rows = await _db.execute(
      Sql.named('''
        SELECT g.app_id, g.name, g.type, g.is_free, g.header_image_url,
               g.short_description::text, g.developers, g.publishers, g.genres,
               g.release_date::text, g.reviews_positive, g.reviews_total,
               g.current_players, g.peak_24h, g.peak_7d, g.peak_30d,
               g.players_checked_at, g.top_rank, g.details_checked_at,
               $priceColumns
        FROM games g
        LEFT JOIN game_prices p ON p.app_id = g.app_id AND p.region = @region:text
        WHERE g.app_id = @id:int4
      '''),
      parameters: {'id': appId, 'region': region},
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    final positive = r[10] as int?;
    final total = r[11] as int?;
    final release = r[9] as String?;
    return GameDetails(
      appId: r[0]! as int,
      name: r[1]! as String,
      type: GameType.values.asNameMap()[r[2]] ?? GameType.unknown,
      isFree: r[3]! as bool,
      headerImageUrl: r[4] as String?,
      shortDescription: (jsonDecode(r[5]! as String) as Map<String, Object?>)
          .map((k, v) => MapEntry(k, '$v')),
      developers: (r[6]! as List).cast<String>(),
      publishers: (r[7]! as List).cast<String>(),
      genres: (r[8]! as List).cast<String>(),
      releaseDate: release == null
          ? null
          : const DateOnlyConverter().fromJson(release),
      reviews: positive != null && total != null
          ? ReviewSummary(positive: positive, total: total)
          : null,
      players: PlayerStats(
        current: r[12] as int?,
        peak24h: r[13] as int?,
        peak7d: r[14] as int?,
        peak30d: r[15] as int?,
        checkedAt: r[16] as DateTime?,
      ),
      topRank: r[17] as int?,
      detailsCheckedAt: r[18] as DateTime?,
      price: readPrice(r, 19),
    );
  }

  /// Отмечает, что игру открыли: worker сутки будет обновлять её данные.
  /// Не чаще раза в 10 минут, чтобы не писать в БД на каждый просмотр.
  Future<void> markViewed(int appId) => _db.execute(
    Sql.named('''
      UPDATE games SET viewed_at = now()
      WHERE app_id = @id:int4
        AND (viewed_at IS NULL OR viewed_at < now() - interval '10 minutes')
    '''),
    parameters: {'id': appId},
  );

  Future<bool> exists(int appId) async {
    final rows = await _db.execute(
      Sql.named('SELECT 1 FROM games WHERE app_id = @id:int4'),
      parameters: {'id': appId},
    );
    return rows.isNotEmpty;
  }

  /// История онлайна за период. За 30 дней точки сворачиваются до максимума
  /// за час, чтобы график не тянул тысячи точек.
  Future<List<PlayerCountPoint>> playerHistory(
    int appId,
    HistoryPeriod period,
  ) async {
    final hourly = period == HistoryPeriod.month;
    final rows = await _db.execute(
      Sql.named(
        hourly
            ? '''
              SELECT date_trunc('hour', recorded_at) AS at, max(players)
              FROM player_counts
              WHERE app_id = @id:int4 AND recorded_at >= now() - @secs:int4 * interval '1 second'
              GROUP BY at ORDER BY at
            '''
            : '''
              SELECT recorded_at, players
              FROM player_counts
              WHERE app_id = @id:int4 AND recorded_at >= now() - @secs:int4 * interval '1 second'
              ORDER BY recorded_at
            ''',
      ),
      parameters: {'id': appId, 'secs': period.duration.inSeconds},
    );
    return [
      for (final r in rows)
        PlayerCountPoint(recordedAt: r[0]! as DateTime, players: r[1]! as int),
    ];
  }

  /// Последние 200 изменений цены, по возрастанию времени.
  Future<List<PriceHistoryEntry>> priceHistory(int appId, String region) async {
    final rows = await _db.execute(
      Sql.named('''
        SELECT recorded_at, is_available, currency::text, initial_price, final_price, discount_pct
        FROM price_history
        WHERE app_id = @id:int4 AND region = @region:text
        ORDER BY recorded_at DESC
        LIMIT 200
      '''),
      parameters: {'id': appId, 'region': region},
    );
    return [
      for (final r in rows.reversed)
        PriceHistoryEntry(
          recordedAt: r[0]! as DateTime,
          isAvailable: r[1]! as bool,
          currency: (r[2] as String?)?.trim(),
          initialPrice: r[3] as int?,
          finalPrice: r[4] as int?,
          discountPct: r[5]! as int,
        ),
    ];
  }
}
