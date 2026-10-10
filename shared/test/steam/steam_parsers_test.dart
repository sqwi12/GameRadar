import 'dart:convert';
import 'dart:io';

import 'package:gameradar_shared/steam.dart';
import 'package:test/test.dart';

/// Образцы ответов Steam лежат в test/steam/fixtures.
Object? fixture(String name) =>
    jsonDecode(File('test/steam/fixtures/$name').readAsStringSync());

void main() {
  group('parsePriceOverviewBatch', () {
    final result = parsePriceOverviewBatch(fixture('price_batch.json'));

    test('цена со скидкой в минимальных единицах', () {
      expect(
        result[1091500],
        const SteamPriceOverview(
          appId: 1091500,
          success: true,
          currency: 'KZT',
          initialPrice: 1799000,
          finalPrice: 899500,
          discountPct: 50,
        ),
      );
      expect(result[1091500]!.hasPrice, isTrue);
    });

    test('цена без скидки', () {
      expect(result[292030]!.discountPct, 0);
      expect(result[292030]!.finalPrice, 599900);
    });

    test('data: [] — игра есть, но цены нет', () {
      expect(result[730], const SteamPriceOverview(appId: 730, success: true));
      expect(result[730]!.hasPrice, isFalse);
    });

    test('success: false — игра недоступна', () {
      expect(result[999999999]!.success, isFalse);
      expect(result[999999999]!.hasPrice, isFalse);
    });

    test('null вместо ответа (перегрузка Steam) — ошибка формата', () {
      expect(
        () => parsePriceOverviewBatch(null),
        throwsA(isA<SteamFormatException>()),
      );
    });

    test('неполный price_overview — ошибка формата', () {
      expect(
        () => parsePriceOverviewBatch({
          '1': {
            'success': true,
            'data': {
              'price_overview': {'currency': 'KZT'},
            },
          },
        }),
        throwsA(isA<SteamFormatException>()),
      );
    });

    test('скидка вне диапазона обрезается', () {
      final parsed = parsePriceOverviewBatch({
        '1': {
          'success': true,
          'data': {
            'price_overview': {
              'currency': 'kzt',
              'initial': 100,
              'final': 0,
              'discount_percent': 120,
            },
          },
        },
      });
      expect(parsed[1]!.discountPct, 100);
      expect(parsed[1]!.currency, 'KZT');
    });
  });

  group('parseAppDetails', () {
    test('полные данные', () {
      final details = parseAppDetails(fixture('appdetails_730.json'), 730)!;
      expect(details.name, 'Counter-Strike 2');
      expect(details.type, 'game');
      expect(details.isFree, isTrue);
      expect(details.developers, ['Valve']);
      expect(details.genres, ['Action', 'Free To Play']);
      expect(details.releaseDate, DateTime.utc(2012, 8, 21));
      expect(details.comingSoon, isFalse);
      expect(details.shortDescription, contains('"shaped by millions"'));
      expect(details.headerImageUrl, endsWith('header.jpg'));
    });

    test('success: false — null', () {
      expect(parseAppDetails(fixture('appdetails_fail.json'), 12345), isNull);
    });

    test('описание на русском с HTML-сущностями', () {
      expect(
        parseShortDescription(fixture('appdetails_ru_730.json'), 730),
        'Более двух десятилетий Counter-Strike предлагает «элитный» соревновательный опыт.',
      );
    });

    test('нет запрошенного appid в ответе — ошибка формата', () {
      expect(
        () => parseAppDetails(fixture('appdetails_730.json'), 570),
        throwsA(isA<SteamFormatException>()),
      );
    });
  });

  group('parseSteamReleaseDate', () {
    test('распознаёт форматы', () {
      expect(parseSteamReleaseDate('21 Aug, 2012'), DateTime.utc(2012, 8, 21));
      expect(parseSteamReleaseDate('Aug 21, 2012'), DateTime.utc(2012, 8, 21));
      expect(
        parseSteamReleaseDate('5 September 2024'),
        DateTime.utc(2024, 9, 5),
      );
      expect(parseSteamReleaseDate('Sept. 5, 2024'), DateTime.utc(2024, 9, 5));
    });

    test('неточные и неверные даты — null', () {
      for (final value in [
        'Q1 2026',
        '2026',
        'Coming soon',
        'To be announced',
        'August 2026',
        '31 Feb, 2024',
        '',
      ]) {
        expect(parseSteamReleaseDate(value), isNull, reason: value);
      }
    });
  });

  group('parseReviewSummary', () {
    test('итоги отзывов', () {
      expect(
        parseReviewSummary(fixture('appreviews.json')),
        const SteamReviewSummary(totalPositive: 7654321, totalReviews: 8888888),
      );
    });

    test('success != 1 — ошибка', () {
      expect(
        () => parseReviewSummary({'success': 2}),
        throwsA(isA<SteamFormatException>()),
      );
    });
  });

  group('parseCurrentPlayers', () {
    test('онлайн есть', () {
      expect(parseCurrentPlayers(fixture('players_ok.json')), 1234567);
    });

    test('result: 42 — данных нет, не ошибка', () {
      expect(parseCurrentPlayers(fixture('players_missing.json')), isNull);
    });

    test('неожиданная структура — ошибка', () {
      expect(
        () => parseCurrentPlayers({'foo': 1}),
        throwsA(isA<SteamFormatException>()),
      );
    });
  });

  test('parseAppListPage: пропускает пустые названия, декодирует сущности', () {
    final page = parseAppListPage(fixture('applist.json'));
    expect(page.apps.map((a) => a.appId), [10, 20, 40]);
    expect(page.apps.last.name, 'Deathmatch Classic & Co');
    expect(page.haveMoreResults, isTrue);
    expect(page.lastAppId, 40);
  });

  test('parseConcurrentPlayersChart', () {
    final chart = parseConcurrentPlayersChart(fixture('chart.json'));
    expect(chart, hasLength(3));
    expect(chart.first.appId, 730);
    expect(chart.first.concurrentInGame, 1500000);
    expect(chart.last.peakInGame, isNull);
  });

  test('decodeHtmlEntities', () {
    expect(
      decodeHtmlEntities('A &amp; B &#8212; &#x2122; &unknown;'),
      'A & B — ™ &unknown;',
    );
  });
}
