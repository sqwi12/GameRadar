import 'notifier.dart';

/// Тексты push-уведомлений на языке пользователя (ru/en).
///
/// Со скидкой: «Cyberpunk 2077 — скидка 50%» / «8 999 ₸ вместо 17 999 ₸».
/// Без скидки (цена не выше порога): «Cyberpunk 2077 — цена достигла цели» / «Сейчас 8 999 ₸».
({String title, String body}) priceAlertText(PriceAlert alert) {
  final en = alert.locale == 'en';
  final price = formatMoney(alert.finalPrice, alert.currency);
  final initial = alert.initialPrice;
  final discounted =
      alert.discountPct > 0 && initial != null && initial > alert.finalPrice;

  if (discounted) {
    final was = formatMoney(initial, alert.currency);
    return en
        ? (
            title: '${alert.gameName}: ${alert.discountPct}% off',
            body: 'Now $price, was $was',
          )
        : (
            title: '${alert.gameName} — скидка ${alert.discountPct}%',
            body: '$price вместо $was',
          );
  }
  return en
      ? (title: '${alert.gameName} hit your target price', body: 'Now $price')
      : (
          title: '${alert.gameName} — цена достигла цели',
          body: 'Сейчас $price',
        );
}

const _symbols = {
  'KZT': '₸',
  'RUB': '₽',
  'USD': r'$',
  'EUR': '€',
  'UAH': '₴',
  'GBP': '£',
};

/// 899900 KZT → «8 999 ₸» (копейки — только если есть). Разделитель тысяч —
/// неразрывный пробел, чтобы сумма не разрывалась в уведомлении.
String formatMoney(int minorUnits, String currency) {
  final whole = minorUnits ~/ 100;
  final cents = minorUnits % 100;
  final digits = whole.toString();
  final grouped = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) grouped.write(' ');
    grouped.write(digits[i]);
  }
  final fraction = cents == 0 ? '' : ',${cents.toString().padLeft(2, '0')}';
  return '$grouped$fraction ${_symbols[currency] ?? currency}';
}
