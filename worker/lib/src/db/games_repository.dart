import 'dart:convert';

import 'package:gameradar_shared/steam.dart';
import 'package:postgres/postgres.dart';

/// Игра, которой пора обновить какие-то данные.
typedef DueGame = ({int appId, DateTime? checkedAt, int watchers});

/// Доступ worker'а к таблицам games, game_prices, player_counts.
/// Все времена проверок ставит PostgreSQL (`now()`), чтобы не зависеть
/// от часов контейнера.
final class GamesRepository {
  GamesRepository(this._db);

  final Pool<void> _db;

  static List<DueGame> _dueGames(Result rows) => [
    for (final row in rows)
      (
        appId: row[0]! as int,
        checkedAt: row[1] as DateTime?,
        watchers: row[2]! as int,
      ),
  ];

  // ---------------------------------------------------------------- цены

  /// Отслеживаемые игры и топ, цену которых пора обновить (правило 5):
  /// сначала с большим числом подписчиков, затем давно не проверявшиеся.
  Future<List<DueGame>> duePrices({
    required String region,
    required Duration minAge,
    required int limit,
  }) async => _dueGames(
    await _db.execute(
      Sql.named('''
        SELECT g.app_id, p.checked_at, g.watchers_count
        FROM games g
        LEFT JOIN game_prices p ON p.app_id = g.app_id AND p.region = @region:text
        WHERE (g.watchers_count > 0 OR g.top_rank IS NOT NULL)
          AND (p.checked_at IS NULL OR p.checked_at < now() - @min_age:int4 * interval '1 second')
        ORDER BY g.watchers_count DESC, p.checked_at ASC NULLS FIRST
        LIMIT @limit:int4
      '''),
      parameters: {
        'region': region,
        'min_age': minAge.inSeconds,
        'limit': limit,
      },
    ),
  );

  /// Сохраняет цены пакета. История изменений пишется триггером в БД.
  Future<void> savePrices(String region, Iterable<SteamPriceOverview> prices) =>
      _db.runTx((tx) => _savePrices(tx, region, prices));

  static Future<void> _savePrices(
    Session tx,
    String region,
    Iterable<SteamPriceOverview> prices,
  ) async {
    final statement = await tx.prepare(
      Sql.named('''
        INSERT INTO game_prices
          (app_id, region, is_available, currency, initial_price, final_price, discount_pct, checked_at)
        VALUES (@app_id:int4, @region:text, @available:boolean, @currency:text,
                @initial:int8, @final:int8, @discount:int2, now())
        ON CONFLICT (app_id, region) DO UPDATE SET
          is_available  = EXCLUDED.is_available,
          currency      = EXCLUDED.currency,
          initial_price = EXCLUDED.initial_price,
          final_price   = EXCLUDED.final_price,
          discount_pct  = EXCLUDED.discount_pct,
          checked_at    = EXCLUDED.checked_at
      '''),
    );
    try {
      for (final p in prices) {
        await statement.run({
          'app_id': p.appId,
          'region': region,
          'available': p.hasPrice,
          'currency': p.hasPrice ? p.currency : null,
          'initial': p.hasPrice ? p.initialPrice : null,
          'final': p.hasPrice ? p.finalPrice : null,
          'discount': p.hasPrice ? p.discountPct : 0,
        });
      }
    } finally {
      await statement.dispose();
    }
  }

  /// Отмечает проверку игр, о которых Steam ничего не вернул в пакете,
  /// чтобы они не запрашивались снова в каждом цикле.
  Future<void> touchPricesChecked(String region, List<int> appIds) async {
    if (appIds.isEmpty) return;
    await _db.execute(
      Sql.named('''
        UPDATE game_prices SET checked_at = now()
        WHERE region = @region:text AND app_id = ANY(@ids:_int4)
      '''),
      parameters: {'region': region, 'ids': appIds},
    );
  }

  // --------------------------------------------------------------- онлайн

  /// Порог входа в топ: онлайн игры на последнем месте топа (0, если топ не полон).
  Future<int> topThreshold(int topSize) async {
    final rows = await _db.execute(
      Sql.named(
        'SELECT current_players FROM games WHERE top_rank = @n:int4 LIMIT 1',
      ),
      parameters: {'n': topSize},
    );
    return rows.isEmpty ? 0 : (rows.first[0] as int?) ?? 0;
  }

  /// Кандидаты в топ, онлайн которых пора обновить: игры из топа и игры,
  /// чей пик за 24 ч не ниже порога входа в топ (правила 5–6).
  Future<List<DueGame>> dueTopPlayers({
    required int threshold,
    required Duration minAge,
    required int limit,
  }) async => _dueGames(
    await _db.execute(
      Sql.named('''
        SELECT app_id, players_checked_at, watchers_count
        FROM games
        WHERE (top_rank IS NOT NULL OR (peak_24h > 0 AND peak_24h >= @threshold:int4))
          AND (players_checked_at IS NULL
               OR players_checked_at < now() - @min_age:int4 * interval '1 second')
        ORDER BY players_checked_at ASC NULLS FIRST
        LIMIT @limit:int4
      '''),
      parameters: {
        'threshold': threshold,
        'min_age': minAge.inSeconds,
        'limit': limit,
      },
    ),
  );

  /// Отслеживаемые игры вне топа, онлайн которых пора обновить.
  Future<List<DueGame>> dueWatchedPlayers({
    required int threshold,
    required Duration minAge,
    required int limit,
  }) async => _dueGames(
    await _db.execute(
      Sql.named('''
        SELECT app_id, players_checked_at, watchers_count
        FROM games
        WHERE watchers_count > 0
          AND top_rank IS NULL
          AND NOT (peak_24h > 0 AND peak_24h >= @threshold:int4)
          AND (players_checked_at IS NULL
               OR players_checked_at < now() - @min_age:int4 * interval '1 second')
        ORDER BY watchers_count DESC, players_checked_at ASC NULLS FIRST
        LIMIT @limit:int4
      '''),
      parameters: {
        'threshold': threshold,
        'min_age': minAge.inSeconds,
        'limit': limit,
      },
    ),
  );

  /// Игры, онлайн которых ни разу не замеряли (или очень давно): из них
  /// находятся новые кандидаты в топ. Опрашиваются только в простое.
  Future<List<int>> discoveryCandidates({
    required Duration minAge,
    required int limit,
  }) async {
    final rows = await _db.execute(
      Sql.named('''
        SELECT app_id FROM games
        WHERE (type IS NULL OR type = 'game')
          AND (players_checked_at IS NULL
               OR players_checked_at < now() - @min_age:int4 * interval '1 second')
        ORDER BY players_checked_at ASC NULLS FIRST, app_id DESC
        LIMIT @limit:int4
      '''),
      parameters: {'min_age': minAge.inSeconds, 'limit': limit},
    );
    return [for (final row in rows) row[0]! as int];
  }

  /// Сохраняет замер онлайна и пересчитывает пики (правило 7).
  /// [players] == null — у игры нет статистики: только отмечаем проверку.
  Future<void> savePlayers(int appId, int? players) async {
    if (players == null) {
      await _db.execute(
        Sql.named(
          'UPDATE games SET players_checked_at = now() WHERE app_id = @id:int4',
        ),
        parameters: {'id': appId},
      );
      return;
    }
    await savePlayerBatch({appId: players});
  }

  /// Сохраняет пачку замеров (например, из чарта Steam) одним запросом.
  Future<void> savePlayerBatch(Map<int, int> playersByApp) async {
    if (playersByApp.isEmpty) return;
    final ids = playersByApp.keys.toList();
    final counts = [for (final id in ids) playersByApp[id]!];
    await _db.execute(
      Sql.named('''
        WITH input AS (
          SELECT * FROM unnest(@ids:_int4, @counts:_int4) AS t(app_id, players)
          WHERE EXISTS (SELECT 1 FROM games g WHERE g.app_id = t.app_id)
        ), points AS (
          INSERT INTO player_counts (app_id, recorded_at, players)
          SELECT app_id, now(), players FROM input
          ON CONFLICT DO NOTHING
        )
        UPDATE games g
        SET current_players = i.players, players_checked_at = now()
        FROM input i
        WHERE g.app_id = i.app_id
      '''),
      parameters: {'ids': ids, 'counts': counts},
    );
    await _db.execute(
      Sql.named('SELECT refresh_player_peaks(@ids:_int4)'),
      parameters: {'ids': ids},
    );
  }

  /// Пересчитывает места в топе по последним замерам онлайна.
  /// Учитываются только свежие замеры, чтобы игра не держалась в топе
  /// по устаревшим данным.
  Future<int> recomputeTopRanks({
    required int topSize,
    required Duration freshness,
  }) async {
    final result = await _db.execute(
      Sql.named('''
        WITH ranked AS (
          SELECT app_id, row_number() OVER (ORDER BY current_players DESC, app_id) AS rn
          FROM games
          WHERE current_players > 0
            AND players_checked_at > now() - @fresh:int4 * interval '1 second'
          ORDER BY current_players DESC, app_id
          LIMIT @top:int4
        ), affected AS (
          SELECT app_id FROM games WHERE top_rank IS NOT NULL
          UNION
          SELECT app_id FROM ranked
        )
        UPDATE games g
        SET top_rank = r.rn
        FROM affected a
        LEFT JOIN ranked r ON r.app_id = a.app_id
        WHERE g.app_id = a.app_id AND g.top_rank IS DISTINCT FROM r.rn
      '''),
      parameters: {'top': topSize, 'fresh': freshness.inSeconds},
    );
    return result.affectedRows;
  }

  /// Сжимает старые точки онлайна до максимума за час (правило 7).
  Future<int> compactPlayerCounts() async {
    final rows = await _db.execute('SELECT compact_player_counts()');
    return rows.first[0]! as int;
  }

  // ------------------------------------------------- описания и отзывы

  /// Отслеживаемые игры и топ, у которых пора обновить описание или отзывы.
  Future<List<DueGame>> dueDetails({
    required Duration minAge,
    required int limit,
  }) => _dueByColumn('details_checked_at', minAge, limit);

  Future<List<DueGame>> dueReviews({
    required Duration minAge,
    required int limit,
  }) => _dueByColumn('reviews_checked_at', minAge, limit);

  Future<List<DueGame>> _dueByColumn(
    String column,
    Duration minAge,
    int limit,
  ) async => _dueGames(
    await _db.execute(
      // column — только из фиксированного списка выше, не из ввода.
      Sql.named('''
            SELECT app_id, $column, watchers_count
            FROM games
            WHERE (watchers_count > 0 OR top_rank IS NOT NULL)
              AND ($column IS NULL OR $column < now() - @min_age:int4 * interval '1 second')
            ORDER BY watchers_count DESC, $column ASC NULLS FIRST
            LIMIT @limit:int4
          '''),
      parameters: {'min_age': minAge.inSeconds, 'limit': limit},
    ),
  );

  /// Сохраняет описание. [details] == null — Steam не отдал данные,
  /// отмечаем только время проверки.
  Future<void> saveDetails(
    int appId,
    SteamAppDetails? details,
    Map<String, String> descriptions,
  ) async {
    if (details == null) {
      await _db.execute(
        Sql.named(
          'UPDATE games SET details_checked_at = now() WHERE app_id = @id:int4',
        ),
        parameters: {'id': appId},
      );
      return;
    }
    await _db.execute(
      Sql.named('''
        UPDATE games SET
          name = @name:text,
          type = @type:text,
          is_free = @is_free:boolean,
          header_image_url = @header:text,
          short_description = CAST(@descriptions:text AS jsonb),
          developers = @developers:_text,
          publishers = @publishers:_text,
          genres = @genres:_text,
          release_date = CAST(@release:text AS date),
          details_checked_at = now()
        WHERE app_id = @id:int4
      '''),
      parameters: {
        'id': appId,
        'name': details.name,
        'type': details.type,
        'is_free': details.isFree,
        'header': details.headerImageUrl,
        'descriptions': jsonEncode(descriptions),
        'developers': details.developers,
        'publishers': details.publishers,
        'genres': details.genres,
        'release': details.releaseDate?.toIso8601String().substring(0, 10),
      },
    );
  }

  Future<void> saveReviews(int appId, SteamReviewSummary reviews) =>
      _db.execute(
        Sql.named('''
      UPDATE games SET
        reviews_positive = @positive:int4,
        reviews_total = @total:int4,
        reviews_checked_at = now()
      WHERE app_id = @id:int4
    '''),
        parameters: {
          'id': appId,
          'positive': reviews.totalPositive,
          'total': reviews.totalReviews,
        },
      );

  // ------------------------------------------------------ список игр

  /// Добавляет новые игры и обновляет изменившиеся названия.
  /// Возвращает число добавленных или изменённых строк.
  Future<int> upsertAppList(List<SteamAppListEntry> apps) async {
    if (apps.isEmpty) return 0;
    final result = await _db.execute(
      Sql.named('''
        INSERT INTO games (app_id, name)
        SELECT * FROM unnest(@ids:_int4, @names:_text)
        ON CONFLICT (app_id) DO UPDATE SET name = EXCLUDED.name
        WHERE games.name IS DISTINCT FROM EXCLUDED.name
      '''),
      parameters: {
        'ids': [for (final a in apps) a.appId],
        'names': [for (final a in apps) a.name],
      },
    );
    return result.affectedRows;
  }

  /// Добавляет игры, которых ещё нет в каталоге (например, из чарта Steam
  /// до первой синхронизации списка). Название уточнит задача описаний.
  Future<void> ensureGamesExist(Iterable<int> appIds) async {
    final ids = appIds.toList();
    if (ids.isEmpty) return;
    await _db.execute(
      Sql.named('''
        INSERT INTO games (app_id, name)
        SELECT id, 'App ' || id FROM unnest(@ids:_int4) AS id
        ON CONFLICT (app_id) DO NOTHING
      '''),
      parameters: {'ids': ids},
    );
  }
}
