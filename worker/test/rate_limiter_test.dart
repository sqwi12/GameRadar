import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:test/test.dart';

import 'support/fake_clock.dart';

void main() {
  group('reserveSlot', () {
    test('первый запрос — сразу', () {
      final r = reserveSlot(
        nowMs: 1000,
        nextAllowedMs: 0,
        pausedUntilMs: 0,
        intervalMs: 1500,
      );
      expect(r.waitMs, 0);
      expect(r.nextAllowedMs, 2500);
    });

    test('слишком рано — ждём до следующего слота', () {
      final r = reserveSlot(
        nowMs: 2000,
        nextAllowedMs: 2500,
        pausedUntilMs: 0,
        intervalMs: 1500,
      );
      expect(r.waitMs, 500);
      expect(r.nextAllowedMs, 4000);
    });

    test('пауза хоста важнее обычного интервала', () {
      final r = reserveSlot(
        nowMs: 2000,
        nextAllowedMs: 2500,
        pausedUntilMs: 62000,
        intervalMs: 1500,
      );
      expect(r.waitMs, 60000);
      expect(r.nextAllowedMs, 63500);
    });

    test('прошлый слот давно истёк — без ожидания', () {
      final r = reserveSlot(
        nowMs: 9000,
        nextAllowedMs: 2500,
        pausedUntilMs: 5000,
        intervalMs: 1500,
      );
      expect(r.waitMs, 0);
    });
  });

  group('InMemoryRateLimiter', () {
    late FakeClock clock;
    late InMemoryRateLimiter limiter;
    const host = 'store.steampowered.com';

    setUp(() {
      clock = FakeClock();
      limiter = InMemoryRateLimiter(
        interval: const Duration(milliseconds: 1500),
        clock: clock,
      );
    });

    test('подряд идущие резервирования — шаг 1,5 с', () async {
      final waits = [for (var i = 0; i < 4; i++) await limiter.reserve(host)];
      expect(waits.map((d) => d.inMilliseconds), [0, 1500, 3000, 4500]);
    });

    test('не больше одного запроса в 1,5 с при реальном ожидании', () async {
      final starts = <DateTime>[];
      for (var i = 0; i < 10; i++) {
        await clock.sleep(await limiter.reserve(host));
        starts.add(clock.now());
        clock.advance(
          const Duration(milliseconds: 200),
        ); // «длительность запроса»
      }
      for (var i = 1; i < starts.length; i++) {
        expect(
          starts[i].difference(starts[i - 1]),
          greaterThanOrEqualTo(const Duration(milliseconds: 1500)),
        );
      }
    });

    test('хосты ограничиваются независимо', () async {
      await limiter.reserve(host);
      expect(await limiter.reserve('api.steampowered.com'), Duration.zero);
      expect(await limiter.reserve(host), const Duration(milliseconds: 1500));
    });

    test('пауза переносит и уже зарезервированные слоты', () async {
      await limiter.reserve(host);
      await limiter.pause(host, const Duration(minutes: 1));
      expect(await limiter.reserve(host), const Duration(minutes: 1));
      expect(
        await limiter.reserve(host),
        const Duration(minutes: 1, milliseconds: 1500),
      );
    });

    test('после окончания паузы запросы снова идут без ожидания', () async {
      await limiter.pause(host, const Duration(minutes: 2));
      clock.advance(const Duration(minutes: 3));
      expect(await limiter.reserve(host), Duration.zero);
    });

    test('счётчик 429 растёт и сбрасывается успехом', () async {
      expect(await limiter.registerThrottle(host), 1);
      expect(await limiter.registerThrottle(host), 2);
      await limiter.registerSuccess(host);
      expect(await limiter.registerThrottle(host), 1);
    });
  });

  group('ThrottleBackoff', () {
    const backoff = ThrottleBackoff();

    test('1, 2, 4, 8 минут, дальше 8', () {
      expect(
        [for (var i = 1; i <= 6; i++) backoff.pauseFor(i).inMinutes],
        [1, 2, 4, 8, 8, 8],
      );
    });
  });

  group('RetryPolicy', () {
    const retry = RetryPolicy();

    test('30 с, 1, 2, 4, 8 минут, затем отказ', () {
      expect(
        [for (var i = 1; i <= 5; i++) retry.delayAfter(i)!.inSeconds],
        [30, 60, 120, 240, 480],
      );
      expect(retry.delayAfter(6), isNull);
    });

    test('не больше максимума', () {
      const capped = RetryPolicy(max: Duration(minutes: 1), maxAttempts: 10);
      expect(capped.delayAfter(9), const Duration(minutes: 1));
    });
  });
}
