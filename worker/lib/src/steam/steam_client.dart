import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gameradar_shared/steam.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../clock.dart';
import '../rate_limit/backoff.dart';
import '../rate_limit/rate_limiter.dart';

/// Steam ответил 429/403: хост поставлен на паузу [pause], задачу нужно
/// вернуть в очередь не раньше, чем через [pause].
final class SteamThrottledException implements Exception {
  SteamThrottledException(this.host, this.statusCode, this.pause);

  final String host;
  final int statusCode;
  final Duration pause;

  @override
  String toString() =>
      'SteamThrottledException($host: HTTP $statusCode, пауза ${pause.inMinutes} мин)';
}

/// Временная ошибка (сеть, таймаут, 5xx): задачу стоит повторить позже.
final class SteamTransientException implements Exception {
  SteamTransientException(this.message);

  final String message;

  @override
  String toString() => 'SteamTransientException: $message';
}

/// Ошибка, которую повтор не исправит (например, 400 или 401 из-за ключа).
final class SteamPermanentException implements Exception {
  SteamPermanentException(this.message);

  final String message;

  @override
  String toString() => 'SteamPermanentException: $message';
}

/// Единственная точка, через которую worker ходит в Steam (правило 2).
/// Каждый запрос сначала резервирует слот в [RateLimiter] своего хоста.
final class SteamClient {
  SteamClient({
    required http.Client httpClient,
    required RateLimiter rateLimiter,
    required this._apiKey,
    this._clock = const SystemClock(),
    this._backoff = const ThrottleBackoff(),
    this._timeout = const Duration(seconds: 30),
  }) : _http = httpClient,
       _limiter = rateLimiter;

  static const storeHost = 'store.steampowered.com';
  static const apiHost = 'api.steampowered.com';

  /// Максимум appid в одном запросе цен (правило 4).
  static const maxPriceBatch = 50;

  static final _log = Logger('SteamClient');

  final http.Client _http;
  final RateLimiter _limiter;
  final String _apiKey;
  final Clock _clock;
  final ThrottleBackoff _backoff;
  final Duration _timeout;

  /// Цены пакета игр в регионе [region] (`cc`).
  Future<Map<int, SteamPriceOverview>> fetchPrices(
    List<int> appIds,
    String region,
  ) async {
    if (appIds.isEmpty) return const {};
    if (appIds.length > maxPriceBatch) {
      throw ArgumentError(
        'Не больше $maxPriceBatch appid за запрос, передано ${appIds.length}',
      );
    }
    final json = await _getJson(
      Uri.https(storeHost, '/api/appdetails', {
        'appids': appIds.join(','),
        'filters': 'price_overview',
        'cc': region,
      }),
    );
    return parsePriceOverviewBatch(json);
  }

  /// Полные данные игры на английском (для структурных полей и даты релиза).
  Future<SteamAppDetails?> fetchAppDetails(
    int appId, {
    required String region,
  }) async {
    final json = await _getJson(
      Uri.https(storeHost, '/api/appdetails', {
        'appids': '$appId',
        'cc': region,
        'l': 'english',
      }),
    );
    return parseAppDetails(json, appId);
  }

  /// Краткое описание на языке Steam (`russian`, `english`, ...).
  Future<String?> fetchShortDescription(
    int appId, {
    required String steamLanguage,
    required String region,
  }) async {
    final json = await _getJson(
      Uri.https(storeHost, '/api/appdetails', {
        'appids': '$appId',
        'cc': region,
        'l': steamLanguage,
      }),
    );
    return parseShortDescription(json, appId);
  }

  Future<SteamReviewSummary> fetchReviews(int appId) async {
    final json = await _getJson(
      Uri.https(storeHost, '/appreviews/$appId', {
        'json': '1',
        'language': 'all',
        'purchase_type': 'all',
        'num_per_page': '0',
      }),
    );
    return parseReviewSummary(json);
  }

  /// Текущий онлайн или null, если у игры нет статистики.
  Future<int?> fetchCurrentPlayers(int appId) async {
    final json = await _getJson(
      Uri.https(apiHost, '/ISteamUserStats/GetNumberOfCurrentPlayers/v1/', {
        'appid': '$appId',
      }),
      // На игры без статистики Steam отвечает 404 с телом {"response":{"result":42}}.
      jsonOn404: true,
    );
    return parseCurrentPlayers(json);
  }

  Future<SteamAppListPage> fetchAppList({
    int? lastAppId,
    int maxResults = 50000,
  }) async {
    final json = await _getJson(
      Uri.https(apiHost, '/IStoreService/GetAppList/v1/', {
        'key': _apiKey,
        'include_games': 'true',
        'include_dlc': 'false',
        'include_software': 'false',
        'include_videos': 'false',
        'include_hardware': 'false',
        'max_results': '$maxResults',
        'last_appid': ?lastAppId?.toString(),
      }),
    );
    return parseAppListPage(json);
  }

  /// SteamID64 по нику (steamcommunity.com/id/<ник>) или null, если ника нет.
  Future<String?> resolveVanity(String name) async => parseResolveVanity(
    await _getJson(
      Uri.https(apiHost, '/ISteamUser/ResolveVanityURL/v1/', {
        'key': _apiKey,
        'vanityurl': name,
      }),
    ),
  );

  /// Имя и открытость профиля или null, если профиля нет.
  Future<SteamPlayerSummary?> playerSummary(String steamId) async =>
      parsePlayerSummary(
        await _getJson(
          Uri.https(apiHost, '/ISteamUser/GetPlayerSummaries/v2/', {
            'key': _apiKey,
            'steamids': steamId,
          }),
        ),
      );

  /// appid из списка желаемого в порядке приоритета пользователя.
  /// Скрытый список приходит пустым.
  Future<List<int>> wishlist(String steamId) async => parseWishlist(
    await _getJson(
      Uri.https(apiHost, '/IWishlistService/GetWishlist/v1/', {
        'steamid': steamId,
      }),
    ),
  );

  /// Число игр в списке желаемого; null — список скрыт.
  Future<int?> wishlistCount(String steamId) async => parseWishlistCount(
    await _getJson(
      Uri.https(apiHost, '/IWishlistService/GetWishlistItemCount/v1/', {
        'steamid': steamId,
      }),
    ),
  );

  /// Топ-100 по текущему онлайну от самого Steam.
  Future<List<SteamChartEntry>> fetchConcurrentChart() async {
    final json = await _getJson(
      Uri.https(
        apiHost,
        '/ISteamChartsService/GetGamesByConcurrentPlayers/v1/',
        {'key': _apiKey},
      ),
    );
    return parseConcurrentPlayersChart(json);
  }

  /// Хосты CDN Steam, с которых разрешено скачивать обложки. Адрес обложки
  /// приходит в данных Steam, но проверяем его, чтобы worker не пошёл
  /// по произвольной ссылке.
  static final imageHostPattern = RegExp(
    r'^([a-z0-9-]+\.)*(steamstatic\.com|akamaihd\.net|steampowered\.com)$',
  );

  /// Максимальный размер обложки (header 460×215 весит десятки КБ).
  static const maxImageBytes = 1024 * 1024;

  static const _imageTypes = {'image/jpeg', 'image/png', 'image/webp'};

  /// Обложка игры с CDN Steam — через тот же лимит запросов на хост.
  Future<({List<int> bytes, String contentType})> fetchImage(Uri uri) async {
    if (uri.scheme != 'https' || !imageHostPattern.hasMatch(uri.host)) {
      throw SteamPermanentException('недопустимый адрес обложки: ${uri.host}');
    }
    final response = await _send(uri, accept: 'image/*');
    final type = (response.headers['content-type'] ?? '')
        .split(';')
        .first
        .trim()
        .toLowerCase();
    if (!_imageTypes.contains(type)) {
      throw SteamPermanentException('обложка не картинка ($type): $uri');
    }
    final bytes = response.bodyBytes;
    if (bytes.isEmpty || bytes.length > maxImageBytes) {
      throw SteamPermanentException('обложка ${bytes.length} байт: $uri');
    }
    return (bytes: bytes, contentType: type);
  }

  Future<Object?> _getJson(Uri uri, {bool jsonOn404 = false}) async {
    final response = await _send(
      uri,
      accept: 'application/json',
      allow404: jsonOn404,
    );
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw SteamFormatException('не JSON от ${_redact(uri)}');
    }
  }

  /// Запрос к Steam: слот ограничителя хоста, пауза на 429/403,
  /// классификация ошибок. Все запросы worker'а проходят здесь.
  Future<http.Response> _send(
    Uri uri, {
    required String accept,
    bool allow404 = false,
  }) async {
    final host = uri.host;
    final safeUri = _redact(uri);

    final wait = await _limiter.reserve(host);
    if (wait > Duration.zero) await _clock.sleep(wait);

    final http.Response response;
    try {
      response = await _http
          .get(uri, headers: {'Accept': accept, 'User-Agent': 'GameRadar/0.1'})
          .timeout(_timeout);
    } on TimeoutException {
      throw SteamTransientException('таймаут $safeUri');
    } on SocketException catch (e) {
      throw SteamTransientException('сеть: ${e.message} ($safeUri)');
    } on http.ClientException catch (e) {
      throw SteamTransientException('HTTP-клиент: ${e.message} ($safeUri)');
    }

    final status = response.statusCode;
    if (status == 429 || status == 403) {
      final consecutive = await _limiter.registerThrottle(host);
      final pause = _backoff.pauseFor(consecutive);
      await _limiter.pause(host, pause);
      _log.warning(
        'HTTP $status от $host: пауза ${pause.inMinutes} мин ($consecutive подряд)',
      );
      throw SteamThrottledException(host, status, pause);
    }

    await _limiter.registerSuccess(host);

    if (status >= 500) throw SteamTransientException('HTTP $status: $safeUri');
    if (status == 404 && !allow404) {
      throw SteamPermanentException('HTTP 404: $safeUri');
    }
    if (status >= 400 && status != 404) {
      throw SteamPermanentException('HTTP $status: $safeUri');
    }
    return response;
  }

  /// URL для логов: ключ API в логи не попадает (правило 9).
  static String _redact(Uri uri) => uri.toString().replaceAllMapped(
    RegExp(r'([?&]key=)[^&]*'),
    (m) => '${m.group(1)}***',
  );
}
