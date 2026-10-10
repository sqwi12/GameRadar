import 'package:gameradar_shared/steam.dart';
import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:test/test.dart';

import 'support/fake_clock.dart';

QueueTask task(
  String id, {
  int priority = 0,
  Lane lane = Lane.api,
  String kind = TaskKind.players,
}) => QueueTask(id: id, kind: kind, lane: lane, priority: priority);

void main() {
  late FakeClock clock;
  late InMemoryTaskQueue queue;

  setUp(() {
    clock = FakeClock();
    queue = InMemoryTaskQueue(clock);
  });

  group('InMemoryTaskQueue', () {
    test('выдаёт задачи по приоритету (ближайший срок первым)', () async {
      await queue.enqueue(task('b', priority: 20));
      await queue.enqueue(task('a', priority: 10));
      await queue.enqueue(task('c', priority: 30));
      final order = [
        for (var i = 0; i < 3; i++) (await queue.dequeue(Lane.api))!.id,
      ];
      expect(order, ['a', 'b', 'c']);
    });

    test('дубль по id не добавляется', () async {
      expect(await queue.enqueue(task('players:730')), isTrue);
      expect(await queue.enqueue(task('players:730', priority: -1)), isFalse);
      expect(await queue.countKind(TaskKind.players), 1);
    });

    test('полосы независимы', () async {
      await queue.enqueue(task('s', lane: Lane.store));
      expect(await queue.dequeue(Lane.api), isNull);
      expect((await queue.dequeue(Lane.store))!.id, 's');
    });

    test('отложенная задача не выдаётся раньше времени', () async {
      await queue.enqueue(task('x'), delay: const Duration(minutes: 1));
      expect(await queue.dequeue(Lane.api), isNull);
      clock.advance(const Duration(minutes: 1));
      expect((await queue.dequeue(Lane.api))!.id, 'x');
    });

    test(
      'аренда: незавершённая задача возвращается после её окончания',
      () async {
        await queue.enqueue(task('x'));
        await queue.dequeue(Lane.api, lease: const Duration(minutes: 10));
        expect(await queue.dequeue(Lane.api), isNull);
        // Пока задача в работе, повторно её не добавить.
        expect(await queue.enqueue(task('x')), isFalse);
        clock.advance(const Duration(minutes: 10));
        expect((await queue.dequeue(Lane.api))!.id, 'x');
      },
    );

    test(
      'complete удаляет задачу, после чего её можно добавить снова',
      () async {
        await queue.enqueue(task('x'));
        await queue.complete((await queue.dequeue(Lane.api))!);
        expect(await queue.countKind(TaskKind.players), 0);
        expect(await queue.enqueue(task('x')), isTrue);
      },
    );
  });

  group('LaneRunner', () {
    late List<String> handled;
    late Object? Function(QueueTask) behaviour;

    LaneRunner runner() => LaneRunner(
      lane: Lane.api,
      queue: queue,
      clock: clock,
      handler: (t) async {
        handled.add(t.id);
        final error = behaviour(t);
        if (error != null) throw error;
      },
    );

    setUp(() {
      handled = [];
      behaviour = (_) => null;
    });

    test('успех — задача удалена', () async {
      await queue.enqueue(task('ok'));
      expect(await runner().runOnce(), isTrue);
      expect(queue.tasks, isEmpty);
      expect(await runner().runOnce(), isFalse);
    });

    test(
      '429 — задача возвращается в очередь после паузы, попытка не засчитана',
      () async {
        behaviour = (_) => SteamThrottledException(
          'api.steampowered.com',
          429,
          const Duration(minutes: 4),
        );
        await queue.enqueue(task('t'));
        await runner().runOnce();
        expect(queue.tasks['t']!.attempts, 0);
        expect(
          queue.notBefore('t'),
          clock.now().add(const Duration(minutes: 4)),
        );

        clock.advance(const Duration(minutes: 3, seconds: 59));
        expect(await runner().runOnce(), isFalse);
        clock.advance(const Duration(seconds: 1));
        behaviour = (_) => null;
        expect(await runner().runOnce(), isTrue);
        expect(queue.tasks, isEmpty);
        expect(handled, ['t', 't']);
      },
    );

    test('временная ошибка — повтор с ростом задержки, затем отказ', () async {
      behaviour = (_) => SteamTransientException('timeout');
      await queue.enqueue(task('t'));
      final r = runner();
      final delays = <Duration>[];
      while (queue.tasks.isNotEmpty) {
        final before = clock.now();
        await r.runOnce();
        if (queue.tasks.isEmpty) break;
        delays.add(queue.notBefore('t')!.difference(before));
        clock.advance(delays.last);
      }
      expect(delays.map((d) => d.inSeconds), [30, 60, 120, 240, 480]);
      expect(handled, hasLength(6));
    });

    test('ошибка формата Steam — тоже повтор', () async {
      behaviour = (_) => SteamFormatException('null');
      await queue.enqueue(task('t'));
      await runner().runOnce();
      expect(queue.tasks['t']!.attempts, 1);
    });

    test('постоянная ошибка — задача отброшена сразу', () async {
      behaviour = (_) => SteamPermanentException('HTTP 400');
      await queue.enqueue(task('t'));
      await runner().runOnce();
      expect(queue.tasks, isEmpty);
    });
  });

  group('приоритет планировщика', () {
    final now = DateTime.utc(2026, 10, 11, 12);

    test('бонус за подписчиков растёт логарифмически', () {
      expect(watcherBonus(0), Duration.zero);
      expect(watcherBonus(1).inMinutes, 10);
      expect(watcherBonus(3).inMinutes, 20);
      expect(watcherBonus(1023).inMinutes, 100);
    });

    test('крайний срок = последняя проверка + максимальный интервал', () {
      final checked = now.subtract(const Duration(minutes: 10));
      expect(
        taskPriority(
          now: now,
          checkedAt: checked,
          maxAge: const Duration(minutes: 30),
          watchers: 0,
        ),
        checked.add(const Duration(minutes: 30)).millisecondsSinceEpoch,
      );
    });

    test('игра с подписчиками идёт раньше игры с тем же сроком', () {
      final checked = now.subtract(const Duration(hours: 1));
      int p(int watchers) => taskPriority(
        now: now,
        checkedAt: checked,
        maxAge: const Duration(hours: 3),
        watchers: watchers,
      );
      expect(p(100), lessThan(p(1)));
      expect(p(1), lessThan(p(0)));
    });

    test('ни разу не проверенная игра — самая срочная', () {
      final never = taskPriority(
        now: now,
        checkedAt: null,
        maxAge: const Duration(hours: 3),
        watchers: 0,
      );
      final recent = taskPriority(
        now: now,
        checkedAt: now,
        maxAge: const Duration(hours: 3),
        watchers: 0,
      );
      expect(never, lessThan(recent));
      expect(never, lessThan(now.millisecondsSinceEpoch));
    });
  });
}
