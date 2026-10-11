import 'package:flutter/cupertino.dart';

import '../../../core/widgets/glass_screen.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/settings_button.dart';
import '../../../core/widgets/state_views.dart';

/// Заглушка: экран появится на этапе 6.
class TopScreen extends StatelessWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context) => GlassScreen(
    title: context.l10n.topTitle,
    actions: const [SettingsButton()],
    body: MessageView(
      icon: CupertinoIcons.chart_bar_alt_fill,
      message: context.l10n.comingSoon,
    ),
  );
}
