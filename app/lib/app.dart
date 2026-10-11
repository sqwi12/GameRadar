import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/settings_providers.dart';
import 'l10n/gen/app_localizations.dart';

class GameRadarApp extends ConsumerWidget {
  const GameRadarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleSettingProvider);
    return CupertinoApp.router(
      title: 'GameRadar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.of(ref.watch(appThemeModeProvider)),
      // null — язык системы (с откатом на русский, если язык не поддерживается).
      locale: locale == null ? null : Locale(locale.name),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
