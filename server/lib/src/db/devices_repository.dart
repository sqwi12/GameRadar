import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:postgres/postgres.dart';

/// FCM-токены устройств.
final class DevicesRepository {
  DevicesRepository(this._db);

  final Pool<void> _db;

  /// Регистрирует токен за пользователем. Если токен раньше принадлежал
  /// другому пользователю (переустановка приложения), он переходит к новому.
  Future<void> upsert(String userId, DeviceRegisterRequest request) =>
      _db.execute(
        Sql.named('''
      INSERT INTO devices (user_id, fcm_token, platform)
      VALUES (CAST(@user:text AS uuid), @token:text, @platform:text)
      ON CONFLICT (fcm_token) DO UPDATE SET
        user_id = EXCLUDED.user_id,
        platform = EXCLUDED.platform
    '''),
        parameters: {
          'user': userId,
          'token': request.fcmToken,
          'platform': request.platform.name,
        },
      );

  /// Удаляет токен, только если он принадлежит пользователю.
  Future<void> delete(String userId, String fcmToken) => _db.execute(
    Sql.named('''
      DELETE FROM devices
      WHERE user_id = CAST(@user:text AS uuid) AND fcm_token = @token:text
    '''),
    parameters: {'user': userId, 'token': fcmToken},
  );
}
