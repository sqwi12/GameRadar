import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/config/app_config.dart';
import '../../../core/widgets/l10n.dart';
import 'settings_providers.dart';

/// Настройки: тема, язык, регион, аккаунт и «О приложении».
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleSettingProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _SectionHeader(l10n.settingsAppearance),
          _ChoiceTile(
            icon: Icons.brightness_6_outlined,
            title: l10n.settingsTheme,
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) =>
                  ref.read(appThemeModeProvider.notifier).set(s.single),
            ),
          ),
          _ChoiceTile(
            icon: Icons.translate_rounded,
            title: l10n.settingsLanguage,
            child: SegmentedButton<AppLocale?>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: null, label: Text(l10n.languageSystem)),
                ButtonSegment(
                  value: AppLocale.ru,
                  label: Text(l10n.languageRussian),
                ),
                ButtonSegment(
                  value: AppLocale.en,
                  label: Text(l10n.languageEnglish),
                ),
              ],
              selected: {locale},
              onSelectionChanged: (s) =>
                  ref.read(appLocaleSettingProvider.notifier).set(s.single),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: Text(l10n.settingsRegion),
            subtitle: Text(l10n.regionKazakhstan),
          ),
          _SectionHeader(l10n.settingsAccount),
          const _AccountTile(),
          _SectionHeader(l10n.settingsAbout),
          ListTile(
            leading: const Icon(Icons.radar),
            title: Text(l10n.appTitle),
            subtitle: Text(l10n.aboutVersion(AppConfig.appVersion)),
          ),
          ListTile(
            leading: const Icon(Icons.insights_outlined),
            subtitle: Text(l10n.aboutDataSource),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            subtitle: Text(l10n.aboutDisclaimer),
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
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: const Icon(Icons.person_outline),
      title: Text(l10n.accountAnonymous),
      subtitle: switch (profile) {
        AsyncData() => Text(l10n.accountConnected),
        AsyncError(:final error) => Text(
          describeError(l10n, error),
          style: TextStyle(color: scheme.error),
        ),
        _ => Text(l10n.accountConnecting),
      },
      trailing: switch (profile) {
        AsyncData() => Icon(Icons.check_circle, color: scheme.primary),
        AsyncError() => IconButton(
          tooltip: l10n.retry,
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.invalidate(currentProfileProvider),
        ),
        _ => const SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

/// Настройка с подписью и переключателем под ней (на всю ширину).
class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: child),
      ],
    ),
  );
}
