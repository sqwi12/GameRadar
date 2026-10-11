// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(topRepository)
final topRepositoryProvider = TopRepositoryProvider._();

final class TopRepositoryProvider
    extends $FunctionalProvider<TopRepository, TopRepository, TopRepository>
    with $Provider<TopRepository> {
  TopRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topRepositoryHash();

  @$internal
  @override
  $ProviderElement<TopRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TopRepository create(Ref ref) {
    return topRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TopRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TopRepository>(value),
    );
  }
}

String _$topRepositoryHash() => r'70fa21a8b5a74255c134c58707bf850a5477d1cc';

/// Фильтры топа: сортировка и «только со скидкой».

@ProviderFor(TopFilter)
final topFilterProvider = TopFilterProvider._();

/// Фильтры топа: сортировка и «только со скидкой».
final class TopFilterProvider extends $NotifierProvider<TopFilter, TopQuery> {
  /// Фильтры топа: сортировка и «только со скидкой».
  TopFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topFilterHash();

  @$internal
  @override
  TopFilter create() => TopFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TopQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TopQuery>(value),
    );
  }
}

String _$topFilterHash() => r'd3fe4429316ec4dd46ded2d12e8f12343c967b78';

/// Фильтры топа: сортировка и «только со скидкой».

abstract class _$TopFilter extends $Notifier<TopQuery> {
  TopQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TopQuery, TopQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TopQuery, TopQuery>,
              TopQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Список топа: первая страница из кэша, следующие — при прокрутке.

@ProviderFor(TopList)
final topListProvider = TopListProvider._();

/// Список топа: первая страница из кэша, следующие — при прокрутке.
final class TopListProvider
    extends $NotifierProvider<TopList, PagedView<GameSummary>> {
  /// Список топа: первая страница из кэша, следующие — при прокрутке.
  TopListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topListHash();

  @$internal
  @override
  TopList create() => TopList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PagedView<GameSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PagedView<GameSummary>>(value),
    );
  }
}

String _$topListHash() => r'152d7cce797d692942f726bca65ed4ef7a792643';

/// Список топа: первая страница из кэша, следующие — при прокрутке.

abstract class _$TopList extends $Notifier<PagedView<GameSummary>> {
  PagedView<GameSummary> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<PagedView<GameSummary>, PagedView<GameSummary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PagedView<GameSummary>, PagedView<GameSummary>>,
              PagedView<GameSummary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
