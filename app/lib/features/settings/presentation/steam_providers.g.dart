// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steam_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(steamLinkRepository)
final steamLinkRepositoryProvider = SteamLinkRepositoryProvider._();

final class SteamLinkRepositoryProvider
    extends
        $FunctionalProvider<
          SteamLinkRepository,
          SteamLinkRepository,
          SteamLinkRepository
        >
    with $Provider<SteamLinkRepository> {
  SteamLinkRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'steamLinkRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$steamLinkRepositoryHash();

  @$internal
  @override
  $ProviderElement<SteamLinkRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SteamLinkRepository create(Ref ref) {
    return steamLinkRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SteamLinkRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SteamLinkRepository>(value),
    );
  }
}

String _$steamLinkRepositoryHash() =>
    r'b159e0045a5048fc8bbae144659d3e2e15a6caa2';

/// Привязанный профиль Steam (null — не привязан).
///
/// Пока импорт в очереди (pending), статус опрашивается раз в 5 секунд;
/// когда worker закончит, список отслеживания перезагружается. Провайдер
/// живёт всё время работы приложения, чтобы импорт, начатый в настройках,
/// обновил список, даже если пользователь уже ушёл с экрана.

@ProviderFor(SteamConnection)
final steamConnectionProvider = SteamConnectionProvider._();

/// Привязанный профиль Steam (null — не привязан).
///
/// Пока импорт в очереди (pending), статус опрашивается раз в 5 секунд;
/// когда worker закончит, список отслеживания перезагружается. Провайдер
/// живёт всё время работы приложения, чтобы импорт, начатый в настройках,
/// обновил список, даже если пользователь уже ушёл с экрана.
final class SteamConnectionProvider
    extends $AsyncNotifierProvider<SteamConnection, SteamLink?> {
  /// Привязанный профиль Steam (null — не привязан).
  ///
  /// Пока импорт в очереди (pending), статус опрашивается раз в 5 секунд;
  /// когда worker закончит, список отслеживания перезагружается. Провайдер
  /// живёт всё время работы приложения, чтобы импорт, начатый в настройках,
  /// обновил список, даже если пользователь уже ушёл с экрана.
  SteamConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'steamConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$steamConnectionHash();

  @$internal
  @override
  SteamConnection create() => SteamConnection();
}

String _$steamConnectionHash() => r'568ec9e73193ec10051b60c2106457e42886a9bf';

/// Привязанный профиль Steam (null — не привязан).
///
/// Пока импорт в очереди (pending), статус опрашивается раз в 5 секунд;
/// когда worker закончит, список отслеживания перезагружается. Провайдер
/// живёт всё время работы приложения, чтобы импорт, начатый в настройках,
/// обновил список, даже если пользователь уже ушёл с экрана.

abstract class _$SteamConnection extends $AsyncNotifier<SteamLink?> {
  FutureOr<SteamLink?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SteamLink?>, SteamLink?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SteamLink?>, SteamLink?>,
              AsyncValue<SteamLink?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
