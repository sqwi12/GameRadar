import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Кэш ответов API: экран сначала показывает сохранённое, затем обновляет
/// (правило 10). Данные хранятся как JSON моделей из пакета shared.
class CacheEntries extends Table {
  /// Ключ ресурса, например `top:current:kz` или `game:730:kz`.
  TextColumn get key => text()();

  /// JSON модели (toJson() из shared).
  TextColumn get payload => text()();

  /// Когда данные получены с сервера.
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Локальные настройки устройства: тема, язык.
class Preferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(tables: [CacheEntries, Preferences])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'gameradar'));

  @override
  int get schemaVersion => 1;

  /// Сохраняет ответ в кэш (заменяя прежний).
  Future<void> putCache(String key, String payload, DateTime fetchedAt) =>
      into(cacheEntries).insertOnConflictUpdate(
        CacheEntriesCompanion.insert(
          key: key,
          payload: payload,
          fetchedAt: fetchedAt,
        ),
      );

  Stream<CacheEntry?> watchCache(String key) => (select(
    cacheEntries,
  )..where((t) => t.key.equals(key))).watchSingleOrNull();

  Future<CacheEntry?> readCache(String key) =>
      (select(cacheEntries)..where((t) => t.key.equals(key))).getSingleOrNull();

  Future<void> clearCache() => delete(cacheEntries).go();

  Future<Map<String, String>> readPreferences() async => {
    for (final row in await select(preferences).get()) row.key: row.value,
  };

  Future<void> writePreference(String key, String? value) => value == null
      ? (delete(preferences)..where((t) => t.key.equals(key))).go()
      : into(preferences).insertOnConflictUpdate(
          PreferencesCompanion.insert(key: key, value: value),
        );
}
