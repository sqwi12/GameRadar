import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../../../core/network/app_exception.dart';

/// Привязка профиля Steam для импорта списка желаемого (`/me/steam`).
///
/// Приложение только сообщает серверу ссылку или ник; сам Steam читает
/// worker (правила 1 и 2).
class SteamLinkRepository {
  SteamLinkRepository(this._dio);

  final Dio _dio;

  /// null — профиль не привязан.
  Future<SteamLink?> fetch() async {
    try {
      final response = await _dio.get<Map<String, Object?>>('/me/steam');
      return SteamLink.fromJson(response.data!);
    } on Object catch (e) {
      final error = AppException.from(e);
      if (error is ApiFailure && error.statusCode == 404) return null;
      throw error;
    }
  }

  /// Привязывает профиль или меняет порог; сервер ставит синхронизацию
  /// в очередь, ответ приходит со статусом pending.
  Future<SteamLink> save(SteamLinkRequest request) async {
    try {
      final response = await _dio.put<Map<String, Object?>>(
        '/me/steam',
        data: request.toJson(),
      );
      return SteamLink.fromJson(response.data!);
    } on Object catch (e) {
      throw AppException.from(e);
    }
  }

  Future<void> unlink() async {
    try {
      await _dio.delete<void>('/me/steam');
    } on Object catch (e) {
      final error = AppException.from(e);
      // Уже отвязан (например, с другого запуска) — результат тот же.
      if (error is ApiFailure && error.statusCode == 404) return;
      throw error;
    }
  }
}
