import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/core/cache/cached_resource.dart';
import 'package:gameradar_app/core/database/app_database.dart';
import 'package:gameradar_app/core/network/app_exception.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  late int fetches;
  late Future<List<int>> Function() serverResponse;

  CachedResource<List<int>> resource({String key = 'test'}) =>
      CachedResource<List<int>>(
        db: db,
        key: key,
        fetch: () {
          fetches++;
          return serverResponse();
        },
        decode: (json) => (json! as List).cast<int>(),
        encode: (data) => data,
        staleAfter: const Duration(minutes: 5),
        now: () => now,
      );

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime(2026, 10, 11, 12);
    fetches = 0;
    serverResponse = () async => [1, 2, 3];
  });

  tearDown(() => db.close());

  test('сначала пусто, после обновления — данные и время получения', () async {
    final r = resource();
    expect(await r.watch().first, isNull);
    await r.refreshIfStale();
    final cached = (await r.watch().first)!;
    expect(cached.data, [1, 2, 3]);
    expect(cached.fetchedAt, now);
  });

  test('свежие данные при открытии экрана повторно не запрашиваются', () async {
    final r = resource();
    await r.refreshIfStale();
    now = now.add(const Duration(minutes: 4));
    await r.refreshIfStale();
    expect(fetches, 1);
    now = now.add(const Duration(minutes: 2));
    await r.refreshIfStale();
    expect(fetches, 2);
  });

  test('pull-to-refresh не чаще раза в минуту (правило 10)', () async {
    final r = resource();
    expect(await r.refreshByUser(), RefreshResult.refreshed);
    now = now.add(const Duration(seconds: 59));
    expect(await r.refreshByUser(), RefreshResult.throttled);
    expect(fetches, 1);
    now = now.add(const Duration(seconds: 1));
    expect(await r.refreshByUser(), RefreshResult.refreshed);
    expect(fetches, 2);
  });

  test('одновременные обновления делят один запрос', () async {
    final gate = Completer<List<int>>();
    serverResponse = () => gate.future;
    final r = resource();
    final a = r.refreshIfStale();
    final b = r.refreshIfStale();
    await Future<void>.delayed(Duration.zero);
    gate.complete([7]);
    await Future.wait([a, b]);
    expect(fetches, 1);
    expect((await r.watch().first)!.data, [7]);
  });

  test('ошибка сети не стирает кэш', () async {
    final r = resource();
    await r.refreshIfStale();
    serverResponse = () async => throw const NetworkException();
    now = now.add(const Duration(hours: 1));
    await expectLater(r.refreshIfStale(), throwsA(isA<NetworkException>()));
    expect((await r.watch().first)!.data, [1, 2, 3]);
  });

  test('поток сообщает об обновлениях', () async {
    final r = resource();
    final values = <List<int>?>[];
    final sub = r.watch().listen((c) => values.add(c?.data));
    await pumpEventQueue();
    await r.refreshIfStale();
    await pumpEventQueue();
    await sub.cancel();
    expect(values, [
      null,
      [1, 2, 3],
    ]);
  });

  test('повреждённая запись считается отсутствующей', () async {
    await db.putCache('broken', '{"not": "a list"}', now);
    expect(await resource(key: 'broken').watch().first, isNull);
  });
}
