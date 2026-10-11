import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../router/routes.dart';
import 'glass_screen.dart';
import 'l10n.dart';

/// Кнопка настроек в шапке экранов вкладок.
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) => AppBarButton(
    icon: CupertinoIcons.gear_alt,
    semanticLabel: context.l10n.settingsTitle,
    onPressed: () => context.push(Routes.settings),
  );
}
