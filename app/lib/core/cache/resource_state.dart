import 'dart:async';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:flutter/widgets.dart';

import '../network/app_exception.dart';
import 'cached_resource.dart';

/// Автоповтор после ошибки сети: экраны, которые не смогли обновиться без
/// сети, повторяют запрос сами — по нарастающей паузе и сразу, когда
/// приложение возвращается на экран (часто сеть появляется именно тогда).
abstract final class NetworkRecovery {
  static final _waiting = <VoidCallback>{};
  static AppLifecycleListener? _listener;

  /// Паузы между повторами; последняя повторяется дальше.
  static const delays = [
    Duration(seconds: 3),
    Duration(seconds: 6),
    Duration(seconds: 12),
    Duration(seconds: 30),
    Duration(seconds: 60),
  ];

  /// Подписка на возврат приложения на экран. Вызывается при запуске.
  static void init() => _listener ??= AppLifecycleListener(onResume: retryNow);

  /// Повторить все ждущие запросы сейчас.
  static void retryNow() {
    for (final retry in [..._waiting]) {
      retry();
    }
  }

  static void _add(VoidCallback retry) => _waiting.add(retry);

  static void _remove(VoidCallback retry) => _waiting.remove(retry);
}

/// Состояние экрана с кэшем (правило 10): что показано, когда получено,
/// идёт ли обновление и чем закончилось последнее.
@immutable
class ResourceView<T> {
  const ResourceView({
    this.cached,
    this.cacheLoaded = false,
    this.refreshing = false,
    this.error,
  });

  final Cached<T>? cached;

  /// Кэш уже прочитан (до этого нельзя решить, показывать ли загрузку).
  final bool cacheLoaded;
  final bool refreshing;

  /// Ошибка последнего обновления. При наличии кэша экран показывает данные
  /// и сообщает, что они сохранённые.
  final Object? error;

  T? get data => cached?.data;

  /// Данных нет и они ещё грузятся — показываем индикатор.
  bool get isInitialLoading =>
      cached == null && (!cacheLoaded || refreshing || error == null);

  ResourceView<T> copyWith({
    Cached<T>? cached,
    bool? cacheLoaded,
    bool? refreshing,
    Object? error,
    bool clearError = false,
  }) => ResourceView(
    cached: cached ?? this.cached,
    cacheLoaded: cacheLoaded ?? this.cacheLoaded,
    refreshing: refreshing ?? this.refreshing,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Связка CachedResource ↔ состояние Notifier'а. Notifier хранит её у себя
/// и отдаёт ей чтение и запись своего state.
class ResourceBinding<T> {
  ResourceBinding(
    this.resource, {
    required this._read,
    required this._write,
    this.retryDelays = NetworkRecovery.delays,
  });

  final CachedResource<T> resource;
  final ResourceView<T> Function() _read;
  final void Function(ResourceView<T>) _write;

  /// Паузы автоповтора после ошибки сети.
  final List<Duration> retryDelays;
  StreamSubscription<Cached<T>?>? _sub;
  bool _disposed = false;
  Timer? _retryTimer;
  int _retryAttempt = 0;

  void _update(ResourceView<T> Function(ResourceView<T> s) change) {
    if (!_disposed) _write(change(_read()));
  }

  /// Подписка на кэш и обновление при открытии экрана.
  void start() {
    _sub = resource.watch().listen(
      (cached) => _update(
        (s) => ResourceView(
          cached: cached,
          cacheLoaded: true,
          refreshing: s.refreshing,
          error: s.error,
        ),
      ),
    );
    unawaited(_run(resource.refreshIfStale));
  }

  void dispose() {
    _disposed = true;
    _retryTimer?.cancel();
    NetworkRecovery._remove(_retryNow);
    unawaited(_sub?.cancel());
  }

  /// Перезагрузка без учёта свежести: после изменения данных пользователем.
  Future<void> reload() => _run(resource.refreshNow);

  /// Повтор после ошибки (кнопка «Повторить»): без ограничения в минуту.
  Future<void> retry() => _run(resource.refreshIfStale);

  /// Pull-to-refresh: не чаще раза в минуту.
  Future<RefreshResult> refreshByUser() async {
    var result = RefreshResult.refreshed;
    await _run(() async => result = await resource.refreshByUser());
    return result;
  }

  Future<void> _run(Future<void> Function() body) async {
    _update((s) => s.copyWith(refreshing: true, clearError: true));
    try {
      await body();
      _update((s) => s.copyWith(refreshing: false, clearError: true));
      _retryAttempt = 0;
      NetworkRecovery._remove(_retryNow);
    } on Object catch (e) {
      _update((s) => s.copyWith(refreshing: false, error: e));
      _scheduleRetry(e);
    }
  }

  // Отрывок метода (tear-off) равен сам себе, поэтому его можно
  // добавлять в множество ждущих и удалять оттуда.
  void _retryNow() {
    _retryTimer?.cancel();
    unawaited(_run(resource.refreshIfStale));
  }

  /// Без сети — повтор по нарастающей паузе. Ошибки сервера (404, 400…)
  /// сами не пройдут, их не повторяем.
  void _scheduleRetry(Object error) {
    if (_disposed || AppException.from(error) is! NetworkException) return;
    final delay = retryDelays[_retryAttempt.clamp(0, retryDelays.length - 1)];
    _retryAttempt++;
    _retryTimer?.cancel();
    _retryTimer = Timer(delay, _retryNow);
    NetworkRecovery._add(_retryNow);
  }
}

/// Постраничный список: первая страница кэшируется, следующие догружаются
/// из сети при прокрутке и живут в памяти до следующего обновления.
@immutable
class PagedView<T> {
  const PagedView({
    this.first = const ResourceView(),
    this.more = const [],
    this.loadingMore = false,
    this.moreError,
    this.reachedEnd = false,
  });

  final ResourceView<Paginated<T>> first;
  final List<T> more;
  final bool loadingMore;
  final Object? moreError;
  final bool reachedEnd;

  List<T> get items => [...?first.data?.items, ...more];

  bool get hasMore => !reachedEnd && (first.data?.hasMore ?? false);

  PagedView<T> copyWith({
    ResourceView<Paginated<T>>? first,
    List<T>? more,
    bool? loadingMore,
    Object? moreError,
    bool clearMoreError = false,
    bool? reachedEnd,
  }) => PagedView(
    first: first ?? this.first,
    more: more ?? this.more,
    loadingMore: loadingMore ?? this.loadingMore,
    moreError: clearMoreError ? null : (moreError ?? this.moreError),
    reachedEnd: reachedEnd ?? this.reachedEnd,
  );
}

class PagedBinding<T> {
  PagedBinding(
    CachedResource<Paginated<T>> firstPage, {
    required this.fetchPage,
    required this._read,
    required this._write,
  }) {
    _first = ResourceBinding(
      firstPage,
      read: () => _read().first,
      // Свежая первая страница сбрасывает догруженные: порядок мог измениться.
      write: (v) => _write(
        v.cached?.fetchedAt != _read().first.cached?.fetchedAt
            ? PagedView(first: v)
            : _read().copyWith(first: v),
      ),
    );
  }

  /// Загрузка страницы по смещению (без кэша).
  final Future<Paginated<T>> Function(int offset) fetchPage;
  final PagedView<T> Function() _read;
  final void Function(PagedView<T>) _write;
  late final ResourceBinding<Paginated<T>> _first;
  bool _disposed = false;

  void start() => _first.start();

  void dispose() {
    _disposed = true;
    _first.dispose();
  }

  Future<void> retry() => _first.retry();

  Future<RefreshResult> refreshByUser() => _first.refreshByUser();

  Future<void> loadMore() async {
    final s = _read();
    if (s.loadingMore || !s.hasMore || s.first.data == null) return;
    _write(s.copyWith(loadingMore: true, clearMoreError: true));
    try {
      final page = await fetchPage(s.items.length);
      if (_disposed) return;
      final now = _read();
      _write(
        now.copyWith(
          more: [...now.more, ...page.items],
          loadingMore: false,
          reachedEnd: !page.hasMore,
        ),
      );
    } on Object catch (e) {
      if (!_disposed) {
        _write(_read().copyWith(loadingMore: false, moreError: e));
      }
    }
  }
}
