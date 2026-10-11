// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(watchlistRepository)
final watchlistRepositoryProvider = WatchlistRepositoryProvider._();

final class WatchlistRepositoryProvider
    extends
        $FunctionalProvider<
          WatchlistRepository,
          WatchlistRepository,
          WatchlistRepository
        >
    with $Provider<WatchlistRepository> {
  WatchlistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchlistRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchlistRepositoryHash();

  @$internal
  @override
  $ProviderElement<WatchlistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchlistRepository create(Ref ref) {
    return watchlistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchlistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchlistRepository>(value),
    );
  }
}

String _$watchlistRepositoryHash() =>
    r'28d1547781ee5b45b59c00c16eca50eacbf8b039';

/// Список отслеживания. Живёт всё время работы приложения: по нему экран
/// игры показывает «Отслеживается».

@ProviderFor(Watchlist)
final watchlistProvider = WatchlistProvider._();

/// Список отслеживания. Живёт всё время работы приложения: по нему экран
/// игры показывает «Отслеживается».
final class WatchlistProvider
    extends $NotifierProvider<Watchlist, ResourceView<List<WatchlistItem>>> {
  /// Список отслеживания. Живёт всё время работы приложения: по нему экран
  /// игры показывает «Отслеживается».
  WatchlistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchlistProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchlistHash();

  @$internal
  @override
  Watchlist create() => Watchlist();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResourceView<List<WatchlistItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResourceView<List<WatchlistItem>>>(
        value,
      ),
    );
  }
}

String _$watchlistHash() => r'09d860832e4d24098922bfcb81da60cbaeac519b';

/// Список отслеживания. Живёт всё время работы приложения: по нему экран
/// игры показывает «Отслеживается».

abstract class _$Watchlist
    extends $Notifier<ResourceView<List<WatchlistItem>>> {
  ResourceView<List<WatchlistItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              ResourceView<List<WatchlistItem>>,
              ResourceView<List<WatchlistItem>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ResourceView<List<WatchlistItem>>,
                ResourceView<List<WatchlistItem>>
              >,
              ResourceView<List<WatchlistItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Запись списка для игры или null, если игра не отслеживается.

@ProviderFor(watchItem)
final watchItemProvider = WatchItemFamily._();

/// Запись списка для игры или null, если игра не отслеживается.

final class WatchItemProvider
    extends $FunctionalProvider<WatchlistItem?, WatchlistItem?, WatchlistItem?>
    with $Provider<WatchlistItem?> {
  /// Запись списка для игры или null, если игра не отслеживается.
  WatchItemProvider._({
    required WatchItemFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'watchItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchItemHash();

  @override
  String toString() {
    return r'watchItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<WatchlistItem?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WatchlistItem? create(Ref ref) {
    final argument = this.argument as int;
    return watchItem(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchlistItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchlistItem?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WatchItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchItemHash() => r'2caf9d55f5c3423c14a77396d64d91f58f3d1bd5';

/// Запись списка для игры или null, если игра не отслеживается.

final class WatchItemFamily extends $Family
    with $FunctionalFamilyOverride<WatchlistItem?, int> {
  WatchItemFamily._()
    : super(
        retry: null,
        name: r'watchItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Запись списка для игры или null, если игра не отслеживается.

  WatchItemProvider call(int appId) =>
      WatchItemProvider._(argument: appId, from: this);

  @override
  String toString() => r'watchItemProvider';
}
