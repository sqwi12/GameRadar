import 'dart:convert';

import 'package:gameradar_shared/steam.dart';
import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import 'support/fake_clock.dart';

void main() {
  group('разбор ответов IsThereAnyDeal', () {
    test('lookup: appid → ID игры, неизвестные — null', () {
      expect(
        parseShopLookup(
          {'app/730': '018d937f-07a7-72c5-a2fc-0b14f1a6c2f6', 'app/1': null},
          [730, 1, 2],
        ),
        {730: '018d937f-07a7-72c5-a2fc-0b14f1a6c2f6', 1: null, 2: null},
      );
      expect(
        () => parseShopLookup([], [730]),
        throwsA(isA<SteamFormatException>()),
      );
    });

    test('storelow: берётся минимум Steam (магазин 61)', () {
      final lows = parseStoreLows([
        {
          'id': 'a',
          'lows': [
            {
              'shop': {'id': 35, 'name': 'GOG'},
              'price': {'amount': 1, 'amountInt': 100, 'currency': 'KZT'},
              'regular': {'amount': 9, 'amountInt': 900, 'currency': 'KZT'},
              'cut': 90,
              'timestamp': '2024-01-01T00:00:00+01:00',
            },
            {
              'shop': {'id': 61, 'name': 'Steam'},
              'price': {'amount': 3375, 'amountInt': 337500, 'currency': 'KZT'},
              'regular': {
                'amount': 22500,
                'amountInt': 2250000,
                'currency': 'KZT',
              },
              'cut': 85,
              'timestamp': '2025-06-26T19:00:00+02:00',
            },
          ],
        },
        // Битая запись не роняет разбор остальных.
        {'id': 'b', 'lows': 'oops'},
      ], shopId: ItadClient.steamShopId);
      expect(lows.keys, ['a']);
      expect(lows['a']!.price, 337500);
      expect(lows['a']!.regular, 2250000);
      expect(lows['a']!.cut, 85);
      expect(lows['a']!.currency, 'KZT');
      expect(lows['a']!.at, DateTime.utc(2025, 6, 26, 17));
    });
  });

  group('ItadClient', () {
    late List<http.Request> requests;
    late int status;

    ItadClient client() => ItadClient(
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          request.url.path.contains('lookup')
              ? jsonEncode({'app/730': 'uuid-730'})
              : '[]',
          status,
        );
      }),
      rateLimiter: InMemoryRateLimiter(
        interval: const Duration(milliseconds: 1500),
        clock: FakeClock(),
      ),
      apiKey: 'secret-key',
      clock: FakeClock(),
    );

    setUp(() {
      requests = [];
      status = 200;
    });

    test(
      'ключ — в заголовке, а не в адресе; Steam и страна в запросе',
      () async {
        final c = client();
        expect(await c.lookupSteamApps([730]), {730: 'uuid-730'});
        await c.steamLows(['uuid-730'], 'kz');
        expect(requests.first.url.path, '/lookup/id/shop/61/v1');
        expect(jsonDecode(requests.first.body), ['app/730']);
        expect(requests.last.url.queryParameters, {
          'country': 'KZ',
          'shops': '61',
        });
        for (final r in requests) {
          expect(r.method, 'POST');
          expect(r.headers['ITAD-API-Key'], 'secret-key');
          expect(r.url.toString(), isNot(contains('secret-key')));
        }
      },
    );

    test('429 — пауза и повтор позже, неверный ключ — без повторов', () async {
      status = 429;
      await expectLater(
        client().lookupSteamApps([730]),
        throwsA(isA<SteamThrottledException>()),
      );
      status = 403;
      await expectLater(
        client().lookupSteamApps([730]),
        throwsA(isA<SteamPermanentException>()),
      );
    });
  });
}
