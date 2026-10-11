import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:intl/intl.dart';

import '../../../core/format/formatters.dart';
import '../../../core/theme/app_theme.dart';
import 'chart_touch.dart';

/// График онлайна (fl_chart): плавная линия с градиентной заливкой,
/// подписи времени снизу, подсказка с датой и числом игроков при касании.
class PlayersChart extends StatelessWidget {
  const PlayersChart({required this.points, required this.period, super.key});

  final List<PlayerCountPoint> points;
  final HistoryPeriod period;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final color = AppColors.accent.resolveFrom(context);
    final muted = AppText.secondary(context).copyWith(fontSize: 11);
    final spots = [
      for (final p in points)
        FlSpot(
          p.recordedAt.millisecondsSinceEpoch.toDouble(),
          p.players.toDouble(),
        ),
    ];
    final maxY =
        points.map((p) => p.players).reduce((a, b) => a > b ? a : b) * 1.15;
    final minX = spots.first.x;
    final maxX = spots.last.x;
    final axisFormat = axisDateFormat(minX, maxX, locale);
    final tooltipFormat = DateFormat.MMMd(locale).add_Hm();

    String label(double x) => axisFormat.format(
      DateTime.fromMillisecondsSinceEpoch(x.round()).toLocal(),
    );
    return Column(
      children: [
        Expanded(
          child: LineChart(
            duration: const Duration(milliseconds: 250),
            LineChartData(
              minY: 0,
              maxY: maxY <= 0 ? 1 : maxY,
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: maxY <= 0 ? 1 : maxY / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.cardBorder.resolveFrom(context),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    interval: maxY <= 0 ? 1 : maxY / 4,
                    getTitlesWidget: (value, meta) => value == meta.max
                        ? const SizedBox.shrink()
                        : Text(
                            formatPlayers(value.round(), locale),
                            style: muted,
                          ),
                  ),
                ),
                bottomTitles: const AxisTitles(),
              ),
              lineTouchData: chartTouchData(
                context,
                color: color,
                tooltip: (spots) => [
                  for (final s in spots)
                    LineTooltipItem(
                      '${formatCount(s.y.round(), locale)}\n',
                      AppText.title(context).copyWith(
                        fontSize: 15,
                        color: color,
                        fontFeatures: AppText.tabular,
                      ),
                      children: [
                        TextSpan(
                          text: tooltipFormat.format(
                            DateTime.fromMillisecondsSinceEpoch(s.x.round())
                                .toLocal(),
                          ),
                          style: muted.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                ],
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  color: color,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withValues(alpha: 0.35),
                        color.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          // Под областью графика, без колонки чисел слева.
          padding: const EdgeInsets.only(left: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label(minX), style: muted),
              Text(label((minX + maxX) / 2), style: muted),
              Text(label(maxX), style: muted),
            ],
          ),
        ),
      ],
    );
  }
}
