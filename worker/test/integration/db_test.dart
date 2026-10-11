@Tags(['db'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:gameradar_shared/steam.dart';
import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../support/fake_clock.dart';

/// Интеграционный тест SQL worker'а на настоящем PostgreSQL.
///
/// ВНИМАНИЕ: пересоздаёт схему public в базе из TEST_DATABASE_URL.
/// Адрес берётся из окружения или .env. Запуск: dart test -t db
final _url = loadEnvironment()['TEST_DATABASE_URL'];

/// Уведомитель, который запоминает отправленное.
final class RecordingNotifier implements Notifier {
  final sent = <PriceAlert>[];

  @override
  Future<bool> sendPriceAlert(PriceAlert alert) async {
    sent.add(alert);
    return true;
  }
}

Future<void> _resetSchema(Pool<void> db) async {
  await db.execute('DROP SCHEMA public CASCADE');
  await db.execute('CREATE SCHEMA public');
  final dir = Directory('../migrations');
  final files =
      dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.sql'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  for (final file in files) {
    final up = file.readAsStringSync().split('-- migrate:down').first;
    // Сессия с простым протоколом, чтобы выполнить несколько команд за раз.
    await db.execute(up, queryMode: QueryMode.simple);
  }
}

void main() {
  if (_url == null) {
    test('TEST_DATABASE_URL не задан', () {}, skip: 'нет тестовой БД');
    return;
  }

  late Pool<void> db;
  late GamesRepository games;
  late WatchlistRepository watchlist;
  var userSeq = 0;

  setUpAll(() async {
    tzdata.initializeTimeZones();
    db = Pool<void>.withUrl(_url!);
    await _resetSchema(db);
    games = GamesRepository(db);
    watchlist = WatchlistRepository(db);
  });

  tearDownAll(() => db.close());

  Future<Object?> scalar(String sql) async =>
      (await db.execute(sql)).first.first;

  Future<String> createUser({String? quietStart, String? quietEnd}) async {
    final hash = (++userSeq).toRadixString(16).padLeft(64, '0');
    final rows = await db.execute(
      Sql.named('''
        INSERT INTO users (device_id_hash, quiet_hours_start, quiet_hours_end)
        VALUES (@hash:text, CAST(@qs:text AS time), CAST(@qe:text AS time))
        RETURNING id::text
      '''),
      parameters: {'hash': hash, 'qs': quietStart, 'qe': quietEnd},
    );
    return rows.first.first! as String;
  }

  test('список игр: вставка и переименование', () async {
    expect(
      await games.upsertAppList(const [
        SteamAppListEntry(appId: 10, name: 'Counter-Strike'),
        SteamAppListEntry(appId: 20, name: 'Team Fortress'),
        SteamAppListEntry(appId: 730, name: 'CS2'),
        SteamAppListEntry(appId: 570, name: 'Dota 2'),
      ]),
      4,
    );
    expect(
      await games.upsertAppList(const [
        SteamAppListEntry(appId: 10, name: 'Counter-Strike'),
        SteamAppListEntry(appId: 730, name: 'Counter-Strike 2'),
      ]),
      1,
    );
    expect(
      await scalar('SELECT name FROM games WHERE app_id = 730'),
      'Counter-Strike 2',
    );
  });

  test('цены: очередь по подписчикам, история только изменений', () async {
    final user1 = await createUser();
    final user2 = await createUser();
    await db.execute(
      Sql.named('''
        INSERT INTO watchlist (user_id, app_id, target_price) VALUES
          (CAST(@u1:text AS uuid), 730, 300000),
          (CAST(@u2:text AS uuid), 730, NULL),
          (CAST(@u1:text AS uuid), 570, NULL)
      '''),
      parameters: {'u1': user1, 'u2': user2},
    );

    final due = await games.duePrices(
      region: 'kz',
      minAge: const Duration(hours: 2),
      limit: 10,
    );
    expect(due.map((g) => g.appId), [730, 570]);
    expect(due.first.watchers, 2);
    expect(due.first.checkedAt, isNull);

    const price = SteamPriceOverview(
      appId: 730,
      success: true,
      currency: 'KZT',
      initialPrice: 500000,
      finalPrice: 500000,
    );
    await games.savePrices('kz', [
      price,
      const SteamPriceOverview(appId: 570, success: true),
    ]);
    await games.savePrices('kz', [price]); // та же цена
    await games.savePrices('kz', [
      price.copyWith(finalPrice: 250000, discountPct: 50),
    ]);

    expect(
      await scalar('SELECT count(*) FROM price_history WHERE app_id = 730'),
      2,
    );
    expect(
      await scalar('SELECT is_available FROM game_prices WHERE app_id = 570'),
      isFalse,
    );
    expect(
      await games.duePrices(
        region: 'kz',
        minAge: const Duration(hours: 2),
        limit: 10,
      ),
      isEmpty,
    );
  });

  test('уведомления: отправка, без повторов, сброс', () async {
    final notifier = RecordingNotifier();
    final clock = FakeClock(DateTime.now().toUtc());
    final service = NotificationService(
      watchlist: watchlist,
      notifier: notifier,
      queue: InMemoryTaskQueue(clock),
      clock: clock,
    );

    // Текущая цена 730 — 250000 при цели 300000.
    await service.evaluateApps([730, 570], 'kz');
    expect(notifier.sent.single.finalPrice, 250000);
    expect(notifier.sent.single.gameName, 'Counter-Strike 2');
    expect(
      await scalar(
        'SELECT last_notified_price FROM watchlist WHERE target_price = 300000',
      ),
      250000,
    );

    await service.evaluateApps([730], 'kz');
    expect(notifier.sent, hasLength(1), reason: 'та же цена — без повтора');

    await games.savePrices('kz', const [
      SteamPriceOverview(
        appId: 730,
        success: true,
        currency: 'KZT',
        initialPrice: 500000,
        finalPrice: 500000,
      ),
    ]);
    await service.evaluateApps([730], 'kz');
    expect(
      await scalar(
        'SELECT last_notified_price FROM watchlist WHERE target_price = 300000',
      ),
      isNull,
    );
  });

  test(
    'тихие часы: строка подписки читается и уведомление откладывается',
    () async {
      final user = await createUser(quietStart: '00:00', quietEnd: '23:59');
      await db.execute(
        Sql.named(
          'INSERT INTO watchlist (user_id, app_id, min_discount_pct) VALUES (CAST(@u:text AS uuid), 570, 1)',
        ),
        parameters: {'u': user},
      );
      await games.savePrices('kz', const [
        SteamPriceOverview(
          appId: 570,
          success: true,
          currency: 'KZT',
          initialPrice: 1000,
          finalPrice: 500,
          discountPct: 50,
        ),
      ]);
      final row = (await watchlist.find(user, 570))!;
      expect(row.watch.quietHours, isNotNull);
      expect(row.price!.discountPct, 50);

      final clock = FakeClock(DateTime.now().toUtc());
      final queue = InMemoryTaskQueue(clock);
      final notifier = RecordingNotifier();
      await NotificationService(
        watchlist: watchlist,
        notifier: notifier,
        queue: queue,
        clock: clock,
      ).evaluateOne(user, 570);
      expect(notifier.sent, isEmpty);
      expect(queue.tasks.keys.single, 'notify:$user:570');
    },
  );

  test('markNotified защищён от гонки', () async {
    final user = await createUser();
    await db.execute(
      Sql.named(
        'INSERT INTO watchlist (user_id, app_id, target_price) VALUES (CAST(@u:text AS uuid), 10, 1)',
      ),
      parameters: {'u': user},
    );
    expect(await watchlist.markNotified(user, 10, 100, previous: null), isTrue);
    expect(await watchlist.markNotified(user, 10, 90, previous: null), isFalse);
    expect(await watchlist.markNotified(user, 10, 90, previous: 100), isTrue);
  });

  test('онлайн: замеры, пики, топ и порог', () async {
    await games.savePlayerBatch({730: 1000, 570: 500, 10: 50, 999999: 1});
    expect(
      await scalar('SELECT count(*) FROM player_counts'),
      3,
      reason: 'неизвестная игра пропущена',
    );
    await games.savePlayers(20, null);
    expect(
      await scalar(
        'SELECT players_checked_at IS NOT NULL FROM games WHERE app_id = 20',
      ),
      isTrue,
    );

    expect(
      await games.recomputeTopRanks(
        topSize: 2,
        freshness: const Duration(hours: 3),
      ),
      2,
    );
    expect(await scalar('SELECT top_rank FROM games WHERE app_id = 730'), 1);
    expect(
      await scalar('SELECT top_rank FROM games WHERE app_id = 10'),
      isNull,
    );
    expect(await games.topThreshold(2), 500);
    expect(await scalar('SELECT peak_24h FROM games WHERE app_id = 730'), 1000);

    // Игра 10 обгоняет 570 — места пересчитываются.
    await db.execute(
      'UPDATE games SET current_players = 700, players_checked_at = now() WHERE app_id = 10',
    );
    await games.recomputeTopRanks(
      topSize: 2,
      freshness: const Duration(hours: 3),
    );
    expect(await scalar('SELECT top_rank FROM games WHERE app_id = 10'), 2);
    expect(
      await scalar('SELECT top_rank FROM games WHERE app_id = 570'),
      isNull,
    );

    expect(
      await games.dueTopPlayers(
        threshold: 500,
        minAge: Duration.zero,
        limit: 10,
      ),
      hasLength(greaterThanOrEqualTo(2)),
    );
    expect(
      await games.discoveryCandidates(
        minAge: const Duration(days: 30),
        limit: 10,
      ),
      isEmpty,
    );
    expect(await games.compactPlayerCounts(), 0);
  });

  test('обложки: очередь, сохранение, смена адреса, мёртвый адрес', () async {
    await db.execute(
      "UPDATE games SET header_image_url = 'https://cdn.akamai.steamstatic.com/730/h.jpg?t=1' WHERE app_id = 730",
    );
    expect(
      (await games.dueImages(limit: 10)).map((g) => g.appId),
      contains(730),
    );

    await games.saveImage(
      730,
      'https://cdn.akamai.steamstatic.com/730/h.jpg?t=1',
      'image/jpeg',
      [1, 2, 3],
    );
    expect(
      (await games.dueImages(limit: 10)).map((g) => g.appId),
      isNot(contains(730)),
    );
    expect(
      await scalar('SELECT length(etag) FROM game_images WHERE app_id = 730'),
      16,
    );

    // Steam обновил обложку — адрес сменился, скачиваем заново.
    await db.execute(
      "UPDATE games SET header_image_url = 'https://cdn.akamai.steamstatic.com/730/h.jpg?t=2' WHERE app_id = 730",
    );
    expect(
      (await games.dueImages(limit: 10)).map((g) => g.appId),
      contains(730),
    );

    await games.dropImageUrl(
      730,
      'https://cdn.akamai.steamstatic.com/730/h.jpg?t=2',
    );
    expect(
      await scalar('SELECT header_image_url FROM games WHERE app_id = 730'),
      isNull,
    );
    expect(
      (await games.dueImages(limit: 10)).map((g) => g.appId),
      isNot(contains(730)),
    );
  });

  test(
    'исторические минимумы IsThereAnyDeal: поиск ID, минимум, повтор',
    () async {
      await db.execute('UPDATE games SET top_rank = 1 WHERE app_id = 730');
      final lows = StoreLowsRepository(db);
      final due = await lows.due(region: 'kz', limit: 10);
      expect(due, contains(730));

      final calls = <String>[];
      final clock = FakeClock();
      final handlers = TaskHandlers(
        steam: SteamClient(
          httpClient: MockClient((_) async => http.Response('{}', 200)),
          rateLimiter: InMemoryRateLimiter(
            interval: const Duration(milliseconds: 1500),
            clock: clock,
          ),
          apiKey: 'k',
          clock: clock,
        ),
        games: games,
        notifications: NotificationService(
          watchlist: watchlist,
          notifier: RecordingNotifier(),
          queue: InMemoryTaskQueue(clock),
          clock: clock,
        ),
        markers: InMemoryMarkers(),
        config: const WorkerConfig(
          databaseUrl: '',
          redisUrl: '',
          steamApiKey: 'k',
        ),
        steamLinks: SteamLinksRepository(db),
        storeLows: lows,
        itad: ItadClient(
          httpClient: MockClient((request) async {
            calls.add(request.url.path);
            if (request.url.path.contains('lookup')) {
              return http.Response(
                jsonEncode({
                  'app/730': '018d937f-07a7-72c5-a2fc-0b14f1a6c2f6',
                  'app/570': null,
                }),
                200,
              );
            }
            return http.Response(
              jsonEncode([
                {
                  'id': '018d937f-07a7-72c5-a2fc-0b14f1a6c2f6',
                  'lows': [
                    {
                      'shop': {'id': 61, 'name': 'Steam'},
                      'price': {
                        'amount': 3375,
                        'amountInt': 337500,
                        'currency': 'KZT',
                      },
                      'regular': {
                        'amount': 22500,
                        'amountInt': 2250000,
                        'currency': 'KZT',
                      },
                      'cut': 85,
                      'timestamp': '2025-06-26T17:00:00Z',
                    },
                  ],
                },
              ]),
              200,
            );
          }),
          rateLimiter: InMemoryRateLimiter(
            interval: const Duration(milliseconds: 1500),
            clock: clock,
          ),
          apiKey: 'itad',
          clock: clock,
        ),
        clock: clock,
      );
      Future<void> run() => handlers.handle(
        const QueueTask(
          id: 'store_lows:kz:test',
          kind: TaskKind.storeLows,
          lane: Lane.itad,
          priority: 0,
          payload: {
            'region': 'kz',
            'app_ids': [570, 730],
          },
        ),
      );

      await run();
      expect(calls, ['/lookup/id/shop/61/v1', '/games/storelow/v2']);
      final row = (await db.execute(
        'SELECT low_price, regular_price, cut, currency, low_at FROM game_store_lows '
        "WHERE app_id = 730 AND region = 'kz'",
      )).first;
      expect(row.toList(), [
        337500,
        2250000,
        85,
        'KZT',
        DateTime.utc(2025, 6, 26, 17),
      ]);
      // Неизвестная ITAD игра сохранена без минимума: искать снова не нужно.
      expect(
        await scalar(
          'SELECT itad_id IS NULL AND low_price IS NULL FROM game_store_lows WHERE app_id = 570',
        ),
        isTrue,
      );
      expect(await lows.due(region: 'kz', limit: 10), isNot(contains(730)));

      // Повтор: ID уже известны — только запрос минимумов.
      calls.clear();
      await run();
      expect(calls, ['/games/storelow/v2']);
    },
  );

  group('импорт списка желаемого Steam', () {
    late String user;
    late SteamLinksRepository links;
    late List<Uri> steamCalls;
    late Map<String, Object?> Function(Uri uri) steamAnswer;

    TaskHandlers handlers() {
      final clock = FakeClock();
      steamCalls = [];
      return TaskHandlers(
        steam: SteamClient(
          httpClient: MockClient((request) async {
            steamCalls.add(request.url);
            return http.Response(jsonEncode(steamAnswer(request.url)), 200);
          }),
          rateLimiter: InMemoryRateLimiter(
            interval: const Duration(milliseconds: 1500),
            clock: clock,
          ),
          apiKey: 'k',
          clock: clock,
        ),
        games: games,
        notifications: NotificationService(
          watchlist: watchlist,
          notifier: RecordingNotifier(),
          queue: InMemoryTaskQueue(clock),
          clock: clock,
        ),
        markers: InMemoryMarkers(),
        config: const WorkerConfig(
          databaseUrl: '',
          redisUrl: '',
          steamApiKey: 'k',
        ),
        steamLinks: links,
        clock: clock,
      );
    }

    Map<String, Object?> publicProfile(Uri uri, List<int> wishlist) =>
        switch (uri.path) {
          final p when p.contains('ResolveVanityURL') => {
            'response': {'steamid': '76561197960287930', 'success': 1},
          },
          final p when p.contains('GetPlayerSummaries') => {
            'response': {
              'players': [
                {
                  'steamid': '76561197960287930',
                  'personaname': 'Tester',
                  'communityvisibilitystate': 3,
                },
              ],
            },
          },
          final p when p.contains('GetWishlistItemCount') => {
            'response': {'count': wishlist.length},
          },
          _ => {
            'response': {
              'items': [
                for (var i = 0; i < wishlist.length; i++)
                  {'appid': wishlist[i], 'priority': i},
              ],
            },
          },
        };

    Future<void> runImport() => handlers().handle(
      QueueTask(
        id: 'wishlist:$user',
        kind: TaskKind.wishlist,
        lane: Lane.api,
        priority: 0,
        payload: {'user_id': user},
      ),
    );

    Future<List<List<Object?>>> rows() async => [
      for (final r in await db.execute(
        Sql.named('''
          SELECT app_id, source, min_discount_pct FROM watchlist
          WHERE user_id = CAST(@u:text AS uuid) ORDER BY app_id
        '''),
        parameters: {'u': user},
      ))
        r.toList(),
    ];

    setUp(() async {
      user = await createUser();
      links = SteamLinksRepository(db);
      await db.execute(
        Sql.named('''
          INSERT INTO steam_links (user_id, profile_input, import_min_discount_pct)
          VALUES (CAST(@u:text AS uuid), 'https://steamcommunity.com/id/tester/', 50)
        '''),
        parameters: {'u': user},
      );
    });

    test(
      'ник → SteamID → список; новые игры добавляются, ручные не трогаются',
      () async {
        // Ручная запись на игру, которая есть и в списке желаемого.
        await db.execute(
          Sql.named('''
          INSERT INTO watchlist (user_id, app_id, target_price)
          VALUES (CAST(@u:text AS uuid), 570, 100)
        '''),
          parameters: {'u': user},
        );
        expect(await links.dueUserIds(limit: 50), contains(user));

        steamAnswer = (uri) => publicProfile(uri, [730, 570, 999001]);
        await runImport();

        expect(steamCalls.map((u) => u.path.split('/')[1]), [
          'ISteamUser',
          'ISteamUser',
          'IWishlistService',
        ]);
        expect(await rows(), [
          [570, 'manual', null],
          [730, 'wishlist', 50],
          [999001, 'wishlist', 50],
        ]);
        final link = (await db.execute(
          Sql.named(
            'SELECT status, steam_id, persona_name, wishlist_count, imported_count '
            'FROM steam_links WHERE user_id = CAST(@u:text AS uuid)',
          ),
          parameters: {'u': user},
        )).first;
        expect(link.toList(), ['ok', '76561197960287930', 'Tester', 3, 2]);
        expect(await links.dueUserIds(limit: 50), isNot(contains(user)));
        // Неизвестная игра добавлена в каталог, название подставят описания.
        expect(
          await scalar('SELECT name FROM games WHERE app_id = 999001'),
          'App 999001',
        );

        // Игру убрали из списка желаемого, порог сменили: синхронизация.
        await db.execute(
          Sql.named(
            "UPDATE steam_links SET import_min_discount_pct = 75, synced_at = now() - interval '2 days' "
            'WHERE user_id = CAST(@u:text AS uuid)',
          ),
          parameters: {'u': user},
        );
        expect(await links.dueUserIds(limit: 50), contains(user));
        steamAnswer = (uri) => publicProfile(uri, [999001]);
        await runImport();
        expect(await rows(), [
          [570, 'manual', null],
          [999001, 'wishlist', 75],
        ]);
        // SteamID сохранён: ник повторно не разрешается.
        expect(
          steamCalls.where((u) => u.path.contains('ResolveVanityURL')),
          isEmpty,
        );
      },
    );

    test('лимит списка соблюдается', () async {
      final many = [
        for (var i = 0; i < WatchlistLimits.maxItems + 50; i++) 800000 + i,
      ];
      steamAnswer = (uri) => publicProfile(uri, many);
      await runImport();
      expect(
        await scalar("SELECT count(*) FROM watchlist WHERE user_id = '$user'"),
        WatchlistLimits.maxItems,
      );
      expect(
        await scalar(
          "SELECT wishlist_count FROM steam_links WHERE user_id = '$user'",
        ),
        WatchlistLimits.maxItems + 50,
      );
    });

    test('скрытый профиль и несуществующий ник', () async {
      steamAnswer = (uri) => uri.path.contains('GetPlayerSummaries')
          ? {
              'response': {
                'players': [
                  {
                    'steamid': '76561197960287930',
                    'communityvisibilitystate': 2,
                  },
                ],
              },
            }
          : publicProfile(uri, [730]);
      await runImport();
      expect(
        await scalar("SELECT status FROM steam_links WHERE user_id = '$user'"),
        'private_profile',
      );
      expect(await rows(), isEmpty);
      expect(steamCalls.where((u) => u.path.contains('Wishlist')), isEmpty);

      await db.execute(
        "UPDATE steam_links SET steam_id = NULL, status = 'pending' WHERE user_id = '$user'",
      );
      steamAnswer = (uri) => {
        'response': {'success': 42, 'message': 'No match'},
      };
      await runImport();
      expect(
        await scalar("SELECT status FROM steam_links WHERE user_id = '$user'"),
        'not_found',
      );
      expect(await links.dueUserIds(limit: 50), isNot(contains(user)));
    });

    test('открытый профиль со скрытым списком: игры не удаляются', () async {
      steamAnswer = (uri) => publicProfile(uri, [730]);
      await runImport();
      expect(await rows(), [
        [730, 'wishlist', 50],
      ]);

      // Список скрыли: Steam отвечает пусто и без count.
      await db.execute(
        "UPDATE steam_links SET status = 'pending' WHERE user_id = '$user'",
      );
      steamAnswer = (uri) => uri.path.contains('Wishlist')
          ? {'response': <String, Object?>{}}
          : publicProfile(uri, const []);
      await runImport();
      expect(
        await scalar("SELECT status FROM steam_links WHERE user_id = '$user'"),
        'private_profile',
      );
      expect(await rows(), [
        [730, 'wishlist', 50],
      ]);

      // Открытый, но пустой список — синхронизация убирает импортированное.
      await db.execute(
        "UPDATE steam_links SET status = 'pending' WHERE user_id = '$user'",
      );
      steamAnswer = (uri) => publicProfile(uri, const []);
      await runImport();
      expect(
        await scalar("SELECT status FROM steam_links WHERE user_id = '$user'"),
        'ok',
      );
      expect(await rows(), isEmpty);
    });
  });

  test('описание и отзывы', () async {
    await games.saveDetails(
      730,
      SteamAppDetails(
        appId: 730,
        name: 'Counter-Strike 2',
        type: 'game',
        isFree: true,
        shortDescription: 'EN',
        developers: const ['Valve'],
        genres: const ['Action', "Free 'To' Play"],
        releaseDate: DateTime.utc(2012, 8, 21),
      ),
      {'en': 'EN', 'ru': 'РУ'},
    );
    await games.saveReviews(
      730,
      const SteamReviewSummary(totalPositive: 8, totalReviews: 10),
    );
    final row = (await db.execute(
      "SELECT short_description->>'ru', genres, release_date::text, reviews_positive, is_free FROM games WHERE app_id = 730",
    )).first;
    expect(row[0], 'РУ');
    expect(row[1], ['Action', "Free 'To' Play"]);
    expect(row[2], '2012-08-21');
    expect(row[3], 8);
    expect(row[4], isTrue);
    expect(
      await games.dueDetails(minAge: const Duration(days: 6), limit: 10),
      isNot(contains(predicate<DueGame>((g) => g.appId == 730))),
    );
  });

  test(
    'сквозной сценарий: задача цен через Steam-клиент с подменой HTTP',
    () async {
      final clock = FakeClock();
      final notifier = RecordingNotifier();
      final steam = SteamClient(
        httpClient: MockClient(
          (request) async => http.Response(
            jsonEncode({
              '730': {
                'success': true,
                'data': {
                  'price_overview': {
                    'currency': 'KZT',
                    'initial': 500000,
                    'final': 100000,
                    'discount_percent': 80,
                  },
                },
              },
            }),
            200,
          ),
        ),
        rateLimiter: InMemoryRateLimiter(
          interval: const Duration(milliseconds: 1500),
          clock: clock,
        ),
        apiKey: 'k',
        clock: clock,
      );
      final queue = InMemoryTaskQueue(clock);
      final handlers = TaskHandlers(
        steam: steam,
        games: games,
        notifications: NotificationService(
          watchlist: watchlist,
          notifier: notifier,
          queue: queue,
          clock: FakeClock(DateTime.now().toUtc()),
        ),
        markers: InMemoryMarkers(),
        config: const WorkerConfig(
          databaseUrl: '',
          redisUrl: '',
          steamApiKey: 'k',
        ),
        steamLinks: SteamLinksRepository(db),
        clock: clock,
      );
      await handlers.handle(
        const QueueTask(
          id: 'prices:test',
          kind: TaskKind.prices,
          lane: Lane.store,
          priority: 0,
          payload: {
            'region': 'kz',
            'app_ids': [730, 20],
          },
        ),
      );
      expect(
        await scalar(
          "SELECT final_price FROM game_prices WHERE app_id = 730 AND region = 'kz'",
        ),
        100000,
      );
      expect(notifier.sent.map((a) => a.finalPrice), contains(100000));
    },
  );
}
