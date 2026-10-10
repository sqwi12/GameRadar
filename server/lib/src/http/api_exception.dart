import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

/// Ошибка, которую обработчик превращает в ответ с телом [ApiError].
final class ApiException implements Exception {
  ApiException(
    this.statusCode,
    this.code, [
    this.message,
    this.fields = const [],
  ]);

  ApiException.notFound([String? message])
    : this(HttpStatus.notFound, ApiErrorCode.notFound, message);

  ApiException.unauthorized([String? message])
    : this(HttpStatus.unauthorized, ApiErrorCode.unauthorized, message);

  ApiException.badRequest(String field, String code)
    : this(HttpStatus.badRequest, ApiErrorCode.validation, null, [
        FieldError(field: field, code: code),
      ]);

  ApiException.methodNotAllowed()
    : this(HttpStatus.methodNotAllowed, 'method_not_allowed');

  final int statusCode;
  final String code;
  final String? message;
  final List<FieldError> fields;

  Response toResponse() => jsonResponse(
    ApiError(code: code, message: message, fields: fields).toJson(),
    statusCode: statusCode,
  );

  @override
  String toString() =>
      'ApiException($statusCode $code${message == null ? '' : ': $message'})';
}

/// JSON-ответ с правильной кодировкой.
Response jsonResponse(Object? body, {int statusCode = HttpStatus.ok}) =>
    Response(
      statusCode: statusCode,
      body: jsonEncode(body),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      },
    );

Response noContent() => Response(statusCode: HttpStatus.noContent);

/// Читает тело запроса как JSON-объект и превращает его в модель.
/// Битый JSON или неверные типы полей — ответ 400.
Future<T> readJsonBody<T>(
  Request request,
  T Function(Map<String, Object?> json) fromJson,
) async {
  final Object? decoded;
  try {
    decoded = jsonDecode(await request.body());
  } on FormatException {
    throw ApiException.badRequest('body', FieldErrorCode.invalidFormat);
  }
  if (decoded is! Map<String, Object?>) {
    throw ApiException.badRequest('body', FieldErrorCode.invalidFormat);
  }
  try {
    return fromJson(decoded);
  } on Object {
    // json_serializable бросает TypeError/CheckedFromJsonException при
    // отсутствии обязательных полей или неверных типах.
    throw ApiException.badRequest('body', FieldErrorCode.invalidFormat);
  }
}

/// Бросает 400, если модель запроса не прошла validate().
void ensureValid(List<FieldError> errors) {
  if (errors.isNotEmpty) throw RequestValidationException(errors);
}

/// appid из пути: положительное целое, иначе 404.
int parseAppId(String raw) {
  final id = int.tryParse(raw);
  if (id == null || id <= 0) throw ApiException.notFound('Игра не найдена');
  return id;
}
