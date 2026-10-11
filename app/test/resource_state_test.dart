import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/core/cache/cached_resource.dart';
import 'package:gameradar_app/core/cache/resource_state.dart';
import 'package:gameradar_app/core/database/app_database.dart';
import 'package:gameradar_app/core/network/app_exception.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

/// Состояние «как в Notifier»: binding читает и пишет его через колбэки.
class Holder<T> {
  Holder(this.value);

  T value;
  final history = <T>[];

  T read() => value;

  void write(T v) {
    value = v;
    history.add(v);
  }
}

void main() {
  late AppDatabase db;
  late DateTime now;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime(2026, 10, 11, 12);
  });

  tearDown(() => db.close());

  group('ResourceBinding', () {
    test('загрузка → данные; повторный вход сразу показывает кэш', () async {
      CachedResource<int> resource(Future<int> Function() fetch) =>
          CachedResource<int>(
            db: db,
            key: 'k',
            fetch: fetch,
            decode: (j) => j! as int,
            encode: (v) => v,
            now: () => now,
          );

      final first = Holder(const ResourceView<int>());
      ResourceBinding(
        resource(() async => 42),
        read: first.read,
        write: first.write,
      ).start();
      expect(first.value.isInitialLoading, isTrue);
      await pumpEventQueue();
      expect(first.value.data, 42);
      expect(first.value.refreshing, isFalse);
      expect(first.value.isInitialLoading, isFalse);

      // Второй экран: сервер недоступен, но кэш показывается с пометкой об ошибке.
      final second = Holder(const ResourceView<int>());
      now = now.add(const Duration(hours: 1));
      ResourceBinding(
        resource(() async => throw const NetworkException()),
        read: second.read,
        write: second.write,
      ).start();
      await pumpEventQueue();
      expect(second.value.data, 42);
      expect(second.value.error, isA<NetworkException>());
      expect(second.value.isInitialLoading, isFalse);
    });

    test(
      'ошибка без кэша — не загрузка, а ошибка (экран покажет «Повторить»)',
      () async {
        final h = Holder(const ResourceView<int>());
        var calls = 0;
        final binding = ResourceBinding(
          CachedResource<int>(
            db: db,
            key: 'e',
            fetch: () async {
              calls++;
              if (calls == 1) throw const NetworkException();
              return 7;
            },
            decode: (j) => j! as int,
            encode: (v) => v,
            now: () => now,
          ),
          read: h.read,
          write: h.write,
        )..start();
        await pumpEventQueue();
        expect(h.value.data, isNull);
        expect(h.value.isInitialLoading, isFalse);
        expect(h.value.error, isA<NetworkException>());

        await binding.retry();
        await pumpEventQueue();
        expect(h.value.data, 7);
        expect(h.value.error, isNull);
      },
    );

    test('после dispose состояние не меняется', () async {
      final h = Holder(const ResourceView<int>());
      ResourceBinding(
          CachedResource<int>(
            db: db,
            key: 'd',
            fetch: () async => 1,
            decode: (j) => j! as int,
            encode: (v) => v,
            now: () => now,
          ),
          read: h.read,
          write: h.write,
        )
        ..start()
        ..dispose();
      final writes = h.history.length;
      await pumpEventQueue();
      expect(h.history.length, writes);
    });
  });

  group('PagedBinding', () {
    Paginated<int> page(int offset, {int limit = 2, int total = 5}) =>
        Paginated(
          items: [for (var i = offset; i < offset + limit && i < total; i++) i],
          offset: offset,
          limit: limit,
          total: total,
        );

    test('первая страница из кэша, следующие догружаются до конца', () async {
      final h = Holder(const PagedView<int>());
      final fetched = <int>[];
      final binding = PagedBinding<int>(
        CachedResource<Paginated<int>>(
          db: db,
          key: 'p',
          fetch: () async => page(0),
          decode: (j) =>
              Paginated.fromJson(j! as Map<String, Object?>, (e) => e! as int),
          encode: (p) => p.toJson((e) => e),
          now: () => now,
        ),
        fetchPage: (offset) async {
          fetched.add(offset);
          return page(offset);
        },
        read: h.read,
        write: h.write,
      )..start();
      await pumpEventQueue();
      expect(h.value.items, [0, 1]);
      expect(h.value.hasMore, isTrue);

      await binding.loadMore();
      await binding.loadMore();
      expect(h.value.items, [0, 1, 2, 3, 4]);
      expect(h.value.hasMore, isFalse);
      await binding.loadMore();
      expect(fetched, [2, 4], reason: 'после конца списка запросов нет');
    });

    test('ошибка догрузки сохраняется и не стирает список', () async {
      final h = Holder(const PagedView<int>());
      final binding = PagedBinding<int>(
        CachedResource<Paginated<int>>(
          db: db,
          key: 'q',
          fetch: () async => page(0),
          decode: (j) =>
              Paginated.fromJson(j! as Map<String, Object?>, (e) => e! as int),
          encode: (p) => p.toJson((e) => e),
          now: () => now,
        ),
        fetchPage: (_) async => throw const NetworkException(),
        read: h.read,
        write: h.write,
      )..start();
      await pumpEventQueue();
      await binding.loadMore();
      expect(h.value.items, [0, 1]);
      expect(h.value.moreError, isA<NetworkException>());
      expect(h.value.loadingMore, isFalse);
    });
  });
}
