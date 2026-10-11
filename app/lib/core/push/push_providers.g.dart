// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pushPlatform)
final pushPlatformProvider = PushPlatformProvider._();

final class PushPlatformProvider
    extends $FunctionalProvider<PushPlatform, PushPlatform, PushPlatform>
    with $Provider<PushPlatform> {
  PushPlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushPlatformProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushPlatformHash();

  @$internal
  @override
  $ProviderElement<PushPlatform> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushPlatform create(Ref ref) {
    return pushPlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushPlatform value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushPlatform>(value),
    );
  }
}

String _$pushPlatformHash() => r'b132b8e57724d6da3015a38b9ee2210015e928f1';

/// Push-уведомления. Запускается в main(); по нажатию на уведомление
/// открывается экран игры.

@ProviderFor(pushService)
final pushServiceProvider = PushServiceProvider._();

/// Push-уведомления. Запускается в main(); по нажатию на уведомление
/// открывается экран игры.

final class PushServiceProvider
    extends $FunctionalProvider<PushService, PushService, PushService>
    with $Provider<PushService> {
  /// Push-уведомления. Запускается в main(); по нажатию на уведомление
  /// открывается экран игры.
  PushServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushServiceHash();

  @$internal
  @override
  $ProviderElement<PushService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushService create(Ref ref) {
    return pushService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushService>(value),
    );
  }
}

String _$pushServiceHash() => r'face7ab740a2e27da2fd5af8df08ef95e61bd599';
