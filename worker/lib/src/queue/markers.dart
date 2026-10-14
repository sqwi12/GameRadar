import 'package:postgres/postgres.dart';

import '../redis/redis_client.dart';

/// Время последнего успешного запуска периодических работ
/// (синхронизация списка игр, чарт, сжатие онлайна).
abstract interface class Markers {
  Future<DateTime?> lastRun(String name);

  Future<void> setLastRun(String name, DateTime at);
}

final class InMemoryMarkers implements Markers {
  final _values = <String, DateTime>{};

  @override
  Future<DateTime?> lastRun(String name) async => _values[name];

  @override
  Future<void> setLastRun(String name, DateTime at) async => _values[name] = at;
}

/// Отметки в PostgreSQL (таблица worker_markers): для запуска без Redis,
/// например на хостинге без постоянного диска.
final class PostgresMarkers implements Markers {
  PostgresMarkers(this._db);

  final Session _db;

  @override
  Future<DateTime?> lastRun(String name) async {
    final rows = await _db.execute(
      Sql.named('SELECT last_run FROM worker_markers WHERE name = @name:text'),
      parameters: {'name': name},
    );
    return rows.isEmpty ? null : (rows.first[0]! as DateTime).toUtc();
  }

  @override
  Future<void> setLastRun(String name, DateTime at) => _db.execute(
    Sql.named('''
      INSERT INTO worker_markers (name, last_run) VALUES (@name:text, @at:timestamptz)
      ON CONFLICT (name) DO UPDATE SET last_run = EXCLUDED.last_run
    '''),
    parameters: {'name': name, 'at': at.toUtc()},
  );
}

final class RedisMarkers implements Markers {
  RedisMarkers(this._redis, {this.prefix = 'gr:marker'});

  final RedisClient _redis;
  final String prefix;

  @override
  Future<DateTime?> lastRun(String name) async {
    final value = await _redis.command(['GET', '$prefix:$name']);
    return value is String
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(value), isUtc: true)
        : null;
  }

  @override
  Future<void> setLastRun(String name, DateTime at) =>
      _redis.command(['SET', '$prefix:$name', at.millisecondsSinceEpoch]);
}
