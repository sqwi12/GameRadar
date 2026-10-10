import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:logging/logging.dart';

import '../services.dart';
import 'api_exception.dart';
import 'handlers.dart';

final _log = Logger('Http');

/// Превращает исключения в JSON-ответы с [ApiError] и пишет журнал запросов.
Middleware errorsAndLogging() =>
    (handler) => (context) async {
      final started = DateTime.now();
      final request = context.request;
      Response response;
      try {
        response = await handler(context);
      } on ApiException catch (e) {
        response = e.toResponse();
      } on RequestValidationException catch (e) {
        response = jsonResponse(
          e.toApiError().toJson(),
          statusCode: HttpStatus.badRequest,
        );
      } catch (e, st) {
        _log.severe('${request.method.value} ${request.uri.path}', e, st);
        response = jsonResponse(
          const ApiError(code: ApiErrorCode.internal).toJson(),
          statusCode: HttpStatus.internalServerError,
        );
      }
      final ms = DateTime.now().difference(started).inMilliseconds;
      // Только путь, без query: в нём может быть поисковый запрос пользователя.
      _log.info(
        '${request.method.value} ${request.uri.path} → ${response.statusCode} ($ms мс)',
      );
      return response;
    };

/// Пропускает дальше только запросы с действительным токеном
/// и кладёт [AuthUser] в контекст.
Middleware requireAuth() =>
    (handler) => (context) {
      final user = authenticate(context.request, context.read<Services>());
      return handler(context.provide<AuthUser>(() => user));
    };

/// Выбор обработчика по HTTP-методу; остальные методы — 405.
Future<Response> byMethod(
  RequestContext context,
  Map<HttpMethod, Future<Response> Function()> handlers,
) {
  final handler = handlers[context.request.method];
  if (handler == null) throw ApiException.methodNotAllowed();
  return handler();
}
