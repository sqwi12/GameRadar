import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Подменённый HTTP-транспорт dio: ответы задаёт тест.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;
  final requests = <RequestOptions>[];

  /// Заголовок Authorization в момент каждого запроса (объект RequestOptions
  /// при повторе меняется, поэтому заголовки сохраняются отдельно).
  final authHeaders = <Object?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    requests.add(options);
    authHeaders.add(options.headers['Authorization']);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(Object? body, [int status = 200]) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

/// Ответ сервера на POST /auth/anonymous.
Map<String, Object?> authResponse(String token, DateTime expiresAt) => {
  'access_token': token,
  'expires_at': expiresAt.toUtc().toIso8601String(),
  'user': {
    'id': 'user-1',
    'settings': <String, Object?>{},
    'created_at': '2026-10-11T00:00:00Z',
  },
};

Dio fakeDio(FakeAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter;
