@Tags(['redis'])
library;

import 'dart:io';

import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:test/test.dart';

/// Проверка Lua-скриптов очереди и ограничителя на настоящем Redis.
/// Запуск: TEST_REDIS_URL=redis://localhost:6379/15 dart test -t redis
/// Использует отдельный префикс ключей и удаляет их после себя.
final _url = Platform.environment['TEST_REDIS_URL'];

void main() {
  if (_url == null) {
    test('TEST_REDIS_URL не задан', () {}, skip: 'нет тестового Redis');
    return;
  }

  late RedisClient redis;
  final prefix = 'gr:test:${DateTime.now().microsecondsSinceEpoch}';

  setUpAll(() async => redis = await RedisClient.connect(_url!));

  tearDownAll(() async {
    final keys = await redis.command(['KEYS', '$prefix:*']);
    if (keys is List && keys.isNotEmpty) {
      await redis.command(['DEL', ...keys.cast<Object>()]);
    }
    await redis.close();
  });

  group('RedisRateLimiter', () {
    test('шаг 1,5 с между резервированиями одного хоста', () async {
      final limiter = RedisRateLimiter(
        redis,
        interval: const Duration(milliseconds: 1500),
        prefix: '$prefix:rl',
      );
      final first = await limiter.reserve('h1');
      final second = await limiter.reserve('h1');
      expect(first, Duration.zero);
      expect(second.inMilliseconds, inInclusiveRange(1400, 1500));
      expect(await limiter.reserve('h2'), Duration.zero);
    });

    test('пауза хоста и счётчик 429', () async {
      final limiter = RedisRateLimiter(
        redis,
        interval: const Duration(milliseconds: 1500),
        prefix: '$prefix:rl2',
      );
      await limiter.pause('h', const Duration(minutes: 1));
      expect((await limiter.reserve('h')).inSeconds, inInclusiveRange(59, 60));
      expect(await limiter.registerThrottle('h'), 1);
      expect(await limiter.registerThrottle('h'), 2);
      await limiter.registerSuccess('h');
      expect(await limiter.registerThrottle('h'), 1);
    });
  });

  group('RedisTaskQueue', () {
    QueueTask task(String id, int priority) => QueueTask(
      id: id,
      kind: TaskKind.players,
      lane: Lane.api,
      priority: priority,
    );

    test('приоритет, дубли, complete', () async {
      final queue = RedisTaskQueue(redis, prefix: '$prefix:q1');
      expect(await queue.enqueue(task('b', 20)), isTrue);
      expect(await queue.enqueue(task('a', 10)), isTrue);
      expect(await queue.enqueue(task('a', 5)), isFalse);
      expect(await queue.countKind(TaskKind.players), 2);
      expect(await queue.backlog(Lane.api), 2);

      final first = (await queue.dequeue(Lane.api))!;
      expect(first.id, 'a');
      expect(await queue.enqueue(task('a', 1)), isFalse, reason: 'в работе');
      await queue.complete(first);
      expect((await queue.dequeue(Lane.api))!.id, 'b');
      expect(await queue.dequeue(Lane.store), isNull);
    });

    test('retry откладывает задачу и сохраняет попытки', () async {
      final queue = RedisTaskQueue(redis, prefix: '$prefix:q2');
      await queue.enqueue(task('x', 1));
      final leased = (await queue.dequeue(Lane.api))!;
      await queue.retry(
        leased.copyWith(attempts: 3),
        const Duration(milliseconds: 300),
      );
      expect(await queue.dequeue(Lane.api), isNull);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      final again = (await queue.dequeue(Lane.api))!;
      expect(again.id, 'x');
      expect(again.attempts, 3);
    });

    test('истёкшая аренда возвращает задачу', () async {
      final queue = RedisTaskQueue(redis, prefix: '$prefix:q3');
      await queue.enqueue(task('x', 1));
      await queue.dequeue(Lane.api, lease: const Duration(milliseconds: 200));
      expect(await queue.dequeue(Lane.api), isNull);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect((await queue.dequeue(Lane.api))!.id, 'x');
    });
  });
}
