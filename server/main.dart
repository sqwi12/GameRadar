import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';
import 'package:logging/logging.dart';

/// Вызывается один раз при старте: журнал, настройки, подключение к БД.
Future<void> init(InternetAddress ip, int port) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((r) {
    final error = r.error == null ? '' : ' | ${r.error}';
    stdout.writeln(
      '${r.time.toUtc().toIso8601String()} ${r.level.name} ${r.loggerName}: ${r.message}$error',
    );
    if (r.stackTrace != null && r.level >= Level.SEVERE) {
      stdout.writeln(r.stackTrace);
    }
  });
  try {
    appServices = Services.fromConfig(ServerConfig.fromEnvironment());
  } on StateError catch (e) {
    stderr.writeln('Ошибка конфигурации: ${e.message}');
    exit(64);
  }
  Logger('Server').info('Сервер слушает $ip:$port');
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) =>
    serve(handler, ip, port);
