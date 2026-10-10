import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

/// Ошибки, которые показываются пользователю. Экраны работают только с ними,
/// а не с исключениями dio.
sealed class AppException implements Exception {
  const AppException();

  /// Приводит любую ошибку загрузки к [AppException].
  factory AppException.from(Object error) {
    if (error is AppException) return error;
    if (error is DioException) {
      if (error.error case final AppException inner) return inner;
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.transformTimeout:
          return const NetworkException();
        case DioExceptionType.badResponse:
          final response = error.response!;
          return ApiFailure(response.statusCode ?? 0, _apiError(response.data));
        case DioExceptionType.badCertificate:
        case DioExceptionType.cancel:
        case DioExceptionType.unknown:
          return UnknownException(error);
      }
    }
    return UnknownException(error);
  }

  static ApiError? _apiError(Object? data) {
    if (data is! Map<String, Object?>) return null;
    try {
      return ApiError.fromJson(data);
    } on Object {
      return null;
    }
  }
}

/// Нет связи с сервером: показываем кэш и предлагаем повторить.
final class NetworkException extends AppException {
  const NetworkException();

  @override
  String toString() => 'NetworkException';
}

/// Сервер ответил ошибкой.
final class ApiFailure extends AppException {
  const ApiFailure(this.statusCode, this.error);

  final int statusCode;
  final ApiError? error;

  String? get code => error?.code;

  @override
  String toString() => 'ApiFailure($statusCode, ${error?.code})';
}

final class UnknownException extends AppException {
  const UnknownException(this.cause);

  final Object cause;

  @override
  String toString() => 'UnknownException($cause)';
}
