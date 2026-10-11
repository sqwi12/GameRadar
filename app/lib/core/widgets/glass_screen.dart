import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../theme/app_theme.dart';

/// Высота плавающей панели вкладок (GlassTabBar.bottom) вместе с отступами.
const kTabBarExtent = 64.0 + 20.0;

/// Экран со стеклянной шапкой. Фон (AppBackground) лежит ниже, в каркасе
/// приложения, поэтому сам экран прозрачный: стекло шапки и панели вкладок
/// преломляет один общий фон.
class GlassScreen extends StatelessWidget {
  const GlassScreen({
    required this.title,
    required this.body,
    this.actions = const [],
    this.leading,
    this.insideTabs = true,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final Widget? leading;

  /// Экран вкладки: снизу плавает панель вкладок, контенту нужен отступ.
  final bool insideTabs;

  @override
  Widget build(BuildContext context) => GlassScaffold(
    backgroundColor: const Color(0x00000000),
    appBar: GlassAppBar(
      leading: leading,
      title: Text(title, style: AppText.title(context)),
      actions: actions,
    ),
    body: body,
  );

  /// Отступы для прокручиваемого контента: под шапкой и над панелью вкладок.
  static EdgeInsets contentPadding(
    BuildContext context, {
    bool insideTabs = true,
  }) {
    final padding = MediaQuery.paddingOf(context);
    return EdgeInsets.fromLTRB(
      16,
      padding.top + 44 + 12,
      16,
      padding.bottom + (insideTabs ? kTabBarExtent : 0) + 24,
    );
  }
}

/// Круглая стеклянная кнопка в шапке.
class GlassBarButton extends StatelessWidget {
  const GlassBarButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => GlassIconButton(
    icon: Icon(
      icon,
      size: 20,
      color: AppColors.textPrimary.resolveFrom(context),
    ),
    onPressed: onPressed,
    size: 40,
    semanticLabel: semanticLabel,
  );
}
