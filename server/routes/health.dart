import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';

/// GET /health — проверка, что сервер жив (для Docker и мониторинга).
Response onRequest(RequestContext context) => jsonResponse({'status': 'ok'});
