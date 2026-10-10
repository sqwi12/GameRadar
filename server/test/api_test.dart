@Tags(['db'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';
import 'package:gameradar_shared/dotenv.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

/// Интеграционные тесты эндпоинтов на настоящем PostgreSQL.
///
/// ВНИМАНИЕ: пересоздаёт схему public в базе из TEST_DATABASE_URL
/// (берётся из окружения или .env). Запуск: dart test -t db
final _url = loadEnvironment()['TEST_DATABASE_URL'];

void main() {
  if (_url == null) {
    test('TEST_DATABASE_URL не задан', () {}, skip: 'нет тестовой БД');
    return;
  }

  late Pool<void> db;
  late Services services;

  Uri uri(String path) => Uri.parse('http://localhost$path');

  Future<(int, Object?)> call(Future<Response> Function() handler) async {
    try {
      final response = await handler();
      final body = await response.body();
      return (response.statusCode, body.isEmpty ? null : jsonDecode(body));
    } on ApiException catch (e) {
      final response = e.toResponse();
      return (response.statusCode, jsonDecode(await response.body()));
    } on RequestValidationException catch (e) {
      return (400, e.toApiError().toJson() as Object?);
    }
  }

  Map<String, Object?> obj(Object? body) => body! as Map<String, Object?>;

  Future<({AuthUser user, String token})> signIn(
    String deviceId, {
    Map<String, Object?>? settings,
  }) async {
    final (status, body) = await call(
      () => anonymousSignIn(
        Request.post(
          uri('/auth/anonymous'),
          body: jsonEncode({
            'device_id': deviceId,
            'initial_settings': ?settings,
          }),
        ),
        services,
      ),
    );
    expect(status, 200, reason: '$body');
    final auth = AuthResponse.fromJson(obj(body));
    return (user: AuthUser(auth.user.id), token: auth.accessToken);
  }

  setUpAll(() async {
    db = Pool<void>.withUrl(_url!);
    await db.execute('DROP SCHEMA public CASCADE');
    await db.execute('CREATE SCHEMA public');
    final files =
        Directory('../migrations')
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.sql'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      await db.execute(
        file.readAsStringSync().split('-- migrate:down').first,
        queryMode: QueryMode.simple,
      );
    }
    services = Services(
      config: const ServerConfig(
        databaseUrl: '',
        jwtSecret: 'test-secret-test-secret-test-secret!',
        maxWatchlistSize: 3,
      ),
      db: db,
    );

    // Данные, которые обычно пишет worker.
    await db.execute('''
      INSERT INTO games (app_id, name, type, short_description, genres, release_date,
                         current_players, peak_24h, peak_7d, top_rank, reviews_positive, reviews_total)
      VALUES
        (730, 'Counter-Strike 2', 'game', '{"en":"CS","ru":"КС"}', '{Action}', '2012-08-21', 900000, 1000000, 1100000, 1, 8, 10),
        (570, 'Dota 2', 'game', '{}', '{}', NULL, 700000, 650000, 800000, 2, NULL, NULL),
        (292030, 'The Witcher 3: Wild Hunt', 'game', '{}', '{RPG}', NULL, 30000, 31000, 35000, 3, NULL, NULL),
        (20920, 'The Witcher 2: Assassins of Kings', NULL, '{}', '{}', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
        (1, 'Witcher', NULL, '{}', '{}', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
        (2, '100% Orange Juice', NULL, '{}', '{}', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    ''');
    await db.execute('''
      INSERT INTO game_prices (app_id, region, is_available, currency, initial_price, final_price, discount_pct, checked_at)
      VALUES
        (292030, 'kz', true, 'KZT', 1599900, 399900, 75, now()),
        (20920, 'kz', true, 'KZT', 500000, 400000, 20, now()),
        (2, 'kz', true, 'KZT', 100000, 50000, 50, now() - interval '2 days'),
        (730, 'kz', false, NULL, NULL, NULL, 0, now())
    ''');
    await db.execute('''
      INSERT INTO player_counts (app_id, recorded_at, players)
      SELECT 730, now() - (n || ' hours')::interval, 800000 + n * 1000 FROM generate_series(1, 100) n
    ''');
  });

  tearDownAll(() => db.close());

  group('auth', () {
    test('вход создаёт пользователя, повторный — возвращает того же', () async {
      final first = await signIn(
        'device-aaaaaaaaaaaaaaaa',
        settings: {
          'locale': 'en',
          'timezone': 'Europe/Moscow',
          'quiet_hours': {'start': '23:00', 'end': '07:30'},
        },
      );
      final again = await signIn('device-aaaaaaaaaaaaaaaa');
      expect(again.user.id, first.user.id);

      final (status, body) = await call(
        () => getMe(Request.get(uri('/me')), services, first.user),
      );
      expect(status, 200);
      final profile = UserProfile.fromJson(obj(body));
      expect(profile.settings.locale, AppLocale.en);
      expect(profile.settings.timezone, 'Europe/Moscow');
      expect(profile.settings.quietHours!.end, const ClockTime(7, 30));
      expect(profile.settings.region, 'kz');
    });

    test('сырой ID устройства в БД не хранится', () async {
      await signIn('device-secret-000000000');
      final rows = await db.execute(
        "SELECT count(*) FROM users WHERE device_id_hash LIKE '%secret%'",
      );
      expect(rows.first.first, 0);
    });

    test(
      'неизвестный часовой пояс с устройства заменяется на пояс по умолчанию',
      () async {
        final auth = await signIn(
          'device-tz-0000000000000',
          settings: {'timezone': 'Mars/Olympus'},
        );
        final profile = (await services.users.find(auth.user.id))!;
        expect(profile.settings.timezone, 'Asia/Almaty');
      },
    );

    test('короткий ID устройства и битый JSON — 400', () async {
      var (status, body) = await call(
        () => anonymousSignIn(
          Request.post(uri('/auth/anonymous'), body: '{"device_id":"short"}'),
          services,
        ),
      );
      expect(status, 400);
      expect(obj(body)['code'], ApiErrorCode.validation);

      (status, _) = await call(
        () => anonymousSignIn(
          Request.post(uri('/auth/anonymous'), body: '{oops'),
          services,
        ),
      );
      expect(status, 400);
    });

    test(
      'authenticate: без токена, с мусором и с действующим токеном',
      () async {
        final auth = await signIn('device-bbbbbbbbbbbbbbbb');
        expect(
          () => authenticate(Request.get(uri('/me')), services),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 401),
          ),
        );
        expect(
          () => authenticate(
            Request.get(
              uri('/me'),
              headers: {'Authorization': 'Bearer abc.def.ghi'},
            ),
            services,
          ),
          throwsA(isA<ApiException>()),
        );
        final user = authenticate(
          Request.get(
            uri('/me'),
            headers: {'Authorization': 'Bearer ${auth.token}'},
          ),
          services,
        );
        expect(user.id, auth.user.id);
      },
    );
  });

  group('настройки', () {
    test(
      'PUT /me/settings заменяет настройки целиком, тихие часы снимаются',
      () async {
        final auth = await signIn(
          'device-settings-00000000',
          settings: {
            'quiet_hours': {'start': '22:00', 'end': '08:00'},
          },
        );
        final (status, body) = await call(
          () => putSettings(
            Request.put(
              uri('/me/settings'),
              body: jsonEncode(
                const UserSettings(
                  locale: AppLocale.en,
                  notificationsEnabled: false,
                ).toJson(),
              ),
            ),
            services,
            auth.user,
          ),
        );
        expect(status, 200);
        final profile = UserProfile.fromJson(obj(body));
        expect(profile.settings.quietHours, isNull);
        expect(profile.settings.notificationsEnabled, isFalse);
      },
    );

    test('несуществующий часовой пояс — 400 с полем timezone', () async {
      final auth = await signIn('device-settings-11111111');
      final (status, body) = await call(
        () => putSettings(
          Request.put(
            uri('/me/settings'),
            body: jsonEncode({'timezone': 'Mars/Olympus'}),
          ),
          services,
          auth.user,
        ),
      );
      expect(status, 400);
      expect((obj(body)['fields']! as List).single, {
        'field': 'timezone',
        'code': 'invalid_format',
      });
    });
  });

  group('игры', () {
    Future<Paginated<GameSummary>> page(
      Future<Response> Function() handler,
    ) async {
      final (status, body) = await call(handler);
      expect(status, 200, reason: '$body');
      return Paginated.fromJson(
        obj(body),
        (j) => GameSummary.fromJson(j! as Map<String, Object?>),
      );
    }

    test(
      'поиск: точное совпадение, затем начало названия, затем популярность',
      () async {
        final result = await page(
          () => searchGames(
            Request.get(uri('/games/search?q=witcher')),
            services,
          ),
        );
        expect(result.items.map((g) => g.appId), [1, 292030, 20920]);
        expect(result.items[1].price!.finalPrice, 399900);
      },
    );

    test('поиск: % и _ в запросе — обычные символы', () async {
      final result = await page(
        () => searchGames(Request.get(uri('/games/search?q=100%25')), services),
      );
      expect(result.items.map((g) => g.name), ['100% Orange Juice']);
      final none = await page(
        () => searchGames(Request.get(uri('/games/search?q=_%25')), services),
      );
      expect(none.items, isEmpty);
    });

    test('поиск: слишком короткий запрос — 400', () async {
      final (status, _) = await call(
        () => searchGames(Request.get(uri('/games/search?q=a')), services),
      );
      expect(status, 400);
    });

    test('топ: по месту, по пику, только со скидкой', () async {
      final byRank = await page(
        () => topGames(Request.get(uri('/games/top')), services),
      );
      expect(byRank.items.map((g) => g.appId), [730, 570, 292030]);
      expect(byRank.total, 3);

      final byPeak = await page(
        () => topGames(
          Request.get(uri('/games/top?sort=peak_24h&limit=2')),
          services,
        ),
      );
      expect(byPeak.items.map((g) => g.appId), [730, 570]);
      expect(byPeak.hasMore, isTrue);

      final discounted = await page(
        () => topGames(
          Request.get(uri('/games/top?only_discounted=true')),
          services,
        ),
      );
      expect(discounted.items.map((g) => g.appId), [292030]);
    });

    test(
      'скидки: устаревшие цены не показываются, фильтры и сортировка работают',
      () async {
        final all = await page(
          () => discountedGames(Request.get(uri('/games/discounts')), services),
        );
        expect(all.items.map((g) => g.appId), [
          292030,
          20920,
        ], reason: 'цена app 2 устарела');

        final cheap = await page(
          () => discountedGames(
            Request.get(uri('/games/discounts?sort=price&max_price=399900')),
            services,
          ),
        );
        expect(cheap.items.map((g) => g.appId), [292030]);

        final big = await page(
          () => discountedGames(
            Request.get(uri('/games/discounts?min_discount_pct=50')),
            services,
          ),
        );
        expect(big.items.map((g) => g.appId), [292030]);
      },
    );

    test('экран игры: данные, цена, отметка просмотра', () async {
      final (status, body) = await call(
        () => gameDetails(Request.get(uri('/games/730')), services, '730'),
      );
      expect(status, 200);
      final details = GameDetails.fromJson(obj(body));
      expect(details.name, 'Counter-Strike 2');
      expect(details.descriptionFor('ru'), 'КС');
      expect(details.releaseDate, DateTime.utc(2012, 8, 21));
      expect(details.reviews!.positivePct, 80);
      expect(details.players.peak24h, 1000000);
      expect(details.price!.isAvailable, isFalse);

      final viewed = await db.execute(
        'SELECT viewed_at IS NOT NULL FROM games WHERE app_id = 730',
      );
      expect(viewed.first.first, isTrue);
    });

    test('экран игры: несуществующая игра и мусор вместо id — 404', () async {
      expect(
        (await call(
          () => gameDetails(Request.get(uri('/games/999')), services, '999'),
        )).$1,
        404,
      );
      expect(
        (await call(
          () => gameDetails(Request.get(uri('/games/abc')), services, 'abc'),
        )).$1,
        404,
      );
    });

    test('график онлайна: 24 ч и 7 дней по возрастанию времени', () async {
      final (status, body) = await call(
        () => playerHistory(
          Request.get(uri('/games/730/players?period=24h')),
          services,
          '730',
        ),
      );
      expect(status, 200);
      final history = PlayerHistory.fromJson(obj(body));
      expect(history.points, hasLength(23));
      expect(
        history.points.first.recordedAt.isBefore(
          history.points.last.recordedAt,
        ),
        isTrue,
      );

      final week = PlayerHistory.fromJson(
        obj(
          (await call(
            () => playerHistory(
              Request.get(uri('/games/730/players')),
              services,
              '730',
            ),
          )).$2,
        ),
      );
      expect(week.period, HistoryPeriod.week);
      expect(week.points, hasLength(100));

      final (bad, _) = await call(
        () => playerHistory(
          Request.get(uri('/games/730/players?period=1y')),
          services,
          '730',
        ),
      );
      expect(bad, 400);
    });

    test('история цен', () async {
      final (status, body) = await call(
        () => priceHistory(
          Request.get(uri('/games/292030/prices')),
          services,
          '292030',
        ),
      );
      expect(status, 200);
      final entries = (body! as List).map(
        (j) => PriceHistoryEntry.fromJson(j as Map<String, Object?>),
      );
      expect(entries.single.finalPrice, 399900);
    });
  });

  group('список отслеживания', () {
    test('добавление, изменение порогов, список, удаление', () async {
      final auth = await signIn('device-watch-0000000000');
      Future<(int, Object?)> put(String id, Map<String, Object?> body) => call(
        () => putWatchlistItem(
          Request.put(uri('/watchlist/$id'), body: jsonEncode(body)),
          services,
          auth.user,
          id,
        ),
      );

      var (status, body) = await put('292030', {'target_price': 300000});
      expect(status, 201);
      expect(WatchlistItem.fromJson(obj(body)).game.price!.discountPct, 75);

      // Отметка уведомления сбрасывается при смене порогов, но не при повторе тех же.
      await db.execute(
        'UPDATE watchlist SET last_notified_price = 399900 WHERE app_id = 292030',
      );
      (status, body) = await put('292030', {'target_price': 300000});
      expect(status, 200);
      expect(WatchlistItem.fromJson(obj(body)).lastNotifiedPrice, 399900);
      (status, body) = await put('292030', {
        'target_price': 200000,
        'min_discount_pct': 80,
      });
      expect(WatchlistItem.fromJson(obj(body)).lastNotifiedPrice, isNull);

      expect((await put('999', {})).$1, 404);
      expect((await put('570', {'min_discount_pct': 0})).$1, 400);

      final (listStatus, list) = await call(
        () =>
            listWatchlist(Request.get(uri('/watchlist')), services, auth.user),
      );
      expect(listStatus, 200);
      expect(
        (list! as List).map(
          (j) => WatchlistItem.fromJson(j as Map<String, Object?>).game.appId,
        ),
        [292030],
      );

      final watchers = await db.execute(
        'SELECT watchers_count FROM games WHERE app_id = 292030',
      );
      expect(watchers.first.first, 1);

      final (deleted, _) = await call(
        () => deleteWatchlistItem(
          Request.delete(uri('/watchlist/292030')),
          services,
          auth.user,
          '292030',
        ),
      );
      expect(deleted, 204);
      final (again, _) = await call(
        () => deleteWatchlistItem(
          Request.delete(uri('/watchlist/292030')),
          services,
          auth.user,
          '292030',
        ),
      );
      expect(again, 404);
    });

    test('лимит размера списка — 409', () async {
      final auth = await signIn('device-limit-0000000000');
      for (final id in ['730', '570', '292030']) {
        await putWatchlistItem(
          Request.put(uri('/watchlist/$id'), body: '{}'),
          services,
          auth.user,
          id,
        );
      }
      final (status, body) = await call(
        () => putWatchlistItem(
          Request.put(uri('/watchlist/20920'), body: '{}'),
          services,
          auth.user,
          '20920',
        ),
      );
      expect(status, 409);
      expect(obj(body)['code'], ApiErrorCode.limitExceeded);
      // Изменение уже добавленной игры при полном списке разрешено.
      final (update, _) = await call(
        () => putWatchlistItem(
          Request.put(uri('/watchlist/730'), body: '{"min_discount_pct":10}'),
          services,
          auth.user,
          '730',
        ),
      );
      expect(update, 200);
    });

    test('регион записи фиксируется при добавлении', () async {
      final auth = await signIn(
        'device-region-000000000',
        settings: {'region': 'us'},
      );
      final (_, body) = await call(
        () => putWatchlistItem(
          Request.put(uri('/watchlist/730'), body: '{}'),
          services,
          auth.user,
          '730',
        ),
      );
      expect(WatchlistItem.fromJson(obj(body)).region, 'us');
    });
  });

  group('устройства', () {
    test('токен регистрируется и переходит к новому пользователю', () async {
      final a = await signIn('device-fcm-a-0000000000');
      final b = await signIn('device-fcm-b-0000000000');
      Future<int> put(AuthUser user) async => (await call(
        () => putDevice(
          Request.put(
            uri('/devices'),
            body: '{"fcm_token":"tok-1","platform":"android"}',
          ),
          services,
          user,
        ),
      )).$1;
      expect(await put(a.user), 204);
      expect(await put(b.user), 204);
      final owner = await db.execute(
        "SELECT user_id::text FROM devices WHERE fcm_token = 'tok-1'",
      );
      expect(owner.single.first, b.user.id);

      // Чужой токен удалить нельзя, свой — можно.
      await deleteDevice(
        Request.delete(uri('/devices'), body: '{"fcm_token":"tok-1"}'),
        services,
        a.user,
      );
      expect((await db.execute('SELECT count(*) FROM devices')).first.first, 1);
      await deleteDevice(
        Request.delete(uri('/devices'), body: '{"fcm_token":"tok-1"}'),
        services,
        b.user,
      );
      expect((await db.execute('SELECT count(*) FROM devices')).first.first, 0);
    });

    test('неверная платформа — 400', () async {
      final a = await signIn('device-fcm-c-0000000000');
      final (status, _) = await call(
        () => putDevice(
          Request.put(
            uri('/devices'),
            body: '{"fcm_token":"t","platform":"windows"}',
          ),
          services,
          a.user,
        ),
      );
      expect(status, 400);
    });
  });
}
