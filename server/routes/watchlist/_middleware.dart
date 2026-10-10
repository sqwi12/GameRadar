import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';

/// Все маршруты внутри требуют токен.
Handler middleware(Handler handler) => handler.use(requireAuth());
