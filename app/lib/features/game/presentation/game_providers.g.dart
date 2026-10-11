// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gameRepository)
final gameRepositoryProvider = GameRepositoryProvider._();

final class GameRepositoryProvider
    extends $FunctionalProvider<GameRepository, GameRepository, GameRepository>
    with $Provider<GameRepository> {
  GameRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameRepositoryHash();

  @$internal
  @override
  $ProviderElement<GameRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameRepository create(Ref ref) {
    return gameRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameRepository>(value),
    );
  }
}

String _$gameRepositoryHash() => r'39693e0b5235df151b7206cab0b838340f97c503';

/// Данные экрана игры (кэш + обновление).

@ProviderFor(GameDetailsState)
final gameDetailsStateProvider = GameDetailsStateFamily._();

/// Данные экрана игры (кэш + обновление).
final class GameDetailsStateProvider
    extends $NotifierProvider<GameDetailsState, ResourceView<GameDetails>> {
  /// Данные экрана игры (кэш + обновление).
  GameDetailsStateProvider._({
    required GameDetailsStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'gameDetailsStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameDetailsStateHash();

  @override
  String toString() {
    return r'gameDetailsStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GameDetailsState create() => GameDetailsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResourceView<GameDetails> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResourceView<GameDetails>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameDetailsStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameDetailsStateHash() => r'd836401c09c37174b52744912b91aef16b413098';

/// Данные экрана игры (кэш + обновление).

final class GameDetailsStateFamily extends $Family
    with
        $ClassFamilyOverride<
          GameDetailsState,
          ResourceView<GameDetails>,
          ResourceView<GameDetails>,
          ResourceView<GameDetails>,
          int
        > {
  GameDetailsStateFamily._()
    : super(
        retry: null,
        name: r'gameDetailsStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Данные экрана игры (кэш + обновление).

  GameDetailsStateProvider call(int appId) =>
      GameDetailsStateProvider._(argument: appId, from: this);

  @override
  String toString() => r'gameDetailsStateProvider';
}

/// Данные экрана игры (кэш + обновление).

abstract class _$GameDetailsState extends $Notifier<ResourceView<GameDetails>> {
  late final _$args = ref.$arg as int;
  int get appId => _$args;

  ResourceView<GameDetails> build(int appId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<ResourceView<GameDetails>, ResourceView<GameDetails>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ResourceView<GameDetails>, ResourceView<GameDetails>>,
              ResourceView<GameDetails>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// История цены для графика и «лучшей цены».

@ProviderFor(PriceHistoryState)
final priceHistoryStateProvider = PriceHistoryStateFamily._();

/// История цены для графика и «лучшей цены».
final class PriceHistoryStateProvider
    extends
        $NotifierProvider<
          PriceHistoryState,
          ResourceView<List<PriceHistoryEntry>>
        > {
  /// История цены для графика и «лучшей цены».
  PriceHistoryStateProvider._({
    required PriceHistoryStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'priceHistoryStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$priceHistoryStateHash();

  @override
  String toString() {
    return r'priceHistoryStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PriceHistoryState create() => PriceHistoryState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResourceView<List<PriceHistoryEntry>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<ResourceView<List<PriceHistoryEntry>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PriceHistoryStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$priceHistoryStateHash() => r'51f7794c9519e51cb845ce8c3fd66f3e5d5bf413';

/// История цены для графика и «лучшей цены».

final class PriceHistoryStateFamily extends $Family
    with
        $ClassFamilyOverride<
          PriceHistoryState,
          ResourceView<List<PriceHistoryEntry>>,
          ResourceView<List<PriceHistoryEntry>>,
          ResourceView<List<PriceHistoryEntry>>,
          int
        > {
  PriceHistoryStateFamily._()
    : super(
        retry: null,
        name: r'priceHistoryStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// История цены для графика и «лучшей цены».

  PriceHistoryStateProvider call(int appId) =>
      PriceHistoryStateProvider._(argument: appId, from: this);

  @override
  String toString() => r'priceHistoryStateProvider';
}

/// История цены для графика и «лучшей цены».

abstract class _$PriceHistoryState
    extends $Notifier<ResourceView<List<PriceHistoryEntry>>> {
  late final _$args = ref.$arg as int;
  int get appId => _$args;

  ResourceView<List<PriceHistoryEntry>> build(int appId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              ResourceView<List<PriceHistoryEntry>>,
              ResourceView<List<PriceHistoryEntry>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ResourceView<List<PriceHistoryEntry>>,
                ResourceView<List<PriceHistoryEntry>>
              >,
              ResourceView<List<PriceHistoryEntry>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// История онлайна за выбранный период для графика.

@ProviderFor(PlayerHistoryState)
final playerHistoryStateProvider = PlayerHistoryStateFamily._();

/// История онлайна за выбранный период для графика.
final class PlayerHistoryStateProvider
    extends $NotifierProvider<PlayerHistoryState, ResourceView<PlayerHistory>> {
  /// История онлайна за выбранный период для графика.
  PlayerHistoryStateProvider._({
    required PlayerHistoryStateFamily super.from,
    required (int, HistoryPeriod) super.argument,
  }) : super(
         retry: null,
         name: r'playerHistoryStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerHistoryStateHash();

  @override
  String toString() {
    return r'playerHistoryStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PlayerHistoryState create() => PlayerHistoryState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResourceView<PlayerHistory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResourceView<PlayerHistory>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerHistoryStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerHistoryStateHash() =>
    r'46d6f276a52704e72f7d323c372864dd3bbe2d90';

/// История онлайна за выбранный период для графика.

final class PlayerHistoryStateFamily extends $Family
    with
        $ClassFamilyOverride<
          PlayerHistoryState,
          ResourceView<PlayerHistory>,
          ResourceView<PlayerHistory>,
          ResourceView<PlayerHistory>,
          (int, HistoryPeriod)
        > {
  PlayerHistoryStateFamily._()
    : super(
        retry: null,
        name: r'playerHistoryStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// История онлайна за выбранный период для графика.

  PlayerHistoryStateProvider call(int appId, HistoryPeriod period) =>
      PlayerHistoryStateProvider._(argument: (appId, period), from: this);

  @override
  String toString() => r'playerHistoryStateProvider';
}

/// История онлайна за выбранный период для графика.

abstract class _$PlayerHistoryState
    extends $Notifier<ResourceView<PlayerHistory>> {
  late final _$args = ref.$arg as (int, HistoryPeriod);
  int get appId => _$args.$1;
  HistoryPeriod get period => _$args.$2;

  ResourceView<PlayerHistory> build(int appId, HistoryPeriod period);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<ResourceView<PlayerHistory>, ResourceView<PlayerHistory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ResourceView<PlayerHistory>,
                ResourceView<PlayerHistory>
              >,
              ResourceView<PlayerHistory>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
