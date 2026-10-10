import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/settings_button.dart';
import '../../../core/widgets/state_views.dart';

/// Заглушка: экран появится на этапе 6.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.l10n.searchTitle),
      actions: const [SettingsButton()],
    ),
    body: MessageView(icon: Icons.search, message: context.l10n.comingSoon),
  );
}
