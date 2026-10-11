import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gameradar_shared/steam.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../clock.dart';
import '../rate_limit/backoff.dart';
import '../rate_limit/rate_limiter.dart';
import '../steam/steam_client.dart';

/// Минимальная цена игры в магазине по данным IsThereAnyDeal.
/// Суммы — в минимальных единицах валюты (как у нас: 337500 = 3 375,00 ₸).
typedef ItadLow = ({
  int price,
  int regular,
  int cut,
  String currency,
  DateTime at,
});

/// Клиент IsThereAnyDeal API (https://docs.isthereanydeal.com).
///
/// Как и к Steam, ходит сюда только worker: через ограничитель запросов
/// хоста и паузы на 429. Ключ передаётся заголовком `ITAD-API-Key`,
/// поэтому в адреса (и журналы) не попадает.
final class ItadClient {
  ItadClient({
    required http.Client httpClient,
    required RateLimiter rateLimiter,
    required this._apiKey,
    this._clock = const SystemClock(),
    this._backoff = const ThrottleBackoff(),
    this._timeout = const Duration(seconds: 30),
  }) : _http = httpClient,
       _limiter = rateLimiter;

  static const host = 'api.isthereanydeal.com';

  /// ID магазина Steam в IsThereAnyDeal.
  static const steamShopId = 61;

  /// Максимум игр в одном запросе (ограничение API).
  static const maxBatch = 200;

  static final _log = Logger('Itad');

  final http.Client _http;
  final RateLimiter _limiter;
  final String _apiKey;
  final Clock _clock;
  final ThrottleBackoff _backoff;
  final Duration _timeout;

  /// Steam appid → ID игры в ITAD (null — игра ITAD неизвестна).
  /// `POST /lookup/id/shop/61/v1`, тело `["app/730", …]`.
  Future<Map<int, String?>> lookupSteamApps(List<int> appIds) async {
    final json = await _post(
      Uri.https(host, '/lookup/id/shop/$steamShopId/v1'),
      [for (final id in appIds) 'app/$id'],
    );
    return parseShopLookup(json, appIds);
  }

  /// Минимальные цены в Steam для игр ITAD в стране [country] (KZ, US…).
  /// `POST /games/storelow/v2?country=KZ&shops=61`.
  Future<Map<String, ItadLow>> steamLows(
    List<String> itadIds,
    String country,
  ) async {
    final json = await _post(
      Uri.https(host, '/games/storelow/v2', {
        'country': country.toUpperCase(),
        'shops': '$steamShopId',
      }),
      itadIds,
    );
    return parseStoreLows(json, shopId: steamShopId);
  }

  Future<Object?> _post(Uri uri, Object body) async {
    final wait = await _limiter.reserve(host);
    if (wait > Duration.zero) await _clock.sleep(wait);

    final http.Response response;
    try {
      response = await _http
          .post(
            uri,
            headers: {
              'ITAD-API-Key': _apiKey,
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'User-Agent': 'GameRadar/0.1',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw SteamTransientException('ITAD: таймаут ${uri.path}');
    } on SocketException catch (e) {
      throw SteamTransientException('ITAD: сеть: ${e.message}');
    } on http.ClientException catch (e) {
      throw SteamTransientException('ITAD: HTTP-клиент: ${e.message}');
    }

    final status = response.statusCode;
    if (status == 429) {
      final consecutive = await _limiter.registerThrottle(host);
      final pause = _backoff.pauseFor(consecutive);
      await _limiter.pause(host, pause);
      _log.warning('HTTP 429 от ITAD: пауза ${pause.inMinutes} мин');
      throw SteamThrottledException(host, status, pause);
    }
    await _limiter.registerSuccess(host);
    if (status >= 500) throw SteamTransientException('ITAD: HTTP $status');
    if (status == 401 || status == 403) {
      throw SteamPermanentException('ITAD: ключ API не принят (HTTP $status)');
    }
    if (status >= 400) {
      throw SteamPermanentException('ITAD: HTTP $status ${uri.path}');
    }
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw SteamFormatException('ITAD: не JSON от ${uri.path}');
    }
  }
}

/// Ответ `/lookup/id/shop/61/v1`: `{"app/730": "uuid" | null, …}`.
/// Игры, которых нет в ответе, считаются неизвестными (null).
Map<int, String?> parseShopLookup(Object? json, List<int> appIds) {
  if (json is! Map) throw SteamFormatException('ITAD lookup: не объект');
  return {
    for (final id in appIds)
      id: switch (json['app/$id']) {
        final String uuid when uuid.isNotEmpty => uuid,
        _ => null,
      },
  };
}

/// Ответ `/games/storelow/v2`: `[{"id": uuid, "lows": [{"shop": {"id": 61},
/// "price": {"amountInt": …, "currency": "KZT"}, "regular": {…},
/// "cut": 85, "timestamp": "…"}]}]`. Берётся минимум магазина [shopId].
Map<String, ItadLow> parseStoreLows(Object? json, {required int shopId}) {
  if (json is! List) throw SteamFormatException('ITAD storelow: не список');
  final result = <String, ItadLow>{};
  for (final game in json.whereType<Map<String, Object?>>()) {
    final id = game['id'];
    final lows = game['lows'];
    if (id is! String || lows is! List) continue;
    for (final low in lows.whereType<Map<String, Object?>>()) {
      final shop = low['shop'];
      if (shop is! Map || shop['id'] != shopId) continue;
      final price = low['price'];
      final regular = low['regular'];
      final cut = low['cut'];
      final at = DateTime.tryParse('${low['timestamp']}');
      if (price is! Map || regular is! Map || cut is! int || at == null) {
        continue;
      }
      final amount = price['amountInt'];
      final regularAmount = regular['amountInt'];
      final currency = price['currency'];
      if (amount is! int || regularAmount is! int || currency is! String) {
        continue;
      }
      result[id] = (
        price: amount,
        regular: regularAmount,
        cut: cut,
        currency: currency,
        at: at.toUtc(),
      );
    }
  }
  return result;
}
