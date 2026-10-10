import 'dart:convert';

import 'package:gameradar_shared/steam.dart';
import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import 'support/fake_clock.dart';

void main() {
  late FakeClock clock;
  late InMemoryRateLimiter limiter;
  late List<Uri> requests;

  SteamClient client(http.Response Function(http.Request request) respond) {
    requests = [];
    return SteamClient(
      httpClient: MockClient((request) async {
        requests.add(request.url);
        return respond(request);
      }),
      rateLimiter: limiter,
      apiKey: 'SECRET-KEY',
      clock: clock,
    );
  }

  http.Response json(Object body, [int status = 200]) => http.Response.bytes(
    utf8.encode(jsonEncode(body)),
    status,
    headers: {'content-type': 'application/json'},
  );

  setUp(() {
    clock = FakeClock();
    limiter = InMemoryRateLimiter(
      interval: const Duration(milliseconds: 1500),
      clock: clock,
    );
  });

  group('запросы', () {
    test('цены: пакет appid, фильтр и регион', () async {
      final steam = client(
        (_) => json({
          '10': {
            'success': true,
            'data': {
              'price_overview': {
                'currency': 'KZT',
                'initial': 100,
                'final': 50,
                'discount_percent': 50,
              },
            },
          },
        }),
      );
      final prices = await steam.fetchPrices([10, 20], 'kz');
      final uri = requests.single;
      expect(uri.host, 'store.steampowered.com');
      expect(uri.path, '/api/appdetails');
      expect(uri.queryParameters, {
        'appids': '10,20',
        'filters': 'price_overview',
        'cc': 'kz',
      });
      expect(prices[10]!.finalPrice, 50);
    });

    test('больше 50 appid за раз — ошибка до запроса', () {
      final steam = client((_) => json({}));
      expect(
        () => steam.fetchPrices(List.generate(51, (i) => i + 1), 'kz'),
        throwsArgumentError,
      );
      expect(requests, isEmpty);
    });

    test('каждый запрос ждёт свой слот', () async {
      final steam = client(
        (_) => json({
          'response': {'player_count': 1, 'result': 1},
        }),
      );
      for (var i = 0; i < 3; i++) {
        await steam.fetchCurrentPlayers(730);
      }
      expect(clock.sleeps, [
        const Duration(milliseconds: 1500),
        const Duration(milliseconds: 1500),
      ]);
    });

    test('онлайн: 404 с result 42 — нет данных, не ошибка', () async {
      final steam = client(
        (_) => json({
          'response': {'result': 42},
        }, 404),
      );
      expect(await steam.fetchCurrentPlayers(1), isNull);
    });
  });

  group('429/403', () {
    test('экспоненциальная пауза хоста 1 → 2 → 4 → 8 минут', () async {
      final steam = client((_) => http.Response('Too Many Requests', 429));
      final pauses = <Duration>[];
      for (var i = 0; i < 5; i++) {
        try {
          await steam.fetchPrices([1], 'kz');
          fail('ожидался SteamThrottledException');
        } on SteamThrottledException catch (e) {
          pauses.add(e.pause);
          expect(e.host, 'store.steampowered.com');
        }
      }
      expect(pauses.map((d) => d.inMinutes), [1, 2, 4, 8, 8]);
    });

    test('после 429 следующий запрос к хосту ждёт конца паузы', () async {
      var throttle = true;
      final steam = client((_) {
        if (throttle) {
          throttle = false;
          return http.Response('', 403);
        }
        return json({
          'response': {'player_count': 5, 'result': 1},
        });
      });
      await expectLater(
        steam.fetchCurrentPlayers(1),
        throwsA(isA<SteamThrottledException>()),
      );
      clock.sleeps.clear();
      expect(await steam.fetchCurrentPlayers(1), 5);
      expect(
        clock.sleeps.single,
        greaterThanOrEqualTo(const Duration(minutes: 1)),
      );
    });

    test('успешный ответ сбрасывает счётчик: пауза снова с 1 минуты', () async {
      var calls = 0;
      final steam = client((_) {
        calls++;
        return calls == 2
            ? json({
                'response': {'result': 1, 'player_count': 1},
              })
            : http.Response('', 429);
      });
      Future<Duration?> pauseOf() async {
        try {
          await steam.fetchCurrentPlayers(1);
          return null;
        } on SteamThrottledException catch (e) {
          return e.pause;
        }
      }

      expect(await pauseOf(), const Duration(minutes: 1));
      expect(await pauseOf(), isNull);
      expect(await pauseOf(), const Duration(minutes: 1));
    });

    test('пауза одного хоста не трогает другой', () async {
      final steam = client(
        (r) => r.url.host == SteamClient.storeHost
            ? http.Response('', 429)
            : json({
                'response': {'result': 1, 'player_count': 1},
              }),
      );
      await expectLater(
        steam.fetchReviews(1),
        throwsA(isA<SteamThrottledException>()),
      );
      clock.sleeps.clear();
      await steam.fetchCurrentPlayers(1);
      expect(clock.sleeps, isEmpty);
    });
  });

  group('прочие ошибки', () {
    test('5xx — временная ошибка', () {
      final steam = client((_) => http.Response('', 502));
      expect(steam.fetchReviews(1), throwsA(isA<SteamTransientException>()));
    });

    test('сетевая ошибка — временная', () {
      final steam = client(
        (_) => throw http.ClientException('connection reset'),
      );
      expect(steam.fetchReviews(1), throwsA(isA<SteamTransientException>()));
    });

    test('400/401 — постоянная ошибка', () {
      final steam = client((_) => http.Response('', 401));
      expect(steam.fetchAppList(), throwsA(isA<SteamPermanentException>()));
    });

    test('не JSON — ошибка формата', () {
      final steam = client((_) => http.Response('<html>', 200));
      expect(steam.fetchReviews(1), throwsA(isA<SteamFormatException>()));
    });

    test('ключ API не попадает в текст ошибки', () async {
      final steam = client((_) => http.Response('', 500));
      try {
        await steam.fetchAppList();
        fail('ожидалась ошибка');
      } on SteamTransientException catch (e) {
        expect(e.toString(), isNot(contains('SECRET-KEY')));
        expect(e.toString(), contains('key=***'));
      }
      expect(requests.single.queryParameters['key'], 'SECRET-KEY');
    });
  });
}
