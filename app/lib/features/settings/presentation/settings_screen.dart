import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_screen.dart';
import '../../../core/widgets/l10n.dart';
import 'settings_providers.dart';

/// Настройки: тема, язык, регион, аккаунт и «О приложении».
///
/// По правилам Liquid Glass интерактивное стекло (переключатели) лежит
/// прямо на фоне, а не внутри стеклянных групп.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleSettingProvider);

    return GlassScreen(
      title: l10n.settingsTitle,
      insideTabs: false,
      leading: GlassBarButton(
        icon: CupertinoIcons.chevron_back,
        semanticLabel: l10n.back,
        onPressed: context.pop,
      ),
      body: ListView(
        padding: GlassScreen.contentPadding(context, insideTabs: false),
        children: [
          _Header(
            l10n.settingsTheme,
            icon: CupertinoIcons.circle_lefthalf_fill,
          ),
          _Choice<ThemePreference>(
            values: ThemePreference.values,
            selected: theme,
            label: (v) => switch (v) {
              ThemePreference.system => l10n.themeSystem,
              ThemePreference.light => l10n.themeLight,
              ThemePreference.dark => l10n.themeDark,
            },
            onSelected: ref.read(appThemeModeProvider.notifier).set,
          ),
          _Header(l10n.settingsLanguage, icon: CupertinoIcons.globe),
          _Choice<AppLocale?>(
            values: const [null, AppLocale.ru, AppLocale.en],
            selected: locale,
            label: (v) => switch (v) {
              null => l10n.languageSystem,
              AppLocale.ru => l10n.languageRussian,
              AppLocale.en => l10n.languageEnglish,
            },
            onSelected: ref.read(appLocaleSettingProvider.notifier).set,
          ),
          const SizedBox(height: 28),
          GlassGroupedSection(
            header: Text(l10n.settingsAccount.toUpperCase()),
            children: [
              GlassListTile(
                leading: const Icon(CupertinoIcons.money_dollar_circle),
                title: Text(l10n.settingsRegion),
                subtitle: Text(l10n.regionKazakhstan),
              ),
              const _AccountTile(),
            ],
          ),
          const SizedBox(height: 20),
          GlassGroupedSection(
            header: Text(l10n.settingsAbout.toUpperCase()),
            footer: Text(l10n.aboutDisclaimer),
            children: [
              GlassListTile(
                leading: const Icon(CupertinoIcons.scope),
                title: Text(l10n.appTitle),
                subtitle: Text(l10n.aboutVersion(AppConfig.appVersion)),
              ),
              GlassListTile(
                leading: const Icon(CupertinoIcons.chart_bar_square),
                title: Text(l10n.aboutDataSourceTitle),
                subtitle: Text(l10n.aboutDataSource),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Статус анонимного аккаунта: заодно проверка связи с сервером.
class _AccountTile extends ConsumerWidget {
  const _AccountTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(currentProfileProvider);
    const error = CupertinoColors.systemRed;
    return GlassListTile(
      leading: const Icon(CupertinoIcons.person_crop_circle),
      title: Text(l10n.accountAnonymous),
      subtitle: switch (profile) {
        AsyncData() => Text(l10n.accountConnected),
        AsyncError(:final error) => Text(describeError(l10n, error)),
        _ => Text(l10n.accountConnecting),
      },
      onTap: profile is AsyncError
          ? () => ref.invalidate(currentProfileProvider)
          : null,
      trailing: switch (profile) {
        AsyncData() => Icon(
          CupertinoIcons.checkmark_seal_fill,
          color: AppColors.discount.resolveFrom(context),
        ),
        AsyncError() => Semantics(
          label: l10n.retry,
          button: true,
          child: Icon(
            CupertinoIcons.arrow_clockwise,
            color: error.resolveFrom(context),
          ),
        ),
        _ => const CupertinoActivityIndicator(),
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title, {required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppColors.accent.resolveFrom(context)),
        const SizedBox(width: 8),
        Text(title.toUpperCase(), style: AppText.sectionHeader(context)),
      ],
    ),
  );
}

/// Выбор из нескольких вариантов: стеклянный сегментированный переключатель.
class _Choice<T> extends StatelessWidget {
  const _Choice({
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) label;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => GlassSegmentedControl(
    segments: [for (final v in values) GlassSegment(label: label(v))],
    selectedIndex: values.indexOf(selected),
    onSegmentSelected: (i) => onSelected(values[i]),
    useOwnLayer: true,
  );
}
