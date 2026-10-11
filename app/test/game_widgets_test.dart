import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/core/widgets/game_widgets.dart';
import 'package:gameradar_app/features/game/presentation/game_screen.dart';
import 'package:gameradar_app/l10n/gen/app_localizations.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

void main() {
  final now = DateTime.utc(2026, 10, 11);

  GamePrice price({
    int finalPrice = 337500,
    int initial = 2250000,
    int discount = 85,
    bool available = true,
  }) => GamePrice(
    region: 'kz',
    isAvailable: available,
    currency: available ? 'KZT' : null,
    initialPrice: available ? initial : null,
    finalPrice: available ? finalPrice : null,
    discountPct: discount,
    checkedAt: now,
    changedAt: now,
  );

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    CupertinoApp(
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: CupertinoPageScaffold(child: Center(child: child)),
    ),
  );

  testWidgets('цена со скидкой: бейдж, зачёркнутая и новая цена', (
    tester,
  ) async {
    await pump(tester, PriceTag(price: price()));
    expect(find.text('−85%'), findsOneWidget);
    expect(find.text('22 500 ₸'), findsOneWidget);
    expect(find.text('3 375 ₸'), findsOneWidget);
    final old = tester.widget<Text>(find.text('22 500 ₸'));
    expect(old.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('бесплатная игра и игра не в продаже', (tester) async {
    await pump(
      tester,
      PriceTag(price: price(available: false, discount: 0), isFree: true),
    );
    expect(find.text('Бесплатно'), findsOneWidget);
    await pump(tester, PriceTag(price: price(available: false, discount: 0)));
    expect(find.text('Нет в продаже в регионе'), findsOneWidget);
  });

  testWidgets('пороги отслеживания и «Цель достигнута»', (tester) async {
    WatchlistItem item({required int target}) => WatchlistItem(
      game: GameSummary(appId: 1, name: 'X', price: price()),
      region: 'kz',
      targetPrice: target,
      minDiscountPct: 90,
      createdAt: now,
    );

    await pump(tester, ThresholdsLabel(item: item(target: 100000)));
    expect(find.text('цена ≤ 1 000 ₸ · скидка ≥ 90%'), findsOneWidget);

    await pump(tester, ThresholdsLabel(item: item(target: 400000)));
    expect(find.textContaining('Цель достигнута'), findsOneWidget);
  });

  testWidgets('игра из списка желаемого Steam помечена', (tester) async {
    WatchlistItem item(WatchSource source) => WatchlistItem(
      game: GameSummary(appId: 1, name: 'X', price: price()),
      region: 'kz',
      minDiscountPct: 25,
      createdAt: now,
      source: source,
    );
    await pump(tester, ThresholdsLabel(item: item(WatchSource.manual)));
    expect(find.text('Из списка желаемого Steam'), findsNothing);
    await pump(tester, ThresholdsLabel(item: item(WatchSource.wishlist)));
    expect(find.text('Из списка желаемого Steam'), findsOneWidget);
  });
}
