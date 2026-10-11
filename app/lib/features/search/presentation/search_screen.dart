import 'package:flutter/cupertino.dart';

import '../../../core/widgets/glass_screen.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/settings_button.dart';
import '../../../core/widgets/state_views.dart';

/// Заглушка: экран появится на этапе 6.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => GlassScreen(
    title: context.l10n.searchTitle,
    actions: const [SettingsButton()],
    body: MessageView(
      icon: CupertinoIcons.search,
      message: context.l10n.comingSoon,
    ),
  );
}
