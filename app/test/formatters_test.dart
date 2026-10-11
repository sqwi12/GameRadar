import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/core/format/formatters.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  group('formatPrice', () {
    test('тенге без копеек, с неразрывными пробелами', () {
      expect(formatPrice(1799900, 'KZT', 'ru'), '17 999 ₸');
      expect(formatPrice(337500, 'KZT', 'ru'), '3 375 ₸');
    });

    test('копейки показываются, только если есть', () {
      expect(formatPrice(108950, 'KZT', 'ru'), '1 089,50 ₸');
    });

    test('английская локаль и неизвестная валюта', () {
      expect(formatPrice(1999, 'USD', 'en'), '19.99 \$');
      expect(formatPrice(500, 'XYZ', 'en'), '5 XYZ');
    });
  });

  test('formatPlayers: компактно', () {
    expect(formatPlayers(825806, 'ru'), '826 тыс.');
    expect(formatPlayers(825806, 'en'), '826K');
    expect(formatPlayers(950, 'ru'), '950');
  });

  group('parsePriceInput', () {
    test('основные единицы → минимальные', () {
      expect(parsePriceInput('9000'), 900000);
      expect(parsePriceInput(' 9 000 '), 900000);
      expect(parsePriceInput('9000,5'), 900050);
      expect(parsePriceInput('9000.50'), 900050);
    });

    test('пусто и мусор — null', () {
      for (final bad in ['', '   ', 'abc', '-5', '1e12']) {
        expect(parsePriceInput(bad), isNull, reason: bad);
      }
    });
  });
}
