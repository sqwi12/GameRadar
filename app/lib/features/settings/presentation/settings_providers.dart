import 'dart:async';
import 'dart:ui';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../data/settings_repository.dart';

part 'settings_providers.g.dart';

/// Ключи локальных настроек в таблице preferences.
abstract final class PreferenceKeys {
  static const themeMode = 'theme_mode';
  static const locale = 'locale';
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepository(ref.watch(apiClientProvider));

/// Тема: системная, светлая или тёмная. Хранится на устройстве.
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() {
    final saved = ref.read(
      initialPreferencesProvider,
    )[PreferenceKeys.themeMode];
    return ThemeMode.values.asNameMap()[saved] ?? ThemeMode.system;
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref
        .read(preferencesStoreProvider)
        .write(
          PreferenceKeys.themeMode,
          mode == ThemeMode.system ? null : mode.name,
        );
  }
}

/// Язык интерфейса: null — как в системе.
@Riverpod(keepAlive: true)
class AppLocaleSetting extends _$AppLocaleSetting {
  @override
  AppLocale? build() {
    final saved = ref.read(initialPreferencesProvider)[PreferenceKeys.locale];
    return AppLocale.values.asNameMap()[saved];
  }

  /// Меняет язык приложения и отправляет его на сервер, чтобы
  /// push-уведомления приходили на том же языке.
  Future<void> set(AppLocale? locale) async {
    state = locale;
    await ref
        .read(preferencesStoreProvider)
        .write(PreferenceKeys.locale, locale?.name);
    unawaited(_syncToServer(locale ?? deviceAppLocale()));
  }

  Future<void> _syncToServer(AppLocale locale) async {
    try {
      final repository = ref.read(settingsRepositoryProvider);
      final profile = await repository.fetchProfile();
      if (profile.settings.locale == locale) return;
      await repository.saveSettings(profile.settings.copyWith(locale: locale));
      ref.invalidate(currentProfileProvider);
    } on Object {
      // Без сети язык на сервере обновится при следующей смене настроек:
      // локально язык уже сменён, это главное.
    }
  }
}

/// Язык устройства, приведённый к поддерживаемым.
AppLocale deviceAppLocale() =>
    PlatformDispatcher.instance.locale.languageCode == 'ru'
    ? AppLocale.ru
    : AppLocale.en;

/// Профиль с сервера: заодно показывает, что вход и связь с API работают.
@riverpod
Future<UserProfile> currentProfile(Ref ref) =>
    ref.watch(settingsRepositoryProvider).fetchProfile();
