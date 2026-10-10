import '../redis/redis_client.dart';
import 'rate_limiter.dart';

/// Ограничитель в Redis: общий для всех копий worker, поэтому лимит
/// 1 запрос в 1,5 с на хост соблюдается, даже если worker'ов несколько.
/// Время берётся из Redis (`TIME`), чтобы у всех копий были одни часы.
final class RedisRateLimiter implements RateLimiter {
  RedisRateLimiter(
    this._redis, {
    required this.interval,
    this.prefix = 'gr:rl',
  });

  final RedisClient _redis;
  final Duration interval;
  final String prefix;

  String _next(String host) => '$prefix:$host:next';
  String _paused(String host) => '$prefix:$host:paused';
  String _throttles(String host) => '$prefix:$host:throttles';

  // Повторяет reserveSlot() из rate_limiter.dart.
  static const _reserveScript = '''
local t = redis.call('TIME')
local now = tonumber(t[1]) * 1000 + math.floor(tonumber(t[2]) / 1000)
local slot = now
local nxt = tonumber(redis.call('GET', KEYS[1]) or '0')
local paused = tonumber(redis.call('GET', KEYS[2]) or '0')
if nxt > slot then slot = nxt end
if paused > slot then slot = paused end
local next_allowed = slot + tonumber(ARGV[1])
redis.call('SET', KEYS[1], next_allowed, 'PX', next_allowed - now + 60000)
return slot - now
''';

  static const _pauseScript = '''
local t = redis.call('TIME')
local now = tonumber(t[1]) * 1000 + math.floor(tonumber(t[2]) / 1000)
local untl = now + tonumber(ARGV[1])
local ttl = tonumber(ARGV[1]) + 60000
if untl > tonumber(redis.call('GET', KEYS[2]) or '0') then
  redis.call('SET', KEYS[2], untl, 'PX', ttl)
end
if untl > tonumber(redis.call('GET', KEYS[1]) or '0') then
  redis.call('SET', KEYS[1], untl, 'PX', ttl)
end
return untl
''';

  @override
  Future<Duration> reserve(String host) async {
    final waitMs = redisInt(
      await _redis.eval(
        _reserveScript,
        [_next(host), _paused(host)],
        [interval.inMilliseconds],
      ),
    );
    return Duration(milliseconds: waitMs);
  }

  @override
  Future<void> pause(String host, Duration duration) => _redis.eval(
    _pauseScript,
    [_next(host), _paused(host)],
    [duration.inMilliseconds],
  );

  @override
  Future<int> registerThrottle(String host) async {
    final count = redisInt(await _redis.command(['INCR', _throttles(host)]));
    // Счётчик живёт час: если 429 давно не было, пауза снова начнётся с минуты.
    await _redis.command(['EXPIRE', _throttles(host), 3600]);
    return count;
  }

  @override
  Future<void> registerSuccess(String host) =>
      _redis.command(['DEL', _throttles(host)]);
}
