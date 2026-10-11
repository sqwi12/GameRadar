import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:intl/intl.dart';

import '../../../core/format/formatters.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/game_widgets.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/state_views.dart';
import 'game_providers.dart';
import 'players_chart.dart';
import 'price_chart.dart';

/// Что показывает график.
enum ChartMetric { players, price }

/// Один график на экране игры: «Онлайн | Цена» сверху, общий период
/// «24 ч · 7 дн · 30 дн · Всё» снизу. Цифры над графиком меняются вместе
/// с ним. Так оба графика доступны без прокрутки экрана.
class GameChartsCard extends ConsumerStatefulWidget {
  const GameChartsCard({required this.game, super.key});

  final GameDetails game;

  @override
  ConsumerState<GameChartsCard> createState() => _GameChartsCardState();
}

class _GameChartsCardState extends ConsumerState<GameChartsCard> {
  ChartMetric _metric = ChartMetric.players;
  HistoryPeriod _period = HistoryPeriod.week;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = widget.game;
    // У бесплатной игры нет цены — только онлайн.
    final metric = game.isFree ? ChartMetric.players : _metric;

    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!game.isFree) ...[
            AppSegmentedControl(
              labels: [l10n.metricPlayers, l10n.metricPrice],
              selectedIndex: metric.index,
              onSelected: (i) =>
                  setState(() => _metric = ChartMetric.values[i]),
            ),
            const SizedBox(height: 16),
          ],
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: switch (metric) {
              ChartMetric.players => _PlayersView(
                key: const ValueKey('players'),
                game: game,
                period: _period,
              ),
              ChartMetric.price => _PriceView(
                key: const ValueKey('price'),
                game: game,
                period: _period,
              ),
            },
          ),
          const SizedBox(height: 14),
          AppSegmentedControl(
            labels: [
              l10n.period24h,
              l10n.period7d,
              l10n.period30d,
              l10n.periodAll,
            ],
            selectedIndex: HistoryPeriod.values.indexOf(_period),
            onSelected: (i) =>
                setState(() => _period = HistoryPeriod.values[i]),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.chartHoldHint,
            textAlign: TextAlign.center,
            style: AppText.secondary(context).copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

const _chartHeight = 190.0;

/// Онлайн: сейчас, пик и среднее за период, график.
class _PlayersView extends ConsumerWidget {
  const _PlayersView({required this.game, required this.period, super.key});

  final GameDetails game;
  final HistoryPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final history = ref.watch(playerHistoryStateProvider(game.appId, period));
    final points = history.data?.points ?? const <PlayerCountPoint>[];
    final players = points.map((p) => p.players);
    final peak = players.isEmpty
        ? null
        : players.reduce((a, b) => a > b ? a : b);
    final average = players.isEmpty
        ? null
        : (players.reduce((a, b) => a + b) / players.length).round();
    String value(int? v) => v == null ? '—' : formatPlayers(v, locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Figures(
          children: [
            _Figure(
              label: l10n.playersNow,
              value: value(game.players.current),
              color: AppColors.accent.resolveFrom(context),
            ),
            _Figure(label: l10n.playersPeakPeriod, value: value(peak)),
            _Figure(label: l10n.playersAverage, value: value(average)),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: _chartHeight,
          child: switch (history) {
            _ when points.length >= 2 => PlayersChart(
              points: points,
              period: period,
            ),
            _ when history.isInitialLoading => const LoadingView(),
            _ => _ChartMessage(
              history.error != null && history.data == null
                  ? describeError(l10n, history.error!)
                  : l10n.chartNoData,
            ),
          },
        ),
        _ChartFootnote(
          points.isEmpty
              ? ''
              // «Всё время» — максимум за каждые сутки, а не отдельные замеры.
              : period == HistoryPeriod.all
              ? l10n.playersDailyPeaks(points.length)
              : l10n.playersReadings(points.length),
        ),
      ],
    );
  }
}

/// Цена: сейчас, лучшая за период и минимум за всё время (IsThereAnyDeal;
/// без него — цена без скидки), ступенчатый график.
class _PriceView extends ConsumerWidget {
  const _PriceView({required this.game, required this.period, super.key});

  final GameDetails game;
  final HistoryPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final history = ref.watch(priceHistoryStateProvider(game.appId));
    final entries = history.data ?? const <PriceHistoryEntry>[];
    final now = DateTime.now();
    final summary = PriceHistorySummary.from(
      entries,
      now: now,
      from: switch (period.duration) {
        final d? => now.subtract(d),
        null => null,
      },
    );
    final current = game.price;
    final currency =
        current?.currency ??
        entries.map((e) => e.currency).whereType<String>().firstOrNull ??
        'KZT';
    final best = summary.best;
    final discounted = best != null && best.discountPct > 0;
    // Исторический минимум показываем, только если он в той же валюте.
    final storeLow = game.storeLow?.currency == currency ? game.storeLow : null;
    // Для части регионов (например, kz) ITAD отдаёт минимум в другой валюте
    // и по другому региону: цену не сравнить, но процент скидки в Steam
    // обычно одинаков везде — показываем лучшую скидку.
    final bestCut = storeLow == null && (game.storeLow?.cut ?? 0) > 0
        ? game.storeLow
        : null;
    final dateFormat = DateFormat.MMMd(locale);
    final discountColor = AppColors.discount.resolveFrom(context);
    final nowPrice = current?.isAvailable == true ? current!.finalPrice : null;
    // Сейчас цена не выше исторического минимума — выделяем.
    final atLow =
        storeLow != null && nowPrice != null && nowPrice <= storeLow.price;
    String price(int? v) => v == null ? '—' : formatPrice(v, currency, locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Figures(
          children: [
            _Figure(
              label: atLow ? l10n.priceNowAtLow : l10n.priceNowLabel,
              value: price(nowPrice),
              color: atLow ? discountColor : null,
            ),
            _Figure(
              label: discounted
                  ? l10n.priceBestWithDiscount(
                      l10n.discountBadge(best.discountPct),
                    )
                  : l10n.priceBestLabel,
              value: price(best?.price),
              color: discounted ? discountColor : null,
            ),
            // Цена без скидки видна зачёркнутой в карточке выше, поэтому
            // при известном минимуме за всё время показываем его.
            if (storeLow != null)
              _Figure(
                label: l10n.allTimeLowLabel(l10n.discountBadge(storeLow.cut)),
                value: price(storeLow.price),
                color: discountColor,
              )
            else if (bestCut != null)
              _Figure(
                label: l10n.bestCutLabel,
                value: l10n.discountBadge(bestCut.cut),
                color: discountColor,
              )
            else
              _Figure(
                label: l10n.priceRegularLabel,
                value: price(summary.regular ?? current?.initialPrice),
              ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: _chartHeight,
          child: switch (history) {
            _ when summary.canDraw => PriceChart(
              summary: summary,
              currency: currency,
              // Линия минимума — только на «Всё»: на коротких периодах
              // она сжимала бы график в полоску.
              allTimeLow: period == HistoryPeriod.all ? storeLow?.price : null,
            ),
            _ when history.isInitialLoading => const LoadingView(),
            _ => _ChartMessage(
              history.error != null && history.data == null
                  ? describeError(l10n, history.error!)
                  : l10n.priceHistoryEmpty,
            ),
          },
        ),
        _ChartFootnote(
          storeLow != null
              ? l10n.allTimeLowSource(
                  DateFormat.yMMMd(locale).format(storeLow.at.toLocal()),
                )
              : bestCut != null
              ? l10n.bestCutSource(
                  DateFormat.yMMMd(locale).format(bestCut.at.toLocal()),
                )
              : [
                  if (summary.since case final since?)
                    l10n.priceTrackedSince(dateFormat.format(since.toLocal())),
                  if (best != null)
                    l10n.priceBestOn(dateFormat.format(best.at.toLocal())),
                ].join(' · '),
        ),
      ],
    );
  }
}

/// Пояснение под графиком: всегда одна строка одной высоты.
class _ChartFootnote extends StatelessWidget {
  const _ChartFootnote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppText.secondary(context).copyWith(fontSize: 12, height: 1.3),
    ),
  );
}

class _ChartMessage extends StatelessWidget {
  const _ChartMessage(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: AppText.secondary(context),
    ),
  );
}

/// Три цифры над графиком.
class _Figures extends StatelessWidget {
  const _Figures({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [for (final c in children) Expanded(child: c)],
  );
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Длинная цена уменьшается, а не обрезается.
      FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          maxLines: 1,
          style: AppText.title(
            context,
          ).copyWith(fontSize: 22, fontFeatures: AppText.tabular, color: color),
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppText.secondary(context).copyWith(fontSize: 12),
      ),
    ],
  );
}
