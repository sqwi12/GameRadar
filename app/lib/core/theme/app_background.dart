import 'package:flutter/cupertino.dart';

import 'app_theme.dart';

/// Фон под стеклом: градиент, мягкие световые пятна и едва заметные
/// круги «радара». Стеклу нужен насыщенный фон — на плоском оно не видно.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    Color c(CupertinoDynamicColor color) => color.resolveFrom(context);
    return DecoratedBox(
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
            alignment: const Alignment(-1.1, -0.9),
            color: c(AppColors.glowA),
            size: 1.1,
          ),
          _Glow(
            alignment: const Alignment(1.2, -0.1),
            color: c(AppColors.glowB),
            size: 0.9,
          ),
          _Glow(
            alignment: const Alignment(-0.6, 1.1),
            color: c(AppColors.glowC),
            size: 0.8,
          ),
          CustomPaint(painter: _RadarRings(c(AppColors.radarRing))),
        ],
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
            gradient: RadialGradient(colors: [color, color.withAlpha(0)]),
          ),
        ),
      ),
    ),
  );
}

/// Концентрические круги — намёк на «радар» в названии.
class _RadarRings extends CustomPainter {
  const _RadarRings(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.85, size.height * 0.18);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color;
    for (var r = 60.0; r < size.longestSide; r += 70) {
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(_RadarRings old) => old.color != color;
}
