import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:intl/intl.dart';

import '../../../core/format/formatters.dart';
import '../../../core/theme/app_theme.dart';

/// График онлайна (fl_chart): плавная линия с градиентной заливкой,
/// подписи дней снизу, подсказка с датой и числом игроков при касании.
class PlayersChart extends StatelessWidget {
  const PlayersChart({required this.points, super.key});

  final List<PlayerCountPoint> points;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final color = AppColors.online.resolveFrom(context);
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
    final dayFormat = DateFormat.E(locale);
    final tooltipFormat = DateFormat.MMMd(locale).add_Hm();
    const day = 24 * 60 * 60 * 1000.0;

    return LineChart(
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
                  : Text(formatPlayers(value.round(), locale), style: muted),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: day,
              reservedSize: 24,
              getTitlesWidget: (value, meta) =>
                  value == meta.min || value == meta.max
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        dayFormat.format(
                          DateTime.fromMillisecondsSinceEpoch(value.round())
                              .toLocal(),
                        ),
                        style: muted,
                      ),
                    ),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.card.resolveFrom(context),
            getTooltipItems: (spots) => [
              for (final s in spots)
                LineTooltipItem(
                  '${formatCount(s.y.round(), locale)}\n',
                  AppText.title(context).copyWith(fontSize: 14, color: color),
                  children: [
                    TextSpan(
                      text: tooltipFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(s.x.round())
                            .toLocal(),
                      ),
                      style: muted,
                    ),
                  ],
                ),
            ],
          ),
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
    );
  }
}
