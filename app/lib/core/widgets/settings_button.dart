import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../router/routes.dart';
import 'l10n.dart';

/// Кнопка настроек в шапке экранов вкладок.
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.l10n.settingsTitle,
    icon: const Icon(Icons.settings_outlined),
    onPressed: () => context.push(Routes.settings),
  );
}
