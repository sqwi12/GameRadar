import 'package:gameradar_shared/steam.dart';
import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:test/test.dart';

void main() {
  // Фрагмент настоящего RSS Национального банка Казахстана.
  const rss = '''<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
    <channel>
        <title>Official exchange rates of National Bank of Republic Kazakhstan</title>
                <item>
                    <title>USD</title>
                    <pubDate>12.10.2026</pubDate>
                    <description>512.34</description>
                    <quant>1</quant>
                    <index>UP</index>
                    <change>+1.20</change>
                    <link></link>
                </item>
                <item>
                    <title>RUB</title>
                    <pubDate>12.10.2026</pubDate>
                    <description>612.00</description>
                    <quant>100</quant>
                    <index></index>
                    <change>0.00</change>
                    <link></link>
                </item>
                <item>
                    <title>BAD</title>
                    <pubDate>12.10.2026</pubDate>
                    <description>не число</description>
                    <quant>1</quant>
                </item>
    </channel>
</rss>''';

  test('курсы НБК: тенге за единицу, курс за 100 единиц делится', () {
    final rates = parseNbkRates(rss);
    expect(rates.map((r) => r.currency), ['USD', 'RUB']);
    expect(rates.first.kztPerUnit, 512.34);
    expect(rates.last.kztPerUnit, closeTo(6.12, 1e-9));
    expect(rates.first.date, DateTime.utc(2026, 10, 12));
  });

  test('пустой или чужой ответ — ошибка формата', () {
    expect(
      () => parseNbkRates('<html>Сервис недоступен</html>'),
      throwsA(isA<SteamFormatException>()),
    );
  });

  test('COMPARE_REGIONS: свой список, пусто — выключено, мусор — ошибка', () {
    WorkerConfig config(String? regions) => WorkerConfig.fromEnvironment({
      'DATABASE_URL': 'x',
      'REDIS_URL': 'x',
      'STEAM_API_KEY': 'x',
      'COMPARE_REGIONS': ?regions,
    });
    expect(config(null).compareRegions, WorkerConfig.defaultCompareRegions);
    expect(config('US, tr').compareRegions, ['us', 'tr']);
    expect(config('').compareRegions, isEmpty);
    expect(() => config('usa'), throwsStateError);
  });
}
