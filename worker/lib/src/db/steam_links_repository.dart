import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:postgres/postgres.dart';

/// Привязка профиля Steam, которую нужно синхронизировать.
typedef SteamLinkJob = ({
  String userId,
  String profileInput,
  String? steamId,
  int minDiscountPct,
  String region,
});

/// Импорт списка желаемого Steam в отслеживаемые.
final class SteamLinksRepository {
  SteamLinksRepository(this._db);

  final Pool<void> _db;

  /// Привязки, которые пора синхронизировать: новые и проверенные больше
  /// суток назад. «Профиль не найден» не повторяется — пользователь введёт заново.
  Future<List<String>> dueUserIds({required int limit}) async {
    final rows = await _db.execute(
      Sql.named('''
        SELECT user_id::text FROM steam_links
        WHERE status = 'pending'
           OR (status IN ('ok', 'private_profile') AND synced_at < now() - interval '1 day')
        ORDER BY synced_at ASC NULLS FIRST
        LIMIT @limit:int4
      '''),
      parameters: {'limit': limit},
    );
    return [for (final r in rows) r[0]! as String];
  }

  Future<SteamLinkJob?> job(String userId) async {
    final rows = await _db.execute(
      Sql.named('''
        SELECT l.user_id::text, l.profile_input, l.steam_id, l.import_min_discount_pct, u.region::text
        FROM steam_links l JOIN users u ON u.id = l.user_id
        WHERE l.user_id = CAST(@user:text AS uuid)
      '''),
      parameters: {'user': userId},
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    return (
      userId: r[0]! as String,
      profileInput: r[1]! as String,
      steamId: r[2] as String?,
      minDiscountPct: r[3]! as int,
      region: (r[4]! as String).trim(),
    );
  }

  /// Итог без импорта: профиль не найден или скрыт.
  Future<void> markStatus(
    String userId,
    String status, {
    String? steamId,
    String? personaName,
  }) => _db.execute(
    Sql.named('''
      UPDATE steam_links SET
        status = @status:text,
        steam_id = COALESCE(@steam_id:text, steam_id),
        persona_name = COALESCE(@persona:text, persona_name),
        synced_at = now()
      WHERE user_id = CAST(@user:text AS uuid)
    '''),
    parameters: {
      'user': userId,
      'status': status,
      'steam_id': steamId,
      'persona': personaName,
    },
  );

  /// Синхронизирует список отслеживания со списком желаемого:
  /// - новые игры добавляются с порогом скидки привязки (пока есть место
  ///   в лимите списка), в порядке приоритета пользователя в Steam;
  /// - игры, убранные из списка желаемого, удаляются, но только импортированные:
  ///   добавленные или изменённые вручную не трогаются;
  /// - порог у импортированных игр обновляется, если его сменили в привязке.
  /// Возвращает число импортированных игр в списке.
  Future<int> importWishlist(
    SteamLinkJob job,
    String steamId,
    String? personaName,
    List<int> appIds,
  ) => _db.runTx((tx) async {
    final params = {'user': job.userId, 'ids': appIds};
    if (appIds.isNotEmpty) {
      // Игры, которых ещё нет в каталоге: название подставит задача описаний.
      await tx.execute(
        Sql.named('''
          INSERT INTO games (app_id, name)
          SELECT id, 'App ' || id FROM unnest(@ids:_int4) AS id
          ON CONFLICT (app_id) DO NOTHING
        '''),
        parameters: {'ids': appIds},
      );
    }
    await tx.execute(
      Sql.named('''
        DELETE FROM watchlist
        WHERE user_id = CAST(@user:text AS uuid) AND source = 'wishlist'
          AND NOT (app_id = ANY(@ids:_int4))
      '''),
      parameters: params,
    );
    await tx.execute(
      Sql.named('''
        UPDATE watchlist SET min_discount_pct = @pct:int2
        WHERE user_id = CAST(@user:text AS uuid) AND source = 'wishlist'
          AND min_discount_pct IS DISTINCT FROM @pct:int2
      '''),
      parameters: {'user': job.userId, 'pct': job.minDiscountPct},
    );
    await tx.execute(
      Sql.named('''
        INSERT INTO watchlist (user_id, app_id, region, min_discount_pct, source)
        SELECT CAST(@user:text AS uuid), t.id, @region:text, @pct:int2, 'wishlist'
        FROM unnest(@ids:_int4) WITH ORDINALITY AS t(id, ord)
        WHERE NOT EXISTS (
          SELECT 1 FROM watchlist w
          WHERE w.user_id = CAST(@user:text AS uuid) AND w.app_id = t.id
        )
        ORDER BY t.ord
        LIMIT GREATEST(0, @max:int4 - (
          SELECT count(*) FROM watchlist WHERE user_id = CAST(@user:text AS uuid)
        ))
        ON CONFLICT DO NOTHING
      '''),
      parameters: {
        ...params,
        'region': job.region,
        'pct': job.minDiscountPct,
        'max': WatchlistLimits.maxItems,
      },
    );
    final imported =
        (await tx.execute(
              Sql.named('''
                SELECT count(*) FROM watchlist
                WHERE user_id = CAST(@user:text AS uuid) AND source = 'wishlist'
              '''),
              parameters: {'user': job.userId},
            )).first[0]!
            as int;
    await tx.execute(
      Sql.named('''
        UPDATE steam_links SET
          status = 'ok', steam_id = @steam_id:text, persona_name = @persona:text,
          wishlist_count = @total:int4, imported_count = @imported:int4, synced_at = now()
        WHERE user_id = CAST(@user:text AS uuid)
      '''),
      parameters: {
        'user': job.userId,
        'steam_id': steamId,
        'persona': personaName,
        'total': appIds.length,
        'imported': imported,
      },
    );
    return imported;
  });
}
