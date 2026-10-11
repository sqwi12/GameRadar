import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/features/watchlist/presentation/home_widget_sync.dart';
import 'package:gameradar_app/l10n/gen/app_localizations.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('ru'));
  final now = DateTime.utc(2026, 10, 12);

  WatchlistItem item(
    int id, {
    int? price,
    int discount = 0,
    int? target,
    int day = 1,
  }) => WatchlistItem(
    game: GameSummary(
      appId: id,
      name: 'Игра $id',
      price: price == null
          ? null
          : GamePrice(
              region: 'kz',
              isAvailable: true,
              currency: 'KZT',
              initialPrice: 1000000,
              finalPrice: price,
              discountPct: discount,
              checkedAt: now,
              changedAt: now,
            ),
    ),
    region: 'kz',
    targetPrice: target,
    createdAt: DateTime.utc(2026, 10, day),
  );

  test('виджет: цель достигнута, затем скидка, не больше четырёх', () {
    final rows = widgetRowsOf(
      [
        item(1, price: 1000000, day: 9),
        item(2, price: 500000, discount: 50),
        item(3, price: 300000, discount: 70, target: 400000),
        item(4),
        item(5, price: 900000, discount: 10),
      ],
      l10n,
      'ru',
    );
    expect(rows.map((r) => r.name), ['Игра 3', 'Игра 2', 'Игра 5', 'Игра 1']);
    expect(rows.first.hot, isTrue);
    expect(rows.first.price, endsWith('−70%'));
    expect(rows.last.hot, isFalse);
  });
}
