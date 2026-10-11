import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:intl/intl.dart';

import '../../../core/format/formatters.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/l10n.dart';
import 'chart_touch.dart';

/// Точка графика цены: состояние цены с момента [at].
typedef PricePoint = ({DateTime at, int price, int discountPct});

/// Сводка истории цены для карточки и графика.
class PriceHistorySummary {
  PriceHistorySummary._(this.points, this.best, this.since, this.regular);

  /// Строит сводку из записей сервера (только изменения цены, по возрастанию
  /// времени). Последняя цена продлевается до [now], чтобы на графике было
  /// видно, сколько она уже держится. Периоды «нет в продаже» — разрывы.
  ///
  /// [from] — начало выбранного периода (null — всё время). Цена, которая
  /// уже действовала к началу периода, начинает график с этого момента:
  /// иначе за сутки без изменений график был бы пустым.
  factory PriceHistorySummary.from(
    List<PriceHistoryEntry> entries, {
    DateTime? now,
    DateTime? from,
  }) {
    final end = now ?? DateTime.now();
    final points = <PricePoint?>[];
    PricePoint? best;
    int? regular;

    void add(PriceHistoryEntry e, DateTime at) {
      if (!e.isAvailable || e.finalPrice == null) {
        points.add(null);
        return;
      }
      final p = (at: at, price: e.finalPrice!, discountPct: e.discountPct);
      points.add(p);
      // При равной цене лучшей считается первая: «впервые с такой ценой».
      if (best == null || p.price < best!.price) best = p;
      if (e.initialPrice case final initial?) {
        if (regular == null || initial > regular!) regular = initial;
      }
    }

    // Последняя запись до начала периода — состояние на его начало.
    PriceHistoryEntry? before;
    for (final e in entries) {
      if (from != null && e.recordedAt.isBefore(from)) {
        before = e;
        continue;
      }
      if (before != null) {
        add(before, from!);
        before = null;
      }
      add(e, e.recordedAt);
    }
    if (before != null) add(before, from!);

    final last = points.lastOrNull;
    if (last != null) {
      points.add((at: end, price: last.price, discountPct: last.discountPct));
    }
    return PriceHistorySummary._(
      points,
      best,
      entries.isEmpty ? null : entries.first.recordedAt,
      regular,
    );
  }

  /// Точки графика; null — разрыв (игры не было в продаже).
  final List<PricePoint?> points;

  /// Самая низкая цена за выбранный период.
  final PricePoint? best;

  /// С какого момента есть история (начало отслеживания).
  final DateTime? since;

  /// Цена без скидки (наибольшая исходная цена).
  final int? regular;

  bool get canDraw => points.whereType<PricePoint>().length >= 2;
}

/// Ступенчатый график цены: цена держится до следующего изменения.
class PriceChart extends StatelessWidget {
  const PriceChart({required this.summary, required this.currency, super.key});

  final PriceHistorySummary summary;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final color = AppColors.accent.resolveFrom(context);
    final discount = AppColors.discount.resolveFrom(context);
    final muted = AppText.secondary(context).copyWith(fontSize: 11);
    final points = summary.points;
    final spots = [
      for (final p in points)
        p == null
            ? FlSpot.nullSpot
            : FlSpot(
                p.at.millisecondsSinceEpoch.toDouble(),
                p.price / minorUnitsPerMajor,
              ),
    ];
    final prices = points.whereType<PricePoint>().map((p) => p.price);
    final low = prices.reduce((a, b) => a < b ? a : b) / minorUnitsPerMajor;
    final high =
        [...prices, ?summary.regular].reduce((a, b) => a > b ? a : b) /
        minorUnitsPerMajor;
    // Запас сверху и снизу, чтобы линия не прилипала к краям, и «круглый»
    // шаг шкалы, чтобы подписи были вроде «10 000 ₸», а не «9 093,75 ₸».
    final pad = (high - low) == 0 ? high * 0.2 + 1 : (high - low) * 0.25;
    final step = _niceStep((high - low + pad * 2) / 3);
    final minY =
        ((low - pad) / step).floorToDouble().clamp(0, double.infinity) * step;
    final maxY = ((high + pad) / step).ceilToDouble() * step;
    final xs = spots.where((s) => !s.isNull()).map((s) => s.x);
    final minX = xs.reduce((a, b) => a < b ? a : b);
    final maxX = xs.reduce((a, b) => a > b ? a : b);
    final dateFormat = axisDateFormat(minX, maxX, locale);
    final tooltipFormat = DateFormat.yMMMd(locale);

    final start = DateTime.fromMillisecondsSinceEpoch(minX.round()).toLocal();
    final end = DateTime.fromMillisecondsSinceEpoch(maxX.round()).toLocal();
    return Column(
      children: [
        Expanded(
          child: LineChart(
            duration: const Duration(milliseconds: 250),
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: step,
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
                    reservedSize: 64,
                    interval: step,
                    getTitlesWidget: (value, meta) => value == meta.max
                        ? const SizedBox.shrink()
                        : Text(
                            formatPrice(
                              value.round() * minorUnitsPerMajor,
                              currency,
                              locale,
                            ),
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
                    if (points[s.spotIndex] case final p?)
                      LineTooltipItem(
                        formatPrice(p.price, currency, locale),
                        AppText.title(context).copyWith(
                          fontSize: 15,
                          color: p.discountPct > 0 ? discount : color,
                          fontFeatures: AppText.tabular,
                        ),
                        children: [
                          if (p.discountPct > 0)
                            TextSpan(
                              text: '  ${l10n.discountBadge(p.discountPct)}',
                              style: muted.copyWith(
                                fontSize: 12,
                                color: discount,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          TextSpan(
                            text: '\n${tooltipFormat.format(p.at.toLocal())}',
                            style: muted.copyWith(fontSize: 12),
                          ),
                        ],
                      )
                    else
                      null,
                ],
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isStepLineChart: true,
                  lineChartStepData: const LineChartStepData(
                    stepDirection: LineChartStepData.stepDirectionForward,
                  ),
                  color: color,
                  barWidth: 2.5,
                  // Точки — моменты изменения цены; со скидкой — зелёные.
                  dotData: FlDotData(
                    checkToShowDot: (spot, bar) =>
                        spot.x != maxX || bar.spots.length == 2,
                    getDotPainter: (spot, percent, bar, index) {
                      final p = points[index];
                      return FlDotCirclePainter(
                        radius: 3.5,
                        color: p != null && p.discountPct > 0
                            ? discount
                            : color,
                        strokeWidth: 0,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withValues(alpha: 0.28),
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
          // Под областью графика, без колонки цен слева.
          padding: const EdgeInsets.only(left: 64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateFormat.format(start), style: muted),
              Text(dateFormat.format(end), style: muted),
            ],
          ),
        ),
      ],
    );
  }
}

/// «Круглый» шаг шкалы: 1, 2, 2,5 или 5 × 10ⁿ, не меньше [raw].
double _niceStep(double raw) {
  if (raw <= 0) return 1;
  final magnitude = math
      .pow(10, (math.log(raw) / math.ln10).floor())
      .toDouble();
  for (final m in const [1.0, 2.0, 2.5, 5.0, 10.0]) {
    if (m * magnitude >= raw) return m * magnitude;
  }
  return 10 * magnitude;
}
