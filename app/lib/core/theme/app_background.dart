import 'package:flutter/cupertino.dart';

import 'app_theme.dart';

/// Фон под стеклом: глубокий градиент и два мягких свечения. Стеклу нужен
/// неоднородный фон — на плоском оно не видно, — но фон не должен спорить
/// с контентом, поэтому без узоров и ярких пятен.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    Color c(CupertinoDynamicColor color) => color.resolveFrom(context);
    // Отдельный слой: при прокрутке фон не перерисовывается.
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [c(AppColors.backgroundTop), c(AppColors.backgroundBottom)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _Glow(
              alignment: const Alignment(0.2, -1.25),
              color: c(AppColors.glowA),
              size: 1.6,
            ),
            _Glow(
              alignment: const Alignment(1.3, 1.1),
              color: c(AppColors.glowB),
              size: 1.2,
            ),
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.alignment,
    required this.color,
    required this.size,
  });

  final Alignment alignment;
  final Color color;

  /// Диаметр относительно ширины экрана.
  final double size;

  @override
  Widget build(BuildContext context) => Align(
    alignment: alignment,
    child: FractionallySizedBox(
      widthFactor: size,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color,
                color.withValues(alpha: color.a / 3),
                color.withAlpha(0),
              ],
              stops: const [0, 0.45, 1],
            ),
          ),
        ),
      ),
    ),
  );
}
