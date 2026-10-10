import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../../../core/network/app_exception.dart';

/// Настройки пользователя на сервере (`/me`, `/me/settings`).
class SettingsRepository {
  SettingsRepository(this._dio);

  final Dio _dio;

  Future<UserProfile> fetchProfile() => _guard(() async {
    final response = await _dio.get<Map<String, Object?>>('/me');
    return UserProfile.fromJson(response.data!);
  });

  /// Настройки заменяются целиком.
  Future<UserProfile> saveSettings(UserSettings settings) => _guard(() async {
    final response = await _dio.put<Map<String, Object?>>(
      '/me/settings',
      data: settings.toJson(),
    );
    return UserProfile.fromJson(response.data!);
  });

  static Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on Object catch (e) {
      throw AppException.from(e);
    }
  }
}
