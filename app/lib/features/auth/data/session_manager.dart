import 'dart:async';

import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:uuid/uuid.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/storage/secure_store.dart';

/// Анонимная сессия: ID устройства и JWT нашего сервера.
///
/// ID устройства — случайный UUID, созданный при первом запуске и сохранённый
/// в защищённом хранилище. Аппаратные идентификаторы не используются.
class SessionManager {
  SessionManager({
    required Dio authDio,
    required this._store,
    required this._initialSettings,
    DateTime Function()? now,
  }) : _dio = authDio,
       _now = now ?? DateTime.now;

  static const deviceIdKey = 'device_id';
  static const tokenKey = 'access_token';
  static const expiresAtKey = 'access_token_expires_at';

  /// Токен обновляется заранее, за сутки до истечения.
  static const renewBefore = Duration(days: 1);

  final Dio _dio;
  final SecureStore _store;
  final Future<UserSettings> Function() _initialSettings;
  final DateTime Function() _now;

  String? _token;
  DateTime? _expiresAt;
  Future<String>? _signingIn;

  /// Действующий токен; при необходимости выполняет вход.
  /// Параллельные вызовы ждут один и тот же вход.
  Future<String> validToken() async {
    if (_token == null) {
      _token = await _store.read(tokenKey);
      _expiresAt = DateTime.tryParse(await _store.read(expiresAtKey) ?? '');
    }
    final token = _token;
    final expiresAt = _expiresAt;
    if (token != null &&
        expiresAt != null &&
        expiresAt.difference(_now()) > renewBefore) {
      return token;
    }
    return _signingIn ??= _signIn().whenComplete(() => _signingIn = null);
  }

  /// Сбрасывает токен (сервер ответил 401): следующий запрос войдёт заново.
  Future<void> invalidate() async {
    _token = null;
    _expiresAt = null;
    await _store.delete(tokenKey);
    await _store.delete(expiresAtKey);
  }

  Future<String> deviceId() async {
    final existing = await _store.read(deviceIdKey);
    if (existing != null) return existing;
    final created = const Uuid().v4();
    await _store.write(deviceIdKey, created);
    return created;
  }

  Future<String> _signIn() async {
    final request = AnonymousAuthRequest(
      deviceId: await deviceId(),
      initialSettings: await _initialSettings(),
    );
    final Response<Map<String, Object?>> response;
    try {
      response = await _dio.post<Map<String, Object?>>(
        '/auth/anonymous',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw AppException.from(e);
    }
    final auth = AuthResponse.fromJson(response.data!);
    _token = auth.accessToken;
    _expiresAt = auth.expiresAt;
    await _store.write(tokenKey, auth.accessToken);
    await _store.write(expiresAtKey, auth.expiresAt.toIso8601String());
    return auth.accessToken;
  }
}
