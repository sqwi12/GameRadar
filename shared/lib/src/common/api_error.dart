import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
part 'api_error.g.dart';

/// Машиночитаемые коды ошибок API. Тексты для пользователя приложение
/// подбирает по коду из своих локализаций.
abstract final class ApiErrorCode {
  static const validation = 'validation_error';
  static const unauthorized = 'unauthorized';
  static const notFound = 'not_found';
  static const rateLimited = 'rate_limited';
  static const limitExceeded = 'limit_exceeded';
  static const internal = 'internal_error';
}

/// Коды ошибок отдельных полей.
abstract final class FieldErrorCode {
  static const required = 'required';
  static const outOfRange = 'out_of_range';
  static const invalidFormat = 'invalid_format';
  static const tooLong = 'too_long';
}

/// Ошибка конкретного поля запроса.
@freezed
abstract class FieldError with _$FieldError {
  const factory FieldError({required String field, required String code}) =
      _FieldError;

  factory FieldError.fromJson(Map<String, Object?> json) =>
      _$FieldErrorFromJson(json);
}

/// Тело ответа API с ошибкой (любой статус 4xx/5xx).
@freezed
abstract class ApiError with _$ApiError {
  const factory ApiError({
    required String code,

    /// Текст для разработчика, не для показа пользователю.
    String? message,
    @Default(<FieldError>[]) List<FieldError> fields,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, Object?> json) =>
      _$ApiErrorFromJson(json);
}
