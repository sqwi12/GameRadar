import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.utc(2026, 10, 11);

  GamePrice price({
    int finalPrice = 400000,
    int discount = 20,
    bool available = true,
  }) => GamePrice(
    region: 'kz',
    isAvailable: available,
    currency: available ? 'KZT' : null,
    initialPrice: available ? 500000 : null,
    finalPrice: available ? finalPrice : null,
    discountPct: discount,
    checkedAt: now,
    changedAt: now,
  );

  group('thresholdsMet', () {
    test('цена не выше целевой', () {
      expect(
        thresholdsMet(
          price: price(),
          targetPrice: 400000,
          minDiscountPct: null,
        ),
        isTrue,
      );
      expect(
        thresholdsMet(
          price: price(),
          targetPrice: 399999,
          minDiscountPct: null,
        ),
        isFalse,
      );
    });

    test('скидка не меньше порога', () {
      expect(
        thresholdsMet(price: price(), targetPrice: null, minDiscountPct: 20),
        isTrue,
      );
      expect(
        thresholdsMet(price: price(), targetPrice: null, minDiscountPct: 21),
        isFalse,
      );
    });

    test('достаточно одного условия из двух', () {
      expect(
        thresholdsMet(price: price(), targetPrice: 1, minDiscountPct: 10),
        isTrue,
      );
      expect(
        thresholdsMet(price: price(), targetPrice: 450000, minDiscountPct: 90),
        isTrue,
      );
    });

    test('без порогов, без цены или цена недоступна — нет', () {
      expect(
        thresholdsMet(price: price(), targetPrice: null, minDiscountPct: null),
        isFalse,
      );
      expect(
        thresholdsMet(price: null, targetPrice: 1, minDiscountPct: 1),
        isFalse,
      );
      expect(
        thresholdsMet(
          price: price(available: false),
          targetPrice: 1 << 40,
          minDiscountPct: 1,
        ),
        isFalse,
      );
    });
  });

  group('validate()', () {
    test('WatchlistUpsertRequest', () {
      expect(const WatchlistUpsertRequest(targetPrice: 0).validate(), isEmpty);
      expect(const WatchlistUpsertRequest().validate(), isEmpty);
      final errors = const WatchlistUpsertRequest(
        targetPrice: -1,
        minDiscountPct: 101,
      ).validate();
      expect(errors.map((e) => e.field), ['target_price', 'min_discount_pct']);
    });

    test('AnonymousAuthRequest', () {
      expect(
        const AnonymousAuthRequest(
          deviceId: '0b8a1c9e-5f2d-4a7b-9c3e-1d2f3a4b5c6d',
        ).validate(),
        isEmpty,
      );
      expect(
        const AnonymousAuthRequest(deviceId: 'short').validate(),
        hasLength(1),
      );
      final nested = const AnonymousAuthRequest(
        deviceId: '0b8a1c9e-5f2d-4a7b-9c3e-1d2f3a4b5c6d',
        initialSettings: UserSettings(region: 'KAZ'),
      ).validate();
      expect(nested.single.field, 'initial_settings.region');
    });

    test('UserSettings: часовой пояс', () {
      expect(
        const UserSettings(timezone: 'America/Argentina/Buenos_Aires')
            .validate(),
        isEmpty,
      );
      expect(const UserSettings(timezone: 'Etc/GMT+5').validate(), isEmpty);
      expect(
        const UserSettings(timezone: '../etc/passwd').validate(),
        hasLength(1),
      );
    });

    test('DeviceRegisterRequest', () {
      expect(
        const DeviceRegisterRequest(
          fcmToken: 'abc',
          platform: DevicePlatform.android,
        ).validate(),
        isEmpty,
      );
      expect(
        const DeviceRegisterRequest(
          fcmToken: '  ',
          platform: DevicePlatform.ios,
        ).validate(),
        hasLength(1),
      );
    });
  });
}
