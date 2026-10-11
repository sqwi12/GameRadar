import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/features/discounts/presentation/sale_banner.dart';
import 'package:gameradar_app/l10n/gen/app_localizations.dart';

void main() {
  Future<void> pump(WidgetTester tester, DateTime now) => tester.pumpWidget(
    CupertinoApp(
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: CupertinoPageScaffold(child: SaleBanner(now: now)),
    ),
  );

  testWidgets('до распродажи — сколько дней и даты', (tester) async {
    await pump(tester, DateTime.utc(2026, 10, 12));
    expect(
      find.textContaining('Зимняя распродажа Steam через 66 дней'),
      findsOneWidget,
    );
  });

  testWidgets('во время распродажи — до какого числа', (tester) async {
    await pump(tester, DateTime.utc(2026, 12, 20));
    expect(
      find.textContaining('Зимняя распродажа Steam идёт сейчас — до'),
      findsOneWidget,
    );
  });
}
