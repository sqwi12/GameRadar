import 'app_exception.dart';

/// Выполняет запрос к API и приводит любую ошибку к [AppException].
Future<T> apiCall<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on Object catch (e) {
    throw AppException.from(e);
  }
}

/// Ответ API как JSON-объект.
Map<String, Object?> asJsonMap(Object? data) => data! as Map<String, Object?>;
