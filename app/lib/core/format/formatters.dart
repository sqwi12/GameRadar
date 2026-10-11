import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:intl/intl.dart';

/// Символы валют, которые встречаются в регионах Steam.
const _currencySymbols = {
  'KZT': '₸',
  'RUB': '₽',
  'USD': r'$',
  'EUR': '€',
  'UAH': '₴',
  'GBP': '£',
};

/// Цена из минимальных единиц: 1799900 KZT → «17 999 ₸».
/// Копейки показываются, только если они есть.
String formatPrice(int minorUnits, String currency, String locale) {
  final major = minorUnits / minorUnitsPerMajor;
  final hasFraction = minorUnits % minorUnitsPerMajor != 0;
  final number = NumberFormat.decimalPatternDigits(
    locale: locale,
    decimalDigits: hasFraction ? 2 : 0,
  ).format(major);
  final symbol = _currencySymbols[currency] ?? currency;
  return '$number $symbol';
}

/// Онлайн компактно: 825 806 → «826 тыс.» / «826K».
String formatPlayers(int players, String locale) =>
    NumberFormat.compact(locale: locale).format(players);

/// Число полностью: 9 914 256.
String formatCount(int value, String locale) =>
    NumberFormat.decimalPattern(locale).format(value);

/// Ввод цены пользователем в основных единицах («17999», «17 999,50») →
/// минимальные единицы. null — пусто или не число.
int? parsePriceInput(String text) {
  final cleaned = text.replaceAll(RegExp(r'[\s ]'), '').replaceAll(',', '.');
  if (cleaned.isEmpty) return null;
  final value = double.tryParse(cleaned);
  if (value == null || value < 0 || value > 1e9) return null;
  return (value * minorUnitsPerMajor).round();
}
