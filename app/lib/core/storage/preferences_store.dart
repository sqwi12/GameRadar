import '../database/app_database.dart';

/// Запись локальных настроек (тема, язык). Читаются они один раз при запуске
/// (initialPreferencesProvider), а меняются через этот интерфейс.
abstract interface class PreferencesStore {
  /// null удаляет настройку (возврат к значению по умолчанию).
  Future<void> write(String key, String? value);
}

/// Настройки в таблице preferences локальной БД.
final class DriftPreferencesStore implements PreferencesStore {
  const DriftPreferencesStore(this._db);

  final AppDatabase _db;

  @override
  Future<void> write(String key, String? value) =>
      _db.writePreference(key, value);
}

/// Настройки в памяти: для виджет-тестов.
final class MemoryPreferencesStore implements PreferencesStore {
  final values = <String, String>{};

  @override
  Future<void> write(String key, String? value) async =>
      value == null ? values.remove(key) : values[key] = value;
}
