// Проверка Steam-клиента и парсеров на настоящем Steam, без БД и Redis.
// Запуск из папки worker:
//   dart run tool/steam_smoke.dart
//   STEAM_API_KEY=... dart run tool/steam_smoke.dart   # плюс запросы, которым нужен ключ
// Соблюдает тот же лимит 1 запрос в 1,5 с на хост, что и worker.
import 'dart:io';

import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final key = Platform.environment['STEAM_API_KEY'] ?? '';
  final httpClient = http.Client();
  const clock = SystemClock();
  final steam = SteamClient(
    httpClient: httpClient,
    rateLimiter: InMemoryRateLimiter(
      interval: const Duration(milliseconds: 1500),
      clock: clock,
    ),
    apiKey: key,
    clock: clock,
  );

  Future<void> check(String title, Future<Object?> Function() body) async {
    try {
      stdout.writeln('✅ $title\n   ${await body()}');
    } catch (e) {
      stdout.writeln('❌ $title\n   $e');
    }
  }

  await check('Цены пакетом (kz): CS2, Cyberpunk 2077, Witcher 3', () async {
    final prices = await steam.fetchPrices([730, 1091500, 292030], 'kz');
    return prices.values
        .map(
          (p) => p.hasPrice
              ? '${p.appId}: ${p.finalPrice! / 100} ${p.currency} (-${p.discountPct}%)'
              : '${p.appId}: без цены',
        )
        .join('; ');
  });
  await check('Описание Cyberpunk 2077', () async {
    final d = await steam.fetchAppDetails(1091500, region: 'kz');
    return '${d?.name}, ${d?.type}, релиз ${d?.releaseDate}, жанры ${d?.genres}';
  });
  await check('Описание на русском', () async {
    final text = await steam.fetchShortDescription(
      1091500,
      steamLanguage: 'russian',
      region: 'kz',
    );
    return text == null
        ? null
        : '${text.substring(0, text.length.clamp(0, 80))}…';
  });
  await check('Отзывы CS2', () async {
    final r = await steam.fetchReviews(730);
    return '${r.totalPositive} положительных из ${r.totalReviews}';
  });
  await check('Онлайн CS2 сейчас', () => steam.fetchCurrentPlayers(730));
  await check('Топ-100 Steam по онлайну', () async {
    final chart = await steam.fetchConcurrentChart();
    return '${chart.length} игр, первые: '
        '${chart.take(3).map((e) => '#${e.rank} app ${e.appId} — ${e.concurrentInGame}').join(', ')}';
  });
  if (key.isEmpty) {
    stdout.writeln(
      '⏭  Список всех игр (GetAppList) пропущен: нужен STEAM_API_KEY',
    );
  } else {
    await check('Список всех игр, первая страница', () async {
      final page = await steam.fetchAppList(maxResults: 1000);
      return '${page.apps.length} игр, есть ещё: ${page.haveMoreResults}';
    });
  }
  httpClient.close();
}
