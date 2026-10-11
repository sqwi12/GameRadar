import 'dart:async';
import 'dart:convert';

import '../config/app_config.dart';
import '../database/app_database.dart';

/// Данные из кэша вместе со временем получения (для «Обновлено N мин назад»).
typedef Cached<T> = ({T data, DateTime fetchedAt});

/// Результат обновления по запросу пользователя.
enum RefreshResult {
  /// Данные получены с сервера.
  refreshed,

  /// Пропущено: прошло меньше минуты с прошлого обновления (правило 10).
  throttled,
}

/// Ресурс «сначала кэш, потом сеть» (правило 10):
/// - [watch] сразу отдаёт сохранённые данные и все последующие обновления;
/// - [refreshIfStale] обновляет при открытии экрана, если данные устарели;
/// - [refreshByUser] — pull-to-refresh, не чаще раза в [manualInterval].
/// Ошибки сети пробрасываются вызывающему, кэш при этом не трогается.
class CachedResource<T> {
  CachedResource({
    required this._db,
    required this.key,
    required this.fetch,
    required this.decode,
    required this.encode,
    this.staleAfter = const Duration(minutes: 5),
    this.manualInterval = AppConfig.manualRefreshInterval,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final String key;

  /// Запрос к нашему API.
  final Future<T> Function() fetch;

  /// JSON (из shared toJson) → модель.
  final T Function(Object? json) decode;
  final Object? Function(T data) encode;

  /// Через сколько данные считаются устаревшими при открытии экрана.
  final Duration staleAfter;
  final Duration manualInterval;
  final DateTime Function() _now;

  Future<void>? _inFlight;

  /// Поток данных из кэша. Повреждённая запись (например, после изменения
  /// формата модели) считается отсутствующей.
  Stream<Cached<T>?> watch() => _db.watchCache(key).map((entry) {
    if (entry == null) return null;
    try {
      return (
        data: decode(jsonDecode(entry.payload)),
        fetchedAt: entry.fetchedAt,
      );
    } on Object {
      return null;
    }
  });

  /// Обновляет с сервера, если в кэше пусто или данные старше [staleAfter].
  Future<void> refreshIfStale() async {
    final entry = await _db.readCache(key);
    if (entry != null && _now().difference(entry.fetchedAt) < staleAfter) {
      return;
    }
    await _refresh();
  }

  /// Pull-to-refresh: не чаще раза в [manualInterval].
  Future<RefreshResult> refreshByUser() async {
    final entry = await _db.readCache(key);
    if (entry != null && _now().difference(entry.fetchedAt) < manualInterval) {
      return RefreshResult.throttled;
    }
    await _refresh();
    return RefreshResult.refreshed;
  }

  /// Принудительное обновление (например, после изменения данных на сервере).
  Future<void> refreshNow() => _refresh();

  /// Одновременные вызовы делят один запрос к серверу.
  Future<void> _refresh() => _inFlight ??= () async {
    try {
      final data = await fetch();
      await _db.putCache(key, jsonEncode(encode(data)), _now());
    } finally {
      _inFlight = null;
    }
  }();

  /// Кладёт уже полученные данные (например, ответ PUT) в кэш.
  Future<void> put(T data) =>
      _db.putCache(key, jsonEncode(encode(data)), _now());
}
