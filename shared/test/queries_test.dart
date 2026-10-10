import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:test/test.dart';

/// Поля, на которые пожаловалась валидация.
Matcher failsOn(List<String> fields) => throwsA(
  isA<RequestValidationException>().having(
    (e) => e.errors.map((f) => f.field).toList(),
    'fields',
    unorderedEquals(fields),
  ),
);

void main() {
  group('DiscountsQuery', () {
    test('значения по умолчанию', () {
      final q = DiscountsQuery.fromQueryParameters({});
      expect(q, const DiscountsQuery());
      expect(q.region, 'kz');
      expect(q.minDiscountPct, 1);
    });

    test('toQueryParameters → fromQueryParameters', () {
      const q = DiscountsQuery(
        sort: DiscountSort.price,
        minDiscountPct: 50,
        maxPrice: 1000000,
        offset: 40,
        limit: 20,
      );
      expect(DiscountsQuery.fromQueryParameters(q.toQueryParameters()), q);
    });

    test('ошибки формата и диапазона', () {
      expect(
        () => DiscountsQuery.fromQueryParameters({
          'sort': 'random',
          'min_discount_pct': '0',
          'max_price': 'abc',
          'limit': '1000',
          'region': 'KZ',
        }),
        failsOn(['sort', 'min_discount_pct', 'max_price', 'limit', 'region']),
      );
    });
  });

  group('TopQuery', () {
    test('toQueryParameters → fromQueryParameters', () {
      const q = TopQuery(
        sort: TopSort.peak24h,
        onlyDiscounted: true,
        offset: 20,
      );
      final params = q.toQueryParameters();
      expect(params['sort'], 'peak_24h');
      expect(TopQuery.fromQueryParameters(params), q);
    });

    test('отрицательный offset', () {
      expect(
        () => TopQuery.fromQueryParameters({'offset': '-1'}),
        failsOn(['offset']),
      );
    });
  });

  group('SearchQuery', () {
    test('обрезает пробелы', () {
      final q = SearchQuery.fromQueryParameters({'q': '  dota '});
      expect(q.text, 'dota');
    });

    test('слишком короткий и слишком длинный запрос', () {
      expect(
        () => SearchQuery.fromQueryParameters({'q': ' a '}),
        failsOn(['q']),
      );
      expect(
        () => SearchQuery.fromQueryParameters({'q': 'x' * 101}),
        failsOn(['q']),
      );
    });

    test('validate() для проверки в приложении', () {
      expect(const SearchQuery(text: 'cs').validate(), isEmpty);
      expect(const SearchQuery(text: 'cs', limit: 51).validate(), hasLength(1));
    });
  });
}
