import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/glass_screen.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/state_views.dart';

/// Заглушка: экран игры появится на этапе 6.
class GameScreen extends StatelessWidget {
  const GameScreen({required this.appId, super.key});

  final int appId;

  @override
  Widget build(BuildContext context) => GlassScreen(
    title: context.l10n.gameTitle,
    insideTabs: false,
    leading: GlassBarButton(
      icon: CupertinoIcons.chevron_back,
      semanticLabel: context.l10n.back,
      onPressed: context.pop,
    ),
    body: MessageView(
      icon: CupertinoIcons.game_controller_solid,
      message: context.l10n.comingSoon,
    ),
  );
}
