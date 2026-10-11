import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/features/game/presentation/price_chart.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

void main() {
  PriceHistoryEntry entry(
    int day, {
    int? price,
    int initial = 1000000,
    int discount = 0,
  }) => PriceHistoryEntry(
    recordedAt: DateTime.utc(2026, 10, day),
    isAvailable: price != null,
    currency: price == null ? null : 'KZT',
    initialPrice: price == null ? null : initial,
    finalPrice: price,
    discountPct: discount,
  );

  final now = DateTime.utc(2026, 10, 20);

  test('лучшая цена — самая низкая, при равной — первая', () {
    final summary = PriceHistorySummary.from([
      entry(1, price: 1000000),
      entry(3, price: 500000, discount: 50),
      entry(5, price: 1000000),
      entry(7, price: 500000, discount: 50),
    ], now: now);
    expect(summary.best?.price, 500000);
    expect(summary.best?.discountPct, 50);
    expect(summary.best?.at, DateTime.utc(2026, 10, 3));
    expect(summary.regular, 1000000);
    expect(summary.since, DateTime.utc(2026, 10, 1));
  });

  test('последняя цена продлевается до «сейчас», «нет в продаже» — разрыв', () {
    final summary = PriceHistorySummary.from([
      entry(1, price: 1000000),
      entry(2),
      entry(4, price: 750000, discount: 25),
    ], now: now);
    expect(summary.points.length, 4);
    expect(summary.points[1], isNull);
    expect(summary.points.last?.at, now);
    expect(summary.points.last?.price, 750000);
    expect(summary.canDraw, isTrue);
  });

  test(
    'одна запись — две точки (до «сейчас»), пустая история — без графика',
    () {
      expect(
        PriceHistorySummary.from([entry(1, price: 1000)], now: now).canDraw,
        isTrue,
      );
      final empty = PriceHistorySummary.from(const [], now: now);
      expect(empty.canDraw, isFalse);
      expect(empty.best, isNull);
      expect(empty.since, isNull);
    },
  );

  test(
    'игра не в продаже с последней записи — точка «сейчас» не добавляется',
    () {
      final summary = PriceHistorySummary.from([
        entry(1, price: 1000),
        entry(2),
      ], now: now);
      expect(summary.points.last, isNull);
      expect(summary.canDraw, isFalse);
    },
  );
}
