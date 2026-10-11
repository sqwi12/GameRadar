import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../core/format/formatters.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/game_widgets.dart';
import '../../../core/widgets/glass_screen.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/resource_scroll_view.dart';
import '../../../core/widgets/state_views.dart';
import '../../watchlist/presentation/watch_sheet.dart';
import '../../watchlist/presentation/watchlist_providers.dart';
import 'game_providers.dart';
import '../../../core/widgets/app_controls.dart';
import 'players_chart.dart';
import 'price_chart.dart';

/// Экран игры: цена и скидка, онлайн и пики, график за 7 дней, отслеживание.
class GameScreen extends ConsumerWidget {
  const GameScreen({required this.appId, super.key});

  final int appId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final view = ref.watch(gameDetailsStateProvider(appId));
    final notifier = ref.read(gameDetailsStateProvider(appId).notifier);

    return GlassScreen(
      title: view.data?.name ?? l10n.gameTitle,
      insideTabs: false,
      leading: AppBarButton(
        icon: CupertinoIcons.chevron_back,
        semanticLabel: l10n.back,
        onPressed: context.pop,
      ),
      body: ResourceScrollView<GameDetails>(
        view: view,
        insideTabs: false,
        onRetry: notifier.retry,
        onRefresh: () async {
          // Вместе с данными игры обновляются и графики.
          ref.read(priceHistoryStateProvider(appId).notifier).retry();
          for (final period in HistoryPeriod.values) {
            if (ref.exists(playerHistoryStateProvider(appId, period))) {
              ref
                  .read(playerHistoryStateProvider(appId, period).notifier)
                  .retry();
            }
          }
          return notifier.refresh();
        },
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        slivers: (context, game) => [
          SliverList.list(children: _content(context, ref, game)),
        ],
      ),
    );
  }

  List<Widget> _content(BuildContext context, WidgetRef ref, GameDetails game) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final languageCode = Localizations.localeOf(context).languageCode;
    final description = game.descriptionFor(languageCode);
    // Игру ещё не обрабатывал worker: данные появятся в ближайшие минуты.
    final pending =
        game.detailsCheckedAt == null &&
        game.price == null &&
        game.players.current == null;
    final subtitle = [
      if (game.developers.isNotEmpty) game.developers.first,
      if (game.releaseDate != null)
        DateFormat.y(locale).format(game.releaseDate!),
    ].join(' · ');

    return [
      GameImage(url: game.headerImageUrl, radius: 22),
      const SizedBox(height: 16),
      Text(
        game.name,
        style: AppText.largeTitle(context).copyWith(fontSize: 26),
      ),
      if (subtitle.isNotEmpty) ...[
        const SizedBox(height: 4),
        Text(subtitle, style: AppText.secondary(context)),
      ],
      if (game.topRank != null || game.reviews?.positivePct != null) ...[
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            if (game.topRank != null)
              _Fact(
                icon: CupertinoIcons.chart_bar_alt_fill,
                text: l10n.topRank(game.topRank!),
              ),
            if (game.reviews?.positivePct case final pct?)
              _Fact(
                icon: CupertinoIcons.hand_thumbsup_fill,
                text: l10n.reviewsSummary(
                  pct,
                  formatCount(game.reviews!.total, locale),
                ),
              ),
          ],
        ),
      ],
      const SizedBox(height: 16),
      if (pending) ...[
        AppSurface(
          child: Row(
            children: [
              const CupertinoActivityIndicator(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.gameDataPending,
                  style: AppText.secondary(context),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
      _PriceCard(appId: appId, game: game),
      if (!game.isFree) ...[
        const SizedBox(height: 12),
        _PriceHistoryCard(appId: appId, current: game.price),
      ],
      const SizedBox(height: 12),
      _PlayersCard(appId: appId, stats: game.players),
      if (game.genres.isNotEmpty || description != null) ...[
        const SizedBox(height: 12),
        AppSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (description != null)
                Text(
                  description,
                  style: AppText.body(context).copyWith(height: 1.35),
                ),
              if (game.genres.isNotEmpty) ...[
                if (description != null) const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [for (final g in game.genres) _Tag(g)],
                ),
              ],
            ],
          ),
        ),
      ],
    ];
  }
}

/// Цена и кнопка отслеживания.
class _PriceCard extends ConsumerWidget {
  const _PriceCard({required this.appId, required this.game});

  final int appId;
  final GameDetails game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final watched = ref.watch(watchItemProvider(appId));
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PriceTag(price: game.price, isFree: game.isFree, large: true),
          if (watched != null && watched.hasThresholds) ...[
            const SizedBox(height: 8),
            ThresholdsLabel(item: watched),
          ],
          const SizedBox(height: 14),
          GlassButton.custom(
            onTap: () =>
                showWatchSheet(context, appId: appId, price: game.price),
            height: 48,
            width: double.infinity,
            label: watched == null ? l10n.watchAdd : l10n.watchEdit,
            shape: const LiquidRoundedSuperellipse(borderRadius: 24),
            useOwnLayer: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  watched == null
                      ? CupertinoIcons.bell
                      : CupertinoIcons.bell_fill,
                  size: 18,
                  color: AppColors.accent.resolveFrom(context),
                ),
                const SizedBox(width: 8),
                Text(
                  watched == null ? l10n.watchAdd : l10n.watchEdit,
                  style: AppText.title(context)
                      .copyWith(color: AppColors.accent.resolveFrom(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Онлайн: текущий, пики за 24 ч и 7 дней, график за выбранный период.
class _PlayersCard extends ConsumerStatefulWidget {
  const _PlayersCard({required this.appId, required this.stats});

  final int appId;
  final PlayerStats stats;

  @override
  ConsumerState<_PlayersCard> createState() => _PlayersCardState();
}

class _PlayersCardState extends ConsumerState<_PlayersCard> {
  HistoryPeriod _period = HistoryPeriod.week;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final history = ref.watch(
      playerHistoryStateProvider(widget.appId, _period),
    );
    final points = history.data?.points ?? const [];
    final stats = widget.stats;

    String value(int? v) => v == null ? '—' : formatPlayers(v, locale);

    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: l10n.playersNow,
                  value: value(stats.current),
                  accent: true,
                ),
              ),
              Expanded(
                child: _Stat(label: l10n.peak24h, value: value(stats.peak24h)),
              ),
              Expanded(
                child: _Stat(label: l10n.peak7d, value: value(stats.peak7d)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AppSegmentedControl(
            labels: [l10n.period24h, l10n.period7d, l10n.period30d],
            selectedIndex: HistoryPeriod.values.indexOf(_period),
            onSelected: (i) =>
                setState(() => _period = HistoryPeriod.values[i]),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 190,
            child: switch (history) {
              _ when points.length >= 2 => PlayersChart(
                points: points,
                period: _period,
              ),
              _ when history.isInitialLoading => const LoadingView(),
              _ => Center(
                child: Text(
                  history.error != null && history.data == null
                      ? describeError(l10n, history.error!)
                      : l10n.chartNoData,
                  textAlign: TextAlign.center,
                  style: AppText.secondary(context),
                ),
              ),
            },
          ),
          const SizedBox(height: 6),
          Text(
            l10n.chartHoldHint,
            style: AppText.secondary(context).copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// История цены: сейчас, лучшая цена за время наблюдения, без скидки
/// и ступенчатый график изменений.
class _PriceHistoryCard extends ConsumerWidget {
  const _PriceHistoryCard({required this.appId, required this.current});

  final int appId;
  final GamePrice? current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final history = ref.watch(priceHistoryStateProvider(appId));
    final entries = history.data ?? const <PriceHistoryEntry>[];
    final summary = PriceHistorySummary.from(entries);
    final currency =
        current?.currency ??
        entries.map((e) => e.currency).whereType<String>().firstOrNull ??
        'KZT';
    final best = summary.best;
    final discount = AppColors.discount.resolveFrom(context);
    String price(int? v) => v == null ? '—' : formatPrice(v, currency, locale);

    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.priceHistoryTitle.toUpperCase(),
            style: AppText.sectionHeader(context),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Stat(
                  label: l10n.priceNowLabel,
                  value: current?.isAvailable == true
                      ? price(current!.finalPrice)
                      : '—',
                ),
              ),
              Expanded(
                child: _Stat(
                  label: best != null && best.discountPct > 0
                      ? l10n.priceBestWithDiscount(
                          l10n.discountBadge(best.discountPct),
                        )
                      : l10n.priceBestLabel,
                  value: price(best?.price),
                  color: best != null && best.discountPct > 0 ? discount : null,
                ),
              ),
              Expanded(
                child: _Stat(
                  label: l10n.priceRegularLabel,
                  value: price(summary.regular ?? current?.initialPrice),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: switch (history) {
              _ when summary.canDraw => PriceChart(
                summary: summary,
                currency: currency,
              ),
              _ when history.isInitialLoading => const LoadingView(),
              _ => Center(
                child: Text(
                  history.error != null && history.data == null
                      ? describeError(l10n, history.error!)
                      : l10n.priceHistoryEmpty,
                  textAlign: TextAlign.center,
                  style: AppText.secondary(context),
                ),
              ),
            },
          ),
          if (summary.since case final since?) ...[
            const SizedBox(height: 8),
            Text(
              l10n.priceTrackedSince(
                DateFormat.yMMMd(locale).format(since.toLocal()),
              ),
              style: AppText.secondary(context).copyWith(fontSize: 12),
            ),
          ],
          if (best != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                l10n.priceBestOn(
                  DateFormat.yMMMd(locale).format(best.at.toLocal()),
                ),
                style: AppText.secondary(context).copyWith(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.accent = false,
    this.color,
  });

  final String label;
  final String value;
  final bool accent;
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
          style: AppText.title(context).copyWith(
            fontSize: 22,
            fontFeatures: AppText.tabular,
            color:
                color ??
                (accent ? AppColors.accent.resolveFrom(context) : null),
          ),
        ),
      ),
      const SizedBox(height: 2),
      Text(label, style: AppText.secondary(context).copyWith(fontSize: 12)),
    ],
  );
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 15, color: AppColors.accent.resolveFrom(context)),
      const SizedBox(width: 5),
      Text(text, style: AppText.secondary(context)),
    ],
  );
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: AppColors.accent.resolveFrom(context).withValues(alpha: 0.14),
      shape: const StadiumBorder(),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        text,
        style: AppText.secondary(context).copyWith(
          fontSize: 13,
          color: AppColors.accent.resolveFrom(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// Пороги отслеживания: «цена ≤ 9 000 ₸ · скидка ≥ 50%» и «Цель достигнута».
class ThresholdsLabel extends StatelessWidget {
  const ThresholdsLabel({required this.item, super.key});

  final WatchlistItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = item.game.price?.currency ?? 'KZT';
    final parts = [
      if (item.targetPrice case final p?)
        l10n.thresholdPrice(formatPrice(p, currency, locale)),
      if (item.minDiscountPct case final d?) l10n.thresholdDiscount(d),
    ];
    final reached = item.isTargetReached;
    final color = reached
        ? AppColors.discount.resolveFrom(context)
        : AppColors.textSecondary.resolveFrom(context);
    final thresholds = Row(
      children: [
        Icon(
          reached ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.bell,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            reached
                ? '${l10n.targetReached} · ${parts.join(' · ')}'
                : (parts.isEmpty ? l10n.noThresholds : parts.join(' · ')),
            style: AppText.secondary(context)
                .copyWith(fontSize: 13, color: color),
          ),
        ),
      ],
    );
    if (item.source != WatchSource.wishlist) return thresholds;
    final muted = AppColors.textSecondary.resolveFrom(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        thresholds,
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(CupertinoIcons.gift, size: 14, color: muted),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                context.l10n.wishlistBadge,
                style: AppText.secondary(context)
                    .copyWith(fontSize: 12, color: muted),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
