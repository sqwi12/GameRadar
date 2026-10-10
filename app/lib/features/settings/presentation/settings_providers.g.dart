// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'8a5ab881258e3ac4a9e560490ce36b8a2e262996';

/// Тема: системная, светлая или тёмная. Хранится на устройстве.

@ProviderFor(AppThemeMode)
final appThemeModeProvider = AppThemeModeProvider._();

/// Тема: системная, светлая или тёмная. Хранится на устройстве.
final class AppThemeModeProvider
    extends $NotifierProvider<AppThemeMode, ThemeMode> {
  /// Тема: системная, светлая или тёмная. Хранится на устройстве.
  AppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeHash();

  @$internal
  @override
  AppThemeMode create() => AppThemeMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$appThemeModeHash() => r'a330e2618032dd76e9358326d2267e0d9be02a9a';

/// Тема: системная, светлая или тёмная. Хранится на устройстве.

abstract class _$AppThemeMode extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Язык интерфейса: null — как в системе.

@ProviderFor(AppLocaleSetting)
final appLocaleSettingProvider = AppLocaleSettingProvider._();

/// Язык интерфейса: null — как в системе.
final class AppLocaleSettingProvider
    extends $NotifierProvider<AppLocaleSetting, AppLocale?> {
  /// Язык интерфейса: null — как в системе.
  AppLocaleSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleSettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleSettingHash();

  @$internal
  @override
  AppLocaleSetting create() => AppLocaleSetting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLocale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLocale?>(value),
    );
  }
}

String _$appLocaleSettingHash() => r'86f0d8b34029831a1d5c29955f77dc1f0301ae81';

/// Язык интерфейса: null — как в системе.

abstract class _$AppLocaleSetting extends $Notifier<AppLocale?> {
  AppLocale? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppLocale?, AppLocale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLocale?, AppLocale?>,
              AppLocale?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Профиль с сервера: заодно показывает, что вход и связь с API работают.

@ProviderFor(currentProfile)
final currentProfileProvider = CurrentProfileProvider._();

/// Профиль с сервера: заодно показывает, что вход и связь с API работают.

final class CurrentProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfile>,
          UserProfile,
          FutureOr<UserProfile>
        >
    with $FutureModifier<UserProfile>, $FutureProvider<UserProfile> {
  /// Профиль с сервера: заодно показывает, что вход и связь с API работают.
  CurrentProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProfileHash();

  @$internal
  @override
  $FutureProviderElement<UserProfile> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserProfile> create(Ref ref) {
    return currentProfile(ref);
  }
}

String _$currentProfileHash() => r'7e0f797d755fe139baf7074d2e746336cc6753b2';
