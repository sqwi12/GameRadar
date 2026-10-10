import 'dart:convert';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:test/test.dart';

/// Прогоняет объект через настоящую JSON-строку, как по сети.
Map<String, Object?> wire(Object? json) =>
    jsonDecode(jsonEncode(json)) as Map<String, Object?>;

void main() {
  final checkedAt = DateTime.utc(2026, 10, 11, 12, 30);
  final price = GamePrice(
    region: 'kz',
    isAvailable: true,
    currency: 'KZT',
    initialPrice: 500000,
    finalPrice: 250000,
    discountPct: 50,
    checkedAt: checkedAt,
    changedAt: checkedAt,
  );

  group('GameDetails', () {
    final details = GameDetails(
      appId: 730,
      name: 'Counter-Strike 2',
      type: GameType.game,
      isFree: true,
      shortDescription: const {'ru': 'Описание', 'en': 'Description'},
      developers: const ['Valve'],
      releaseDate: DateTime.utc(2023, 9, 27),
      reviews: const ReviewSummary(positive: 80, total: 100),
      players: PlayerStats(
        current: 1000,
        peak24h: 1500,
        peak7d: 2000,
        peak30d: 2500,
        checkedAt: checkedAt,
      ),
      price: price,
      topRank: 1,
    );

    test('ключи в snake_case, дата релиза без времени', () {
      final json = wire(details.toJson());
      expect(json['app_id'], 730);
      expect(json['header_image_url'], isNull);
      expect(json.containsKey('header_image_url'), isFalse);
      expect(json['release_date'], '2023-09-27');
      expect(json['short_description'], {
        'ru': 'Описание',
        'en': 'Description',
      });
      final players = json['players']! as Map<String, Object?>;
      expect(players['peak_24h'], 1500);
      expect(players['peak_7d'], 2000);
      expect(players['peak_30d'], 2500);
      final priceJson = json['price']! as Map<String, Object?>;
      expect(priceJson['final_price'], 250000);
      expect(priceJson['discount_pct'], 50);
    });

    test('туда и обратно без потерь', () {
      expect(GameDetails.fromJson(wire(details.toJson())), details);
    });

    test('минимальный JSON: значения по умолчанию', () {
      final parsed = GameDetails.fromJson({'app_id': 10, 'name': 'X'});
      expect(parsed.type, GameType.unknown);
      expect(parsed.players, const PlayerStats());
      expect(parsed.genres, isEmpty);
      expect(parsed.price, isNull);
    });

    test('неизвестный тип приложения не ломает разбор', () {
      final parsed = GameDetails.fromJson({
        'app_id': 10,
        'name': 'X',
        'type': 'hardware',
      });
      expect(parsed.type, GameType.unknown);
    });

    test('описание с откатом на английский', () {
      expect(details.descriptionFor('ru'), 'Описание');
      expect(details.descriptionFor('kk'), 'Description');
      expect(
        details.copyWith(shortDescription: {}).descriptionFor('ru'),
        isNull,
      );
    });

    test('процент положительных отзывов', () {
      expect(const ReviewSummary(positive: 2, total: 3).positivePct, 67);
      expect(const ReviewSummary(positive: 0, total: 0).positivePct, isNull);
    });
  });

  group('Paginated', () {
    final page = Paginated(
      items: [GameSummary(appId: 1, name: 'A', price: price, peak24h: 5)],
      offset: 0,
      limit: 20,
      total: 1,
    );

    test('туда и обратно с вложенными моделями', () {
      final json = wire(page.toJson((g) => g.toJson()));
      final parsed = Paginated.fromJson(
        json,
        (j) => GameSummary.fromJson(j! as Map<String, Object?>),
      );
      expect(parsed, page);
      expect(parsed.hasMore, isFalse);
    });

    test('hasMore без total — по заполненности страницы', () {
      const full = Paginated(items: [1, 2], offset: 0, limit: 2);
      const partial = Paginated(items: [1], offset: 0, limit: 2);
      expect(full.hasMore, isTrue);
      expect(partial.hasMore, isFalse);
    });
  });

  test('WatchlistItem туда и обратно', () {
    final item = WatchlistItem(
      game: GameSummary(appId: 1, name: 'A', price: price),
      region: 'kz',
      targetPrice: 300000,
      createdAt: checkedAt,
    );
    expect(WatchlistItem.fromJson(wire(item.toJson())), item);
  });

  test('UserProfile с тихими часами', () {
    final profile = UserProfile(
      id: '0b8a1c9e-0000-4000-8000-000000000000',
      settings: const UserSettings(
        locale: AppLocale.en,
        quietHours: QuietHours(start: ClockTime(23, 0), end: ClockTime(8, 0)),
      ),
      createdAt: checkedAt,
    );
    final json = wire(profile.toJson());
    final settings = json['settings']! as Map<String, Object?>;
    expect(settings['locale'], 'en');
    expect(settings['region'], 'kz');
    expect(settings['quiet_hours'], {'start': '23:00', 'end': '08:00'});
    expect(UserProfile.fromJson(json), profile);
  });

  test('ApiError с ошибками полей', () {
    const error = ApiError(
      code: ApiErrorCode.validation,
      fields: [FieldError(field: 'limit', code: FieldErrorCode.outOfRange)],
    );
    expect(ApiError.fromJson(wire(error.toJson())), error);
    expect(ApiError.fromJson({'code': 'not_found'}).fields, isEmpty);
  });

  test('PlayerHistory: период в JSON как 7d', () {
    final history = PlayerHistory(
      appId: 1,
      period: HistoryPeriod.week,
      points: [PlayerCountPoint(recordedAt: checkedAt, players: 10)],
    );
    final json = wire(history.toJson());
    expect(json['period'], '7d');
    expect(PlayerHistory.fromJson(json), history);
  });
}
