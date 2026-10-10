import 'dart:io';

import 'package:dio/dio.dart';

import '../../features/auth/data/session_manager.dart';

/// Добавляет `Authorization: Bearer` ко всем запросам к API.
/// На 401 один раз входит заново и повторяет запрос.
///
/// QueuedInterceptor обрабатывает запросы по очереди, поэтому при старте
/// приложения несколько параллельных запросов не создадут несколько входов.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this._session, required this._dio});

  final SessionManager _session;

  /// Клиент, через который идут запросы: его настройки и транспорт
  /// используются для повтора после 401.
  final Dio _dio;

  static const _retriedKey = 'auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _session.validToken();
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      handler.next(options);
    } on Object catch (e) {
      // Не удалось войти (например, нет сети): запрос завершается этой ошибкой.
      handler.reject(DioException(requestOptions: options, error: e));
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != HttpStatus.unauthorized ||
        options.extra[_retriedKey] == true) {
      handler.next(err);
      return;
    }
    try {
      await _session.invalidate();
      final token = await _session.validToken();
      options
        ..extra[_retriedKey] = true
        ..headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      // Повтор идёт через отдельный клиент без этого перехватчика: внутри
      // QueuedInterceptor ошибка повтора встала бы в ту же очередь, которую
      // сейчас занимает этот onError, и запрос завис бы навсегда.
      final retry = Dio(_dio.options)
        ..httpClientAdapter = _dio.httpClientAdapter;
      handler.resolve(await retry.fetch<Object?>(options));
    } on DioException catch (e) {
      handler.next(e);
    } on Object catch (e) {
      handler.next(DioException(requestOptions: options, error: e));
    }
  }
}
