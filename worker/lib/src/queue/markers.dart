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
