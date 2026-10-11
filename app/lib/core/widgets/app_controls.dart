import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Лёгкие элементы управления в стиле нижней панели (как в Telegram).
///
/// По правилам Liquid Glass стекло — только у навигации (шапка, панель
/// вкладок). Содержимое экранов рисуется обычными поверхностями: так оно
/// читается на любом фоне и не пересчитывает шейдеры на каждом кадре
/// прокрутки и анимации перехода.

/// Круглая кнопка в шапке (назад, настройки).
class AppBarButton extends StatelessWidget {
  const AppBarButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  static const size = 40.0;

  final IconData icon;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semanticLabel,
    excludeSemantics: true,
    child: _Pressable(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.tabBar.resolveFrom(context),
          shape: CircleBorder(
            side: BorderSide(
              color: AppColors.controlBorder.resolveFrom(context),
              width: 0.5,
            ),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: SizedBox.square(
          dimension: size,
          child: Icon(
            icon,
            size: 20,
            color: AppColors.textPrimary.resolveFrom(context),
          ),
        ),
      ),
    ),
  );
}

/// Сегментированный переключатель: выделение перетекает между вариантами,
/// как в нижней панели.
class AppSegmentedControl extends StatelessWidget {
  const AppSegmentedControl({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final accent = AppColors.accent.resolveFrom(context);
    final idle = AppColors.textSecondary.resolveFrom(context);
    final index = selectedIndex.clamp(0, labels.length - 1);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.card.resolveFrom(context),
        shape: StadiumBorder(
          side: BorderSide(
            color: AppColors.controlBorder.resolveFrom(context),
            width: 0.5,
          ),
        ),
      ),
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeOutBack,
                alignment: Alignment(
                  labels.length == 1 ? 0 : -1 + 2 * index / (labels.length - 1),
                  0,
                ),
                child: FractionallySizedBox(
                  widthFactor: 1 / labels.length,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: accent.withValues(alpha: dark ? 0.16 : 0.12),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: i == index,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (i == index) return;
                            HapticFeedback.selectionClick();
                            onSelected(i);
                          },
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: -0.2,
                                fontWeight: i == index
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: i == index ? accent : idle,
                              ),
                              child: Text(
                                labels[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Фильтр-чип: выбранный — акцентный текст на мягкой подложке.
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final accent = AppColors.accent.resolveFrom(context);
    final color = selected
        ? accent
        : AppColors.textPrimary.resolveFrom(context);
    return Semantics(
      button: true,
      selected: selected,
      child: _Pressable(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: ShapeDecoration(
            color: selected
                ? accent.withValues(alpha: dark ? 0.16 : 0.12)
                : AppColors.card.resolveFrom(context),
            shape: StadiumBorder(
              side: BorderSide(
                color: selected
                    ? accent.withValues(alpha: 0.45)
                    : AppColors.controlBorder.resolveFrom(context),
                width: selected ? 1 : 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: -0.2,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                  fontFeatures: AppText.tabular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Группа строк настроек: заголовок, карточка со строками, подпись.
class AppGroupedSection extends StatelessWidget {
  const AppGroupedSection({
    required this.children,
    this.header,
    this.footer,
    super.key,
  });

  final List<Widget> children;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final divider = AppColors.controlBorder.resolveFrom(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: DefaultTextStyle(
              style: AppText.sectionHeader(context),
              child: header!,
            ),
          ),
        DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.card.resolveFrom(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: AppColors.cardBorder.resolveFrom(context),
                width: 0.5,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    Padding(
                      // Разделитель начинается после иконки, как в iOS.
                      padding: const EdgeInsets.only(left: 54),
                      child: SizedBox(
                        height: 0.5,
                        width: double.infinity,
                        child: ColoredBox(color: divider),
                      ),
                    ),
                  children[i],
                ],
              ],
            ),
          ),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DefaultTextStyle(
              style: AppText.secondary(context).copyWith(fontSize: 13),
              child: footer!,
            ),
          ),
      ],
    );
  }
}

/// Строка настроек: иконка, заголовок, подзаголовок, элемент справа.
class AppListTile extends StatefulWidget {
  const AppListTile({
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  /// Шеврон «перейти дальше».
  static const Widget chevron = _Chevron();

  final Widget title;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  State<AppListTile> createState() => _AppListTileState();
}

class _AppListTileState extends State<AppListTile> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
      child: Row(
        children: [
          if (widget.leading != null) ...[
            IconTheme(
              data: IconThemeData(
                size: 22,
                color: AppColors.accent.resolveFrom(context),
              ),
              child: SizedBox(width: 24, child: Center(child: widget.leading)),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: AppText.body(context)
                      .copyWith(fontWeight: FontWeight.w600),
                  child: widget.title,
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 2),
                  DefaultTextStyle(
                    style: AppText.secondary(context).copyWith(fontSize: 13.5),
                    child: widget.subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (widget.trailing != null) ...[
            const SizedBox(width: 10),
            widget.trailing!,
          ],
        ],
      ),
    );
    if (widget.onTap == null) return content;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _down
            ? AppColors.controlBorder.resolveFrom(context)
            : const Color(0x00000000),
        child: content,
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) => Icon(
    CupertinoIcons.chevron_forward,
    size: 18,
    color: AppColors.textSecondary.resolveFrom(context),
  );
}

/// Лёгкое «вдавливание» при нажатии.
class _Pressable extends StatefulWidget {
  const _Pressable({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _down = false;

  void _set(bool v) => setState(() => _down = v);

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTapDown: (_) => _set(true),
    onTapCancel: () => _set(false),
    onTapUp: (_) => _set(false),
    onTap: widget.onTap,
    child: AnimatedScale(
      scale: _down ? 0.92 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: widget.child,
    ),
  );
}
