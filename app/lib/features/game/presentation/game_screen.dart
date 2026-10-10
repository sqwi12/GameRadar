import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/state_views.dart';

/// Заглушка: экран игры появится на этапе 6.
class GameScreen extends StatelessWidget {
  const GameScreen({required this.appId, super.key});

  final int appId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.gameTitle)),
    body: MessageView(
      icon: Icons.sports_esports_outlined,
      message: context.l10n.comingSoon,
    ),
  );
}
