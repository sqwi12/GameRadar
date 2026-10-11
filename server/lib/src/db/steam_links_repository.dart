import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:postgres/postgres.dart';

/// Привязка профиля Steam для импорта списка желаемого. Сервер только
/// сохраняет то, что ввёл пользователь; к Steam ходит worker (правило 2).
final class SteamLinksRepository {
  SteamLinksRepository(this._db);

  final Pool<void> _db;

  static const _columns = '''
    profile_input, status, steam_id, persona_name, wishlist_count,
    imported_count, import_min_discount_pct, synced_at''';

  static SteamLink _read(ResultRow r) => SteamLink(
    profileInput: r[0]! as String,
    status: SteamLinkStatus.values.firstWhere(
      (s) => _statusName(s) == r[1],
      orElse: () => SteamLinkStatus.pending,
    ),
    steamId: r[2] as String?,
    personaName: r[3] as String?,
    wishlistCount: r[4] as int?,
    importedCount: r[5] as int?,
    importMinDiscountPct: r[6]! as int,
    syncedAt: r[7] as DateTime?,
  );

  /// Имя статуса в БД (snake_case, как в JSON).
  static String _statusName(SteamLinkStatus s) => switch (s) {
    SteamLinkStatus.pending => 'pending',
    SteamLinkStatus.ok => 'ok',
    SteamLinkStatus.privateProfile => 'private_profile',
    SteamLinkStatus.notFound => 'not_found',
  };

  Future<SteamLink?> find(String userId) async {
    final rows = await _db.execute(
      Sql.named(
        'SELECT $_columns FROM steam_links WHERE user_id = CAST(@user:text AS uuid)',
      ),
      parameters: {'user': userId},
    );
    return rows.isEmpty ? null : _read(rows.first);
  }

  /// Привязывает профиль или меняет порог. Новая привязка (или другой
  /// профиль) ставится в очередь синхронизации: worker возьмёт её в течение
  /// минуты. Смена только порога тоже применяется при ближайшей синхронизации.
  Future<SteamLink> upsert(String userId, SteamLinkRequest request) async {
    final rows = await _db.execute(
      Sql.named('''
        INSERT INTO steam_links (user_id, profile_input, import_min_discount_pct)
        VALUES (CAST(@user:text AS uuid), @input:text, @pct:int2)
        ON CONFLICT (user_id) DO UPDATE SET
          profile_input = EXCLUDED.profile_input,
          import_min_discount_pct = EXCLUDED.import_min_discount_pct,
          -- Другой профиль — SteamID определяется заново.
          steam_id = CASE WHEN steam_links.profile_input = EXCLUDED.profile_input
                          THEN steam_links.steam_id END,
          status = 'pending'
        RETURNING $_columns
      '''),
      parameters: {
        'user': userId,
        'input': request.profile.trim(),
        'pct': request.importMinDiscountPct,
      },
    );
    return _read(rows.first);
  }

  /// Отвязывает профиль и убирает импортированные игры (добавленные или
  /// изменённые вручную остаются). Возвращает false, если привязки не было.
  Future<bool> delete(String userId) => _db.runTx((tx) async {
    final deleted = await tx.execute(
      Sql.named(
        'DELETE FROM steam_links WHERE user_id = CAST(@user:text AS uuid)',
      ),
      parameters: {'user': userId},
    );
    await tx.execute(
      Sql.named('''
        DELETE FROM watchlist
        WHERE user_id = CAST(@user:text AS uuid) AND source = 'wishlist'
      '''),
      parameters: {'user': userId},
    );
    return deleted.affectedRows == 1;
  });
}
