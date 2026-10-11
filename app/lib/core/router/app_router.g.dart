// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Навигация: четыре вкладки с собственным стеком у каждой
/// (StatefulShellRoute сохраняет прокрутку и состояние при переключении),
/// а настройки и экран игры открываются поверх вкладок.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Навигация: четыре вкладки с собственным стеком у каждой
/// (StatefulShellRoute сохраняет прокрутку и состояние при переключении),
/// а настройки и экран игры открываются поверх вкладок.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Навигация: четыре вкладки с собственным стеком у каждой
  /// (StatefulShellRoute сохраняет прокрутку и состояние при переключении),
  /// а настройки и экран игры открываются поверх вкладок.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'176e9b43f6de640a3d71fe9eceeaac3ef3130794';
