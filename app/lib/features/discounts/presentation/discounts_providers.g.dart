// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discounts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(discountsRepository)
final discountsRepositoryProvider = DiscountsRepositoryProvider._();

final class DiscountsRepositoryProvider
    extends
        $FunctionalProvider<
          DiscountsRepository,
          DiscountsRepository,
          DiscountsRepository
        >
    with $Provider<DiscountsRepository> {
  DiscountsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discountsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discountsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiscountsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiscountsRepository create(Ref ref) {
    return discountsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscountsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscountsRepository>(value),
    );
  }
}

String _$discountsRepositoryHash() =>
    r'e236a4a46ebd55ff3017aeeb478066e1bc22674c';

@ProviderFor(DiscountsFilter)
final discountsFilterProvider = DiscountsFilterProvider._();

final class DiscountsFilterProvider
    extends $NotifierProvider<DiscountsFilter, DiscountsQuery> {
  DiscountsFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discountsFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discountsFilterHash();

  @$internal
  @override
  DiscountsFilter create() => DiscountsFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscountsQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscountsQuery>(value),
    );
  }
}

String _$discountsFilterHash() => r'dd948f002750d546840053b9fb2495164c475fb2';

abstract class _$DiscountsFilter extends $Notifier<DiscountsQuery> {
  DiscountsQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DiscountsQuery, DiscountsQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscountsQuery, DiscountsQuery>,
              DiscountsQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DiscountsList)
final discountsListProvider = DiscountsListProvider._();

final class DiscountsListProvider
    extends $NotifierProvider<DiscountsList, PagedView<GameSummary>> {
  DiscountsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discountsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discountsListHash();

  @$internal
  @override
  DiscountsList create() => DiscountsList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PagedView<GameSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PagedView<GameSummary>>(value),
    );
  }
}

String _$discountsListHash() => r'1c5115f640eac8d6677e48ffc77602bd00800331';

abstract class _$DiscountsList extends $Notifier<PagedView<GameSummary>> {
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
