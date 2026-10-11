import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';

/// Касание графика: зажмите палец и ведите вдоль графика — подсказка
/// показывает ближайший по времени замер в любой точке.
///
/// По умолчанию fl_chart показывает подсказку, только если палец ближе
/// 10 px к точке. Замеров на графике немного, поэтому подсказка
/// появлялась лишь у краёв. Здесь порог снят, ближайшая точка ищется
/// по горизонтали.
LineTouchData chartTouchData(
  BuildContext context, {
  required Color color,
  required List<LineTooltipItem?> Function(List<LineBarSpot> spots) tooltip,
}) {
  final card = AppColors.tabBar.resolveFrom(context);
  int? lastIndex;
  return LineTouchData(
    touchSpotThreshold: double.infinity,
    distanceCalculator: (touch, spot) => (touch.dx - spot.dx).abs(),
    // Лёгкий отклик, когда подсказка переходит к следующему замеру.
    touchCallback: (event, response) {
      final index = response?.lineBarSpots?.firstOrNull?.spotIndex;
      if (index != null &&
          index != lastIndex &&
          event.isInterestedForInteractions) {
        HapticFeedback.selectionClick();
      }
      lastIndex = event.isInterestedForInteractions ? index : null;
    },
    getTouchedSpotIndicator: (bar, indexes) => [
      for (final _ in indexes)
        TouchedSpotIndicatorData(
          FlLine(
            color: color.withValues(alpha: 0.55),
            strokeWidth: 1.2,
            dashArray: const [4, 4],
          ),
          FlDotData(
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: 5,
              color: color,
              strokeWidth: 2.5,
              strokeColor: card,
            ),
          ),
        ),
    ],
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (_) => card,
      tooltipBorderRadius: BorderRadius.circular(12),
      tooltipBorder: BorderSide(
        color: AppColors.controlBorder.resolveFrom(context),
        width: 0.5,
      ),
      tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      maxContentWidth: 180,
      fitInsideHorizontally: true,
      fitInsideVertically: true,
      getTooltipItems: tooltip,
    ),
  );
}
