import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../theme/app_theme.dart';
import 'app_controls.dart';
import 'app_tab_bar.dart';

export 'app_controls.dart' show AppBarButton;

/// Высота плавающей панели вкладок (AppTabBar) вместе с отступами.
const kTabBarExtent = AppTabBar.extent;

/// Экран с шапкой: заголовок по центру и круглые кнопки по краям, все
/// на одной линии. Фон (AppBackground) лежит ниже, в каркасе приложения,
/// поэтому сам экран прозрачный.
///
/// Шапка не стеклянная: стеклянная перерисовывала шейдер на каждом кадре
/// прокрутки и анимации перехода. Контент под ней уходит в фон через
/// затемнение края, как в iOS.
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

  /// Отступ шапки от строки состояния и её высота.
  static const headerTop = 10.0;
  static const headerHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return GlassScaffold(
      backgroundColor: const Color(0x00000000),
      // Свои затемнения краёв дешевле встроенного размытия.
      edgeFade: false,
      body: Stack(
        children: [
          body,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(child: _ScrollEdge(topInset: topInset)),
          ),
          Positioned(
            top: topInset + headerTop,
            left: 16,
            right: 16,
            height: headerHeight,
            child: Row(
              children: [
                // Слоты одной ширины слева и справа: заголовок строго по центру.
                SizedBox(
                  width: AppBarButton.size,
                  child: leading ?? const SizedBox.shrink(),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.title(context)
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  width: AppBarButton.size,
                  child: actions.isEmpty
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Отступы для прокручиваемого контента: под шапкой и над панелью вкладок.
  static EdgeInsets contentPadding(
    BuildContext context, {
    bool insideTabs = true,
  }) {
    final padding = MediaQuery.paddingOf(context);
    return EdgeInsets.fromLTRB(
      16,
      padding.top + headerTop + headerHeight + 16,
      16,
      padding.bottom + (insideTabs ? kTabBarExtent : 0) + 24,
    );
  }
}

/// Край прокрутки: под шапкой контент плавно уходит в фон.
class _ScrollEdge extends StatelessWidget {
  const _ScrollEdge({required this.topInset});

  final double topInset;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.backgroundTop.resolveFrom(context);
    return SizedBox(
      height: topInset + GlassScreen.headerTop + GlassScreen.headerHeight + 14,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color, color.withAlpha(0xF2), color.withAlpha(0)],
            stops: const [0, 0.72, 1],
          ),
        ),
      ),
    );
  }
}
