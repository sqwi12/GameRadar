import 'dart:async';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:flutter/foundation.dart';

import 'cached_resource.dart';

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
  ResourceBinding(this.resource, {required this._read, required this._write});

  final CachedResource<T> resource;
  final ResourceView<T> Function() _read;
  final void Function(ResourceView<T>) _write;
  StreamSubscription<Cached<T>?>? _sub;
  bool _disposed = false;

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
    } on Object catch (e) {
      _update((s) => s.copyWith(refreshing: false, error: e));
    }
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
