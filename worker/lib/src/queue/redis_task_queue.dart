import '../redis/redis_client.dart';
import 'task_queue.dart';

/// Очередь в Redis. Ключи:
/// - `{p}:tasks` — HASH id → JSON задачи (заодно защита от дублей);
/// - `{p}:{lane}:ready` — ZSET готовых задач, score = приоритет;
/// - `{p}:{lane}:delayed` — ZSET отложенных задач, score = время запуска (мс);
/// - `{p}:{lane}:leased` — ZSET задач в работе, score = конец аренды (мс);
/// - `{p}:kind:{kind}` — SET id задач по видам (для подсчёта).
/// Все изменения выполняются Lua-скриптами атомарно; время — из Redis.
final class RedisTaskQueue implements TaskQueue {
  RedisTaskQueue(this._redis, {this.prefix = 'gr:q'});

  final RedisClient _redis;
  final String prefix;

  String get _tasksKey => '$prefix:tasks';
  String _ready(Lane lane) => '$prefix:${lane.name}:ready';
  String _delayed(Lane lane) => '$prefix:${lane.name}:delayed';
  String _leased(Lane lane) => '$prefix:${lane.name}:leased';
  String _kind(String kind) => '$prefix:kind:$kind';

  static const _now = '''
local t = redis.call('TIME')
local now = tonumber(t[1]) * 1000 + math.floor(tonumber(t[2]) / 1000)
''';

  // KEYS: tasks, ready, delayed, kind; ARGV: id, json, priority, delay_ms
  static const _enqueueScript =
      '''
$_now
if redis.call('HSETNX', KEYS[1], ARGV[1], ARGV[2]) == 0 then return 0 end
redis.call('SADD', KEYS[4], ARGV[1])
local delay = tonumber(ARGV[4])
if delay > 0 then
  redis.call('ZADD', KEYS[3], now + delay, ARGV[1])
else
  redis.call('ZADD', KEYS[2], tonumber(ARGV[3]), ARGV[1])
end
return 1
''';

  // KEYS: tasks, ready, delayed, leased; ARGV: lease_ms
  // Отложенные задачи с наступившим временем и задачи с истёкшей арендой
  // возвращаются в ready со своим приоритетом из JSON.
  static const _dequeueScript =
      '''
$_now
local function back_to_ready(zkey)
  local ids = redis.call('ZRANGE', zkey, '-inf', now, 'BYSCORE', 'LIMIT', 0, 100)
  for _, id in ipairs(ids) do
    redis.call('ZREM', zkey, id)
    local json = redis.call('HGET', KEYS[1], id)
    if json then
      redis.call('ZADD', KEYS[2], cjson.decode(json)['priority'], id)
    end
  end
end
back_to_ready(KEYS[3])
back_to_ready(KEYS[4])
local popped = redis.call('ZPOPMIN', KEYS[2])
if #popped == 0 then return false end
local id = popped[1]
local json = redis.call('HGET', KEYS[1], id)
if not json then return false end
redis.call('ZADD', KEYS[4], now + tonumber(ARGV[1]), id)
return json
''';

  // KEYS: tasks, ready, delayed, leased, kind; ARGV: id
  static const _completeScript = '''
redis.call('HDEL', KEYS[1], ARGV[1])
redis.call('ZREM', KEYS[2], ARGV[1])
redis.call('ZREM', KEYS[3], ARGV[1])
redis.call('ZREM', KEYS[4], ARGV[1])
redis.call('SREM', KEYS[5], ARGV[1])
return 1
''';

  // KEYS: tasks, leased, delayed; ARGV: id, json, delay_ms
  static const _retryScript =
      '''
$_now
redis.call('HSET', KEYS[1], ARGV[1], ARGV[2])
redis.call('ZREM', KEYS[2], ARGV[1])
redis.call('ZADD', KEYS[3], now + tonumber(ARGV[3]), ARGV[1])
return 1
''';

  @override
  Future<bool> enqueue(QueueTask task, {Duration delay = Duration.zero}) async {
    final added = await _redis.eval(
      _enqueueScript,
      [_tasksKey, _ready(task.lane), _delayed(task.lane), _kind(task.kind)],
      [task.id, task.toJson(), task.priority, delay.inMilliseconds],
    );
    return redisInt(added) == 1;
  }

  @override
  Future<QueueTask?> dequeue(
    Lane lane, {
    Duration lease = const Duration(minutes: 10),
  }) async {
    final json = await _redis.eval(
      _dequeueScript,
      [_tasksKey, _ready(lane), _delayed(lane), _leased(lane)],
      [lease.inMilliseconds],
    );
    return json is String ? QueueTask.fromJson(json) : null;
  }

  @override
  Future<void> complete(QueueTask task) => _redis.eval(
    _completeScript,
    [
      _tasksKey,
      _ready(task.lane),
      _delayed(task.lane),
      _leased(task.lane),
      _kind(task.kind),
    ],
    [task.id],
  );

  @override
  Future<void> retry(QueueTask task, Duration delay) => _redis.eval(
    _retryScript,
    [_tasksKey, _leased(task.lane), _delayed(task.lane)],
    [task.id, task.toJson(), delay.inMilliseconds],
  );

  @override
  Future<int> countKind(String kind) async =>
      redisInt(await _redis.command(['SCARD', _kind(kind)]));

  @override
  Future<int> backlog(Lane lane) async {
    final ready = redisInt(await _redis.command(['ZCARD', _ready(lane)]));
    final delayed = redisInt(await _redis.command(['ZCARD', _delayed(lane)]));
    return ready + delayed;
  }
}
