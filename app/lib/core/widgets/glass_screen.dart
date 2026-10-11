import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../theme/app_theme.dart';
import 'app_tab_bar.dart';

/// Высота плавающей панели вкладок (AppTabBar) вместе с отступами.
const kTabBarExtent = AppTabBar.extent;

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
    body: Stack(
      children: [
        body,
        // Край прокрутки, как в iOS: контент под шапкой плавно уходит
        // в фон, а не просвечивает сквозь заголовок.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          // Отступ берётся снаружи: внутри GlassScaffold он уже обнулён.
          child: IgnorePointer(
            child: _ScrollEdge(topInset: MediaQuery.paddingOf(context).top),
          ),
        ),
      ],
    ),
  );

  /// Отступы для прокручиваемого контента: под шапкой и над панелью вкладок.
  static EdgeInsets contentPadding(
    BuildContext context, {
    bool insideTabs = true,
  }) {
    final padding = MediaQuery.paddingOf(context);
    return EdgeInsets.fromLTRB(
      16,
      padding.top + 44 + 24,
      16,
      padding.bottom + (insideTabs ? kTabBarExtent : 0) + 24,
    );
  }
}

class _ScrollEdge extends StatelessWidget {
  const _ScrollEdge({required this.topInset});

  final double topInset;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.backgroundTop.resolveFrom(context);
    return SizedBox(
      height: topInset + 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color, color.withAlpha(0xF2), color.withAlpha(0)],
            stops: const [0, 0.7, 1],
          ),
        ),
      ),
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
