import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:test/test.dart';
import 'package:timezone/data/latest.dart' as tzdata;

void main() {
  setUpAll(tzdata.initializeTimeZones);

  // 12:00 UTC = 17:00 в Алматы (UTC+5).
  final noonUtc = DateTime.utc(2026, 10, 11, 12);

  GamePrice price(int finalPrice, {int discount = 0}) => GamePrice(
    region: 'kz',
    isAvailable: true,
    currency: 'KZT',
    initialPrice: 500000,
    finalPrice: finalPrice,
    discountPct: discount,
    checkedAt: noonUtc,
    changedAt: noonUtc,
  );

  WatchState watch({
    int? target = 300000,
    int? minDiscount,
    int? last,
    bool enabled = true,
    QuietHours? quiet,
    String timezone = 'Asia/Almaty',
  }) => (
    targetPrice: target,
    minDiscountPct: minDiscount,
    lastNotifiedPrice: last,
    notificationsEnabled: enabled,
    quietHours: quiet,
    timezone: timezone,
  );

  NotificationDecision decide(WatchState w, GamePrice? p, [DateTime? now]) =>
      decideNotification(watch: w, price: p, nowUtc: now ?? noonUtc);

  const night = QuietHours(start: ClockTime(23, 0), end: ClockTime(8, 0));

  group('пороги', () {
    test('цена опустилась до целевой — уведомить', () {
      expect(decide(watch(), price(300000)), const NotifyNow(300000));
    });

    test('скидка достигла порога — уведомить', () {
      expect(
        decide(
          watch(target: null, minDiscount: 50),
          price(250000, discount: 50),
        ),
        const NotifyNow(250000),
      );
    });

    test('условие не выполнено и уведомлений не было — ничего', () {
      expect(
        decide(watch(), price(400000)),
        const SkipNotification(SkipReason.thresholdsNotMet),
      );
    });

    test('порогов нет — уведомлений нет', () {
      expect(
        decide(watch(target: null), price(1)),
        const SkipNotification(SkipReason.thresholdsNotMet),
      );
    });

    test('цены нет или игра недоступна — ничего', () {
      expect(
        decide(watch(), null),
        const SkipNotification(SkipReason.thresholdsNotMet),
      );
      final unavailable = GamePrice(
        region: 'kz',
        isAvailable: false,
        checkedAt: noonUtc,
        changedAt: noonUtc,
      );
      expect(
        decide(watch(), unavailable),
        const SkipNotification(SkipReason.thresholdsNotMet),
      );
    });
  });

  group('без повторов (last_notified_price)', () {
    test('о той же цене повторно не уведомляем', () {
      expect(
        decide(watch(last: 300000), price(300000)),
        const SkipNotification(SkipReason.alreadyNotified),
      );
    });

    test('цена выросла, но условие ещё выполнено — без уведомления', () {
      expect(
        decide(watch(last: 250000), price(280000)),
        const SkipNotification(SkipReason.alreadyNotified),
      );
    });

    test('цена опустилась ещё ниже — новое уведомление', () {
      expect(
        decide(watch(last: 300000), price(200000)),
        const NotifyNow(200000),
      );
    });

    test('условие перестало выполняться — сбросить отметку', () {
      expect(decide(watch(last: 300000), price(500000)), const ResetNotified());
    });

    test('после сброса та же цена снова даёт уведомление', () {
      expect(decide(watch(last: null), price(300000)), const NotifyNow(300000));
    });
  });

  test('уведомления выключены — пропуск без отметки', () {
    expect(
      decide(watch(enabled: false), price(100)),
      const SkipNotification(SkipReason.disabled),
    );
  });

  group('тихие часы', () {
    test('днём уведомляем сразу', () {
      expect(decide(watch(quiet: night), price(100)), const NotifyNow(100));
    });

    test('ночью по местному времени — отложить до конца тихих часов', () {
      // 20:00 UTC = 01:00 в Алматы → до 08:00 Алматы = 03:00 UTC следующего дня.
      final night20Utc = DateTime.utc(2026, 10, 11, 20);
      expect(
        decide(watch(quiet: night), price(100), night20Utc),
        DeferUntil(DateTime.utc(2026, 10, 12, 3)),
      );
    });

    test('вечер до полуночи — конец тихих часов на следующий день', () {
      // 18:30 UTC = 23:30 в Алматы.
      expect(
        decide(
          watch(quiet: night),
          price(100),
          DateTime.utc(2026, 10, 11, 18, 30),
        ),
        DeferUntil(DateTime.utc(2026, 10, 12, 3)),
      );
    });

    test('учитывается часовой пояс пользователя', () {
      // 12:00 UTC = 08:00 в Нью-Йорке (EDT, UTC-4): тихие часы 23–09 ещё идут.
      const quiet = QuietHours(start: ClockTime(23, 0), end: ClockTime(9, 0));
      expect(
        decide(watch(quiet: quiet, timezone: 'America/New_York'), price(100)),
        DeferUntil(DateTime.utc(2026, 10, 11, 13)),
      );
    });

    test('переход на зимнее время учитывается при расчёте конца', () {
      // 1 ноября 2026 в Нью-Йорке: в 02:00 EDT часы переводятся на 01:00 EST.
      // 05:30 UTC = 01:30 EDT, тихие часы до 08:00 → 08:00 EST = 13:00 UTC.
      expect(
        decide(
          watch(quiet: night, timezone: 'America/New_York'),
          price(100),
          DateTime.utc(2026, 11, 1, 5, 30),
        ),
        DeferUntil(DateTime.utc(2026, 11, 1, 13)),
      );
    });

    test('неизвестный часовой пояс — пояс по умолчанию (Алматы)', () {
      expect(
        decide(
          watch(quiet: night, timezone: 'Mars/Olympus'),
          price(100),
          DateTime.utc(2026, 10, 11, 20),
        ),
        DeferUntil(DateTime.utc(2026, 10, 12, 3)),
      );
    });

    test('дубль цены в тихие часы не откладывается, а пропускается', () {
      expect(
        decide(
          watch(quiet: night, last: 100),
          price(100),
          DateTime.utc(2026, 10, 11, 20),
        ),
        const SkipNotification(SkipReason.alreadyNotified),
      );
    });
  });
}
