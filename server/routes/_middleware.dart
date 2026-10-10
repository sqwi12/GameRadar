import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';

/// Общие для всех маршрутов: зависимости, обработка ошибок, журнал.
Handler middleware(Handler handler) =>
    handler.use(provider<Services>((_) => appServices)).use(errorsAndLogging());
