import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gameradar_shared/steam.dart';
import 'package:http/http.dart' as http;

import '../clock.dart';
import '../rate_limit/rate_limiter.dart';
import '../steam/steam_client.dart';

/// Курс: сколько тенге стоит одна единица валюты на дату [date].
typedef FxRate = ({String currency, double kztPerUnit, DateTime date});

/// Официальные курсы Национального банка Казахстана (RSS, без ключа).
/// Запрос раз в сутки, через тот же ограничитель запросов, что и Steam.
final class FxClient {
  FxClient({
    required http.Client httpClient,
    required RateLimiter rateLimiter,
    this._clock = const SystemClock(),
    this._timeout = const Duration(seconds: 30),
  }) : _http = httpClient,
       _limiter = rateLimiter;

  static const host = 'nationalbank.kz';

  final http.Client _http;
  final RateLimiter _limiter;
  final Clock _clock;
  final Duration _timeout;

  Future<List<FxRate>> latest() async {
    final wait = await _limiter.reserve(host);
    if (wait > Duration.zero) await _clock.sleep(wait);
    final http.Response response;
    try {
      response = await _http
          .get(
            Uri.https(host, '/rss/rates_all.xml'),
            headers: {'User-Agent': 'GameRadar/0.1'},
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw SteamTransientException('НБК: таймаут');
    } on SocketException catch (e) {
      throw SteamTransientException('НБК: сеть: ${e.message}');
    } on http.ClientException catch (e) {
      throw SteamTransientException('НБК: HTTP-клиент: ${e.message}');
    }
    if (response.statusCode != 200) {
      throw SteamTransientException('НБК: HTTP ${response.statusCode}');
    }
    return parseNbkRates(utf8.decode(response.bodyBytes));
  }
}

/// Разбор RSS НБК: у каждого `item` есть `title` (код валюты), `pubDate`
/// (`12.10.2026`), `description` (курс) и `quant` (за сколько единиц).
/// Курс за `quant` единиц (например, 100 RUB) переводится в курс за одну.
List<FxRate> parseNbkRates(String xml) {
  final items = RegExp(r'<item>(.*?)</item>', dotAll: true).allMatches(xml);
  String? tag(String item, String name) => RegExp(
    '<$name>\\s*(.*?)\\s*</$name>',
    dotAll: true,
  ).firstMatch(item)?.group(1);
  final rates = <FxRate>[];
  for (final m in items) {
    final item = m.group(1)!;
    final code = tag(item, 'title');
    final rate = double.tryParse(tag(item, 'description') ?? '');
    final quant = double.tryParse(tag(item, 'quant') ?? '') ?? 1;
    final date = _parseDate(tag(item, 'pubDate'));
    if (code == null ||
        !RegExp(r'^[A-Z]{3}$').hasMatch(code) ||
        rate == null ||
        rate <= 0 ||
        quant <= 0 ||
        date == null) {
      continue;
    }
    rates.add((currency: code, kztPerUnit: rate / quant, date: date));
  }
  if (rates.isEmpty) throw SteamFormatException('НБК: нет курсов в RSS');
  return rates;
}

DateTime? _parseDate(String? ddMmYyyy) {
  final m = RegExp(r'^(\d{2})\.(\d{2})\.(\d{4})$').firstMatch(ddMmYyyy ?? '');
  if (m == null) return null;
  return DateTime.utc(
    int.parse(m.group(3)!),
    int.parse(m.group(2)!),
    int.parse(m.group(1)!),
  );
}
