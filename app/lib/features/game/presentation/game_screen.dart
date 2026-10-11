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
import '../../watchlist/presentation/watch_sheet.dart';
import '../../watchlist/presentation/watchlist_providers.dart';
import 'game_providers.dart';
import 'game_charts_card.dart';

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
      // Компактная шапка: обложка слева, название справа. Так цена и график
      // помещаются на первый экран без прокрутки.
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GameImage(url: game.headerImageUrl, width: 150, radius: 14),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.largeTitle(context)
                      .copyWith(fontSize: 20, height: 1.15),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.secondary(context).copyWith(fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
      const SizedBox(height: 12),
      // Онлайн и история цены — один график с переключателем.
      GameChartsCard(game: game),
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
