import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/data/session_manager.dart';
import 'config/app_config.dart';
import 'database/app_database.dart';
import 'network/auth_interceptor.dart';
import 'storage/preferences_store.dart';
import 'storage/secure_store.dart';

part 'providers.g.dart';

/// База открывается в main() до запуска приложения и подставляется через override.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) =>
    throw UnimplementedError('appDatabaseProvider задаётся в main()');

/// Локальные настройки, прочитанные из БД до первого кадра
/// (чтобы тема и язык не «мигали» при запуске).
@Riverpod(keepAlive: true)
Map<String, String> initialPreferences(Ref ref) => const {};

@Riverpod(keepAlive: true)
PreferencesStore preferencesStore(Ref ref) =>
    DriftPreferencesStore(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
SecureStore secureStore(Ref ref) => const FlutterSecureStore();

BaseOptions _baseOptions() => BaseOptions(
  baseUrl: AppConfig.apiBaseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 20),
  responseType: ResponseType.json,
  contentType: Headers.jsonContentType,
);

@Riverpod(keepAlive: true)
SessionManager sessionManager(Ref ref) => SessionManager(
  // Отдельный клиент без AuthInterceptor: вход не должен требовать токена.
  authDio: Dio(_baseOptions()),
  store: ref.watch(secureStoreProvider),
  initialSettings: _deviceSettings,
);

/// Начальные настройки из устройства: язык и часовой пояс.
Future<UserSettings> _deviceSettings() async {
  final language = PlatformDispatcher.instance.locale.languageCode;
  String timezone;
  try {
    timezone = (await FlutterTimezone.getLocalTimezone()).identifier;
  } on Object {
    timezone = UserSettings.defaultTimezone;
  }
  return UserSettings(
    locale: language == 'ru' ? AppLocale.ru : AppLocale.en,
    timezone: timezone,
  );
}

/// HTTP-клиент нашего API с автоматическим входом.
@Riverpod(keepAlive: true)
Dio apiClient(Ref ref) {
  final dio = Dio(_baseOptions());
  dio.interceptors.add(
    AuthInterceptor(session: ref.watch(sessionManagerProvider), dio: dio),
  );
  return dio;
}
