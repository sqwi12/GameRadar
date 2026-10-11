import 'package:postgres/postgres.dart';

/// FCM-токены пользователя для отправки уведомлений.
abstract interface class DeviceTokens {
  Future<List<String>> tokensOf(String userId);

  /// Удаляет токен, который FCM считает недействительным.
  Future<void> deleteToken(String token);
}

/// FCM-токены устройств в PostgreSQL.
final class DevicesRepository implements DeviceTokens {
  DevicesRepository(this._db);

  final Pool<void> _db;

  @override
  Future<List<String>> tokensOf(String userId) async {
    final rows = await _db.execute(
      Sql.named(
        'SELECT fcm_token FROM devices WHERE user_id = CAST(@user:text AS uuid) ORDER BY updated_at DESC',
      ),
      parameters: {'user': userId},
    );
    return [for (final r in rows) r[0]! as String];
  }

  @override
  Future<void> deleteToken(String token) => _db.execute(
    Sql.named('DELETE FROM devices WHERE fcm_token = @token:text'),
    parameters: {'token': token},
  );
}
