// Применение SQL-миграций без Docker. Совместимо с dbmate: использует ту же
// таблицу schema_migrations, поэтому позже контейнер migrate не применит
// уже применённые миграции повторно.
//
// Запуск из папки worker (DATABASE_URL берётся из окружения или .env):
//   dart run tool/migrate.dart          # применить новые миграции
//   dart run tool/migrate.dart status   # показать состояние
// Папка миграций — ../migrations или MIGRATIONS_DIR.
import 'dart:io';

import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:postgres/postgres.dart';

Future<void> main(List<String> args) async {
  final command = args.isEmpty ? 'up' : args.first;
  if (command != 'up' && command != 'status') {
    stderr.writeln('Использование: dart run tool/migrate.dart [up|status]');
    exit(64);
  }
  final env = loadEnvironment();
  final url = env['DATABASE_URL'];
  if (url == null || url.isEmpty) {
    stderr.writeln('Не задан DATABASE_URL (в окружении или в .env)');
    exit(64);
  }

  // В контейнере миграции лежат рядом с бинарником: MIGRATIONS_DIR.
  final dir = Directory(env['MIGRATIONS_DIR'] ?? '../migrations');
  final files =
      dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.sql'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final db = await Connection.open(
    _endpoint(url),
    settings: ConnectionSettings(sslMode: _sslMode(url)),
  );
  try {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS schema_migrations (version varchar(128) PRIMARY KEY)',
    );
    final applied = {
      for (final row in await db.execute(
        'SELECT version FROM schema_migrations',
      ))
        row[0]! as String,
    };

    var count = 0;
    for (final file in files) {
      final name = file.uri.pathSegments.last;
      final version = name.split('_').first;
      if (applied.contains(version)) {
        if (command == 'status') stdout.writeln('[x] $name');
        continue;
      }
      if (command == 'status') {
        stdout.writeln('[ ] $name');
        continue;
      }
      final up = file.readAsStringSync().split('-- migrate:down').first;
      await db.runTx((tx) async {
        await tx.execute(up, queryMode: QueryMode.simple);
        await tx.execute(
          Sql.named('INSERT INTO schema_migrations (version) VALUES (@v:text)'),
          parameters: {'v': version},
        );
      });
      stdout.writeln('Применена $name');
      count++;
    }
    if (command == 'up') {
      stdout.writeln(count == 0 ? 'Новых миграций нет' : 'Готово: $count');
    }
  } finally {
    await db.close();
  }
}

Endpoint _endpoint(String url) {
  final uri = Uri.parse(url);
  final user = uri.userInfo.split(':');
  return Endpoint(
    host: uri.host,
    port: uri.hasPort ? uri.port : 5432,
    database: uri.pathSegments.first,
    username: Uri.decodeComponent(user.first),
    password: user.length > 1
        ? Uri.decodeComponent(user.sublist(1).join(':'))
        : null,
  );
}

SslMode _sslMode(String url) =>
    Uri.parse(url).queryParameters['sslmode'] == 'disable'
    ? SslMode.disable
    : SslMode.require;
