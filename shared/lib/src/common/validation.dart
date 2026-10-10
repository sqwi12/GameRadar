import 'api_error.dart';

/// Ошибка разбора или проверки запроса. Сервер превращает её в ответ 400
/// с [ApiErrorCode.validation], приложение может проверить данные заранее.
final class RequestValidationException implements Exception {
  RequestValidationException(this.errors) : assert(errors.isNotEmpty);

  final List<FieldError> errors;

  ApiError toApiError() =>
      ApiError(code: ApiErrorCode.validation, fields: errors);

  @override
  String toString() =>
      'RequestValidationException(${errors.map((e) => '${e.field}: ${e.code}').join(', ')})';
}

/// Собирает ошибки полей при проверке запроса.
final class Validator {
  final List<FieldError> _errors = [];

  List<FieldError> get errors => List.unmodifiable(_errors);

  void add(String field, String code) =>
      _errors.add(FieldError(field: field, code: code));

  void range(String field, num? value, {num? min, num? max}) {
    if (value == null) return;
    if ((min != null && value < min) || (max != null && value > max)) {
      add(field, FieldErrorCode.outOfRange);
    }
  }

  /// Бросает [RequestValidationException], если есть ошибки.
  void throwIfInvalid() {
    if (_errors.isNotEmpty) throw RequestValidationException(errors);
  }
}

/// Разбор необязательного целого из query-параметров.
int? parseIntParam(
  Map<String, String> params,
  String name,
  Validator validator,
) {
  final raw = params[name];
  if (raw == null || raw.isEmpty) return null;
  final value = int.tryParse(raw);
  if (value == null) validator.add(name, FieldErrorCode.invalidFormat);
  return value;
}

/// Разбор enum из query-параметра по его [wireName].
T? parseEnumParam<T extends Enum>(
  Map<String, String> params,
  String name,
  List<T> values,
  String Function(T value) wireName,
  Validator validator,
) {
  final raw = params[name];
  if (raw == null || raw.isEmpty) return null;
  for (final value in values) {
    if (wireName(value) == raw) return value;
  }
  validator.add(name, FieldErrorCode.invalidFormat);
  return null;
}
