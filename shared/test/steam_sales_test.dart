import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:test/test.dart';

void main() {
  test('календарь распродаж: идёт сейчас и следующая', () {
    final duringWinter = DateTime.utc(2026, 12, 25);
    expect(SteamSales.activeAt(duringWinter)?.kind, SteamSaleKind.winter);
    expect(SteamSales.nextAfter(duringWinter)?.kind, SteamSaleKind.spring);

    final october = DateTime.utc(2026, 10, 12);
    expect(SteamSales.activeAt(october), isNull);
    expect(
      SteamSales.nextAfter(october)?.start,
      DateTime.utc(2026, 12, 17, 18),
    );

    // Конец не входит в распродажу.
    expect(SteamSales.activeAt(DateTime.utc(2027, 1, 4, 18)), isNull);
  });

  test('даты идут по порядку и не пересекаются', () {
    for (var i = 1; i < SteamSales.all.length; i++) {
      expect(
        SteamSales.all[i].start.isAfter(SteamSales.all[i - 1].end),
        isTrue,
      );
    }
  });
}
