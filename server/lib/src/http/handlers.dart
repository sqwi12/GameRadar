import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../auth/jwt.dart';
import '../services.dart';
import 'api_exception.dart';

// Логика эндпоинтов. Файлы в routes/ только выбирают обработчик по методу,
// поэтому всё здесь тестируется без Dart Frog: на вход Request и Services.

/// Проверяет `Authorization: Bearer <jwt>` и возвращает пользователя.
AuthUser authenticate(Request request, Services services) {
  final header = request.headers[HttpHeaders.authorizationHeader];
  if (header == null || !header.startsWith('Bearer ')) {
    throw ApiException.unauthorized('Нет токена');
  }
  final userId = services.jwt.verify(header.substring(7).trim());
  if (userId == null) {
    throw ApiException.unauthorized('Токен недействителен или истёк');
  }
  return AuthUser(userId);
}

String _region(Request request, Services services) {
  final region =
      request.uri.queryParameters['region'] ?? services.config.defaultRegion;
  if (!Regions.isValid(region)) {
    throw ApiException.badRequest('region', FieldErrorCode.invalidFormat);
  }
  return region;
}

// ------------------------------------------------------------------ auth

/// POST /auth/anonymous
Future<Response> anonymousSignIn(Request request, Services services) async {
  final body = await readJsonBody(request, AnonymousAuthRequest.fromJson);
  ensureValid(body.validate());

  // Часовой пояс с устройства мог прийти неизвестный PostgreSQL — тогда
  // берём пояс по умолчанию, а не отказываем во входе.
  var initial =
      body.initialSettings ??
      UserSettings(region: services.config.defaultRegion);
  if (!await services.users.timezoneExists(initial.timezone)) {
    initial = initial.copyWith(timezone: UserSettings.defaultTimezone);
  }

  final user = await services.users.signIn(
    hashDeviceId(body.deviceId),
    initial,
  );
  final token = services.jwt.issue(user.id);
  return jsonResponse(
    AuthResponse(
      accessToken: token.token,
      expiresAt: token.expiresAt,
      user: user,
    ).toJson(),
  );
}

// -------------------------------------------------------------------- me

/// GET /me
Future<Response> getMe(
  Request request,
  Services services,
  AuthUser user,
) async {
  final profile = await services.users.find(user.id);
  if (profile == null) {
    throw ApiException.unauthorized('Пользователь не найден');
  }
  return jsonResponse(profile.toJson());
}

/// PUT /me/settings — настройки заменяются целиком.
Future<Response> putSettings(
  Request request,
  Services services,
  AuthUser user,
) async {
  final settings = await readJsonBody(request, UserSettings.fromJson);
  ensureValid(settings.validate());
  if (!await services.users.timezoneExists(settings.timezone)) {
    throw ApiException.badRequest('timezone', FieldErrorCode.invalidFormat);
  }
  final profile = await services.users.updateSettings(user.id, settings);
  if (profile == null) {
    throw ApiException.unauthorized('Пользователь не найден');
  }
  return jsonResponse(profile.toJson());
}

// ----------------------------------------------------------------- games

/// GET /games/search?q=...&region=kz&limit=20
Future<Response> searchGames(Request request, Services services) async {
  final query = SearchQuery.fromQueryParameters(request.uri.queryParameters);
  final page = await services.games.search(query);
  return jsonResponse(page.toJson((g) => g.toJson()));
}

/// GET /games/top?sort=current|peak_24h&only_discounted=true&offset&limit
Future<Response> topGames(Request request, Services services) async {
  final query = TopQuery.fromQueryParameters(request.uri.queryParameters);
  final page = await services.games.top(query);
  return jsonResponse(page.toJson((g) => g.toJson()));
}

/// GET /games/discounts?sort=discount|price|players&min_discount_pct&max_price&offset&limit
Future<Response> discountedGames(Request request, Services services) async {
  final query = DiscountsQuery.fromQueryParameters(request.uri.queryParameters);
  final page = await services.games.discounts(query);
  return jsonResponse(page.toJson((g) => g.toJson()));
}

/// GET /games/{appId}?region=kz
Future<Response> gameDetails(
  Request request,
  Services services,
  String rawId,
) async {
  final appId = parseAppId(rawId);
  final details = await services.games.details(
    appId,
    _region(request, services),
  );
  if (details == null) throw ApiException.notFound('Игра не найдена');
  await services.games.markViewed(appId);
  return jsonResponse(details.toJson());
}

/// GET /games/{appId}/players?period=24h|7d|30d
Future<Response> playerHistory(
  Request request,
  Services services,
  String rawId,
) async {
  final appId = parseAppId(rawId);
  final rawPeriod =
      request.uri.queryParameters['period'] ?? HistoryPeriod.week.wireName;
  final period = HistoryPeriod.values
      .where((p) => p.wireName == rawPeriod)
      .firstOrNull;
  if (period == null) {
    throw ApiException.badRequest('period', FieldErrorCode.invalidFormat);
  }
  if (!await services.games.exists(appId)) {
    throw ApiException.notFound('Игра не найдена');
  }
  final points = await services.games.playerHistory(appId, period);
  return jsonResponse(
    PlayerHistory(appId: appId, period: period, points: points).toJson(),
  );
}

/// GET /games/{appId}/prices?region=kz — только изменения цены.
Future<Response> priceHistory(
  Request request,
  Services services,
  String rawId,
) async {
  final appId = parseAppId(rawId);
  final region = _region(request, services);
  if (!await services.games.exists(appId)) {
    throw ApiException.notFound('Игра не найдена');
  }
  final entries = await services.games.priceHistory(appId, region);
  return jsonResponse([for (final e in entries) e.toJson()]);
}

// ------------------------------------------------------------- watchlist

/// GET /watchlist
Future<Response> listWatchlist(
  Request request,
  Services services,
  AuthUser user,
) async {
  final items = await services.watchlist.list(user.id);
  return jsonResponse([for (final i in items) i.toJson()]);
}

/// PUT /watchlist/{appId} — добавить или изменить пороги.
/// 201 — игра добавлена, 200 — пороги обновлены.
Future<Response> putWatchlistItem(
  Request request,
  Services services,
  AuthUser user,
  String rawId,
) async {
  final appId = parseAppId(rawId);
  final body = await readJsonBody(request, WatchlistUpsertRequest.fromJson);
  ensureValid(body.validate());

  if (!await services.games.exists(appId)) {
    throw ApiException.notFound('Игра не найдена');
  }
  final existing = await services.watchlist.find(user.id, appId);
  if (existing == null &&
      await services.watchlist.count(user.id) >=
          services.config.maxWatchlistSize) {
    throw ApiException(
      HttpStatus.conflict,
      ApiErrorCode.limitExceeded,
      'Не больше ${services.config.maxWatchlistSize} игр в списке',
    );
  }
  final profile = await services.users.find(user.id);
  if (profile == null) {
    throw ApiException.unauthorized('Пользователь не найден');
  }

  final created = await services.watchlist.upsert(
    userId: user.id,
    appId: appId,
    region: existing?.region ?? profile.settings.region,
    request: body,
  );
  final item = (await services.watchlist.find(user.id, appId))!;
  return jsonResponse(
    item.toJson(),
    statusCode: created ? HttpStatus.created : HttpStatus.ok,
  );
}

/// DELETE /watchlist/{appId}
Future<Response> deleteWatchlistItem(
  Request request,
  Services services,
  AuthUser user,
  String rawId,
) async {
  final appId = parseAppId(rawId);
  if (!await services.watchlist.delete(user.id, appId)) {
    throw ApiException.notFound('Игры нет в списке');
  }
  return noContent();
}

// --------------------------------------------------------------- devices

/// PUT /devices — зарегистрировать FCM-токен.
Future<Response> putDevice(
  Request request,
  Services services,
  AuthUser user,
) async {
  final body = await readJsonBody(request, DeviceRegisterRequest.fromJson);
  ensureValid(body.validate());
  await services.devices.upsert(user.id, body);
  return noContent();
}

/// DELETE /devices — удалить FCM-токен (выход, отключение уведомлений).
/// Тело: `{"fcm_token": "..."}`.
Future<Response> deleteDevice(
  Request request,
  Services services,
  AuthUser user,
) async {
  final body = await readJsonBody(request, (json) => json['fcm_token']);
  if (body is! String || body.isEmpty) {
    throw ApiException.badRequest('fcm_token', FieldErrorCode.required);
  }
  await services.devices.delete(user.id, body);
  return noContent();
}
