/// Регионы магазина и единицы цен.
abstract final class Regions {
  /// Регион по умолчанию — Казахстан, цены в тенге (KZT).
  static const defaultRegion = 'kz';

  /// Код региона: две строчные латинские буквы, как параметр `cc` у Steam.
  static final _pattern = RegExp(r'^[a-z]{2}$');

  static bool isValid(String region) => _pattern.hasMatch(region);
}

/// Steam отдаёт цены в сотых долях основной единицы для всех валют,
/// включая KZT: 249900 означает 2 499,00 ₸. Так же они хранятся в БД и в API.
const int minorUnitsPerMajor = 100;
