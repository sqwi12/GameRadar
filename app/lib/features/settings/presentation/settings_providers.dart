import 'dart:async';
import 'dart:ui';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
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
  ThemePreference build() {
    final saved = ref.read(
      initialPreferencesProvider,
    )[PreferenceKeys.themeMode];
    return ThemePreference.values.asNameMap()[saved] ?? ThemePreference.system;
  }

  Future<void> set(ThemePreference mode) async {
    state = mode;
    await ref
        .read(preferencesStoreProvider)
        .write(
          PreferenceKeys.themeMode,
          mode == ThemePreference.system ? null : mode.name,
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

/// Без автоповтора: ошибку связи пользователь видит сразу и повторяет сам.
/// (По умолчанию Riverpod 3 повторяет упавший запрос до 10 раз, и всё это
/// время экран показывал бы «Подключение…».)
Duration? noRetry(int retryCount, Object error) => null;

/// Профиль с сервера: заодно показывает, что вход и связь с API работают.
@Riverpod(retry: noRetry)
Future<UserProfile> currentProfile(Ref ref) =>
    ref.watch(settingsRepositoryProvider).fetchProfile();
