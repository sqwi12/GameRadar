import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Вкладка нижней панели.
class AppTab {
  const AppTab({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Нижняя панель вкладок в стиле Telegram для Android (MainTabsLayout):
/// «таблетка» по центру, выбранная вкладка — акцентным цветом
/// на мягкой подложке, которая перетекает между вкладками.
///
/// Долгое нажатие и движение пальцем перетаскивают выделение, как в
/// Telegram; отпускание выбирает вкладку под пальцем.
///
/// Все цвета берутся из темы приложения, поэтому панель сразу
/// перекрашивается при смене темы.
class AppTabBar extends StatefulWidget {
  const AppTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<AppTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Высота «таблетки» и отступы вокруг неё (как в Telegram: 56 и 8 dp).
  static const height = 56.0;
  static const margin = 8.0;
  static const maxWidth = 344.0;

  /// Сколько места снизу занимает панель вместе с отступами
  /// (без системного отступа навигации).
  static const extent = height + margin * 2;

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> {
  /// Позиция пальца при перетаскивании выделения; null — не перетаскивают.
  double? _dragX;
  int? _dragIndex;

  int _indexAt(double x, double width) => (x / (width / widget.tabs.length))
      .floor()
      .clamp(0, widget.tabs.length - 1);

  void _dragTo(double x, double width) {
    final index = _indexAt(x, width);
    if (index != _dragIndex) HapticFeedback.selectionClick();
    setState(() {
      _dragX = x.clamp(0, width);
      _dragIndex = index;
    });
  }

  void _endDrag() {
    final index = _dragIndex;
    setState(() {
      _dragX = null;
      _dragIndex = null;
    });
    if (index != null && index != widget.selectedIndex) {
      widget.onSelected(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final accent = AppColors.accent.resolveFrom(context);
    final idle = AppColors.textPrimary.resolveFrom(context);
    final surface = AppColors.tabBar.resolveFrom(context);
    final dragging = _dragX != null;
    final active = _dragIndex ?? widget.selectedIndex;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppTabBar.maxWidth),
        child: AnimatedScale(
          // Как в Telegram: при перетаскивании панель чуть увеличивается.
          scale: dragging ? 1.019 : 1,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOutQuint,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              shadows: [
                BoxShadow(
                  color: dark
                      ? const Color(0x33000000)
                      : const Color(0x20000000),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipPath(
              clipper: const ShapeBorderClipper(shape: StadiumBorder()),
              child: RepaintBoundary(
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: surface,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: dark
                            ? const Color(0x24FFFFFF)
                            : const Color(0x1A000000),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    height: AppTabBar.height,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final tabWidth = width / widget.tabs.length;
                          // Подложка выделения: за пальцем при перетаскивании,
                          // иначе — на выбранной вкладке, с пружинящим переходом.
                          final pillLeft = dragging
                              ? (_dragX! - tabWidth / 2).clamp(
                                  0.0,
                                  width - tabWidth,
                                )
                              : widget.selectedIndex * tabWidth;
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onLongPressStart: (d) =>
                                _dragTo(d.localPosition.dx, width),
                            onLongPressMoveUpdate: (d) =>
                                _dragTo(d.localPosition.dx, width),
                            onLongPressEnd: (_) => _endDrag(),
                            onLongPressCancel: _endDrag,
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: dragging
                                      ? Duration.zero
                                      : const Duration(milliseconds: 420),
                                  curve: Curves.easeOutBack,
                                  left: pillLeft,
                                  top: 0,
                                  bottom: 0,
                                  width: tabWidth,
                                  child: DecoratedBox(
                                    decoration: ShapeDecoration(
                                      color: accent.withValues(
                                        alpha: dark ? 0.14 : 0.10,
                                      ),
                                      shape: const StadiumBorder(),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    for (var i = 0; i < widget.tabs.length; i++)
                                      Expanded(
                                        child: _TabButton(
                                          tab: widget.tabs[i],
                                          selected: i == active,
                                          accent: accent,
                                          idle: idle,
                                          onTap: () {
                                            HapticFeedback.selectionClick();
                                            widget.onSelected(i);
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.selected,
    required this.accent,
    required this.idle,
    required this.onTap,
  });

  final AppTab tab;
  final bool selected;
  final Color accent;
  final Color idle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: tab.label,
    excludeSemantics: true,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: selected ? accent : idle),
        duration: const Duration(milliseconds: 320),
        curve: Curves.decelerate,
        builder: (context, color, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tab.icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              tab.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: -0.1,
                color: color,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
