import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../format/formatters.dart';
import '../theme/app_theme.dart';
import 'l10n.dart';

/// Подложка карточки контента (не стекло — см. AppColors.card).
class AppSurface extends StatelessWidget {
  const AppSurface({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final box = DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.card.resolveFrom(context),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: AppColors.cardBorder.resolveFrom(context)),
        ),
      ),
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return box;
    return _Pressable(onTap: onTap!, child: box);
  }
}

/// Лёгкое «вдавливание» при нажатии, как у ячеек iOS.
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
      scale: _down ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      child: AnimatedOpacity(
        opacity: _down ? 0.8 : 1,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    ),
  );
}

/// Обложка игры (header 460×215) с заглушкой.
class GameImage extends StatelessWidget {
  const GameImage({required this.url, this.width, this.radius = 12, super.key});

  final String? url;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: AppColors.imagePlaceholder.resolveFrom(context),
      child: Center(
        child: Icon(
          CupertinoIcons.game_controller,
          color: AppColors.textSecondary.resolveFrom(context),
        ),
      ),
    );
    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: 460 / 215,
          child: url == null
              ? placeholder
              : CachedNetworkImage(
                  imageUrl: url!,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 200),
                  placeholder: (_, _) => placeholder,
                  errorWidget: (_, _, _) => placeholder,
                ),
        ),
      ),
    );
  }
}

/// Бейдж скидки «−75%».
class DiscountBadge extends StatelessWidget {
  const DiscountBadge({required this.percent, this.large = false, super.key});

  final int percent;
  final bool large;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: AppColors.discount.resolveFrom(context),
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(large ? 10 : 7),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 10 : 6,
        vertical: large ? 4 : 2,
      ),
      child: Text(
        context.l10n.discountBadge(percent),
        style: TextStyle(
          color: CupertinoColors.white,
          fontSize: large ? 17 : 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

/// Цена: итоговая, зачёркнутая исходная при скидке, «Бесплатно» или «Нет в продаже».
class PriceTag extends StatelessWidget {
  const PriceTag({
    required this.price,
    this.isFree = false,
    this.large = false,
    super.key,
  });

  final GamePrice? price;
  final bool isFree;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final p = price;
    final main = AppText.title(context).copyWith(fontSize: large ? 26 : 16);
    final muted = AppText.secondary(context)
        .copyWith(fontSize: large ? 15 : 13);

    if (p == null) {
      return Text(
        isFree ? l10n.priceFree : l10n.priceUnknown,
        style: isFree ? main : muted,
      );
    }
    if (!p.isAvailable || p.finalPrice == null || p.currency == null) {
      return Text(
        isFree ? l10n.priceFree : l10n.priceUnavailable,
        style: isFree ? main : muted,
      );
    }
    final current = formatPrice(p.finalPrice!, p.currency!, locale);
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (p.isDiscounted) DiscountBadge(percent: p.discountPct, large: large),
        if (p.isDiscounted && p.initialPrice != null)
          Text(
            formatPrice(p.initialPrice!, p.currency!, locale),
            style: muted.copyWith(decoration: TextDecoration.lineThrough),
          ),
        Text(
          current,
          style: main.copyWith(
            color: p.isDiscounted
                ? AppColors.discount.resolveFrom(context)
                : null,
          ),
        ),
      ],
    );
  }
}

/// «👥 826 тыс.» — онлайн игроков.
class PlayersLabel extends StatelessWidget {
  const PlayersLabel({required this.players, super.key});

  final int players;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.online.resolveFrom(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(CupertinoIcons.person_2_fill, size: 15, color: color),
        const SizedBox(width: 4),
        Text(
          formatPlayers(
            players,
            Localizations.localeOf(context).toLanguageTag(),
          ),
          style: AppText.secondary(context)
              .copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Строка списка игр: обложка, название, онлайн, цена.
class GameTile extends StatelessWidget {
  const GameTile({
    required this.game,
    required this.onTap,
    this.trailing,
    this.footer,
    super.key,
  });

  final GameSummary game;
  final VoidCallback onTap;

  /// Справа от названия, например место в топе.
  final Widget? trailing;

  /// Под ценой, например пороги отслеживания.
  final Widget? footer;

  @override
  Widget build(BuildContext context) => AppSurface(
    onTap: onTap,
    padding: const EdgeInsets.all(10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameImage(url: game.headerImageUrl, width: 128),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      game.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.title(context).copyWith(fontSize: 15),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 6),
                    trailing!,
                  ],
                ],
              ),
              const SizedBox(height: 6),
              if (game.currentPlayers != null) ...[
                PlayersLabel(players: game.currentPlayers!),
                const SizedBox(height: 6),
              ],
              // Цены ещё нет (игру никто не открывал) — не пишем «загружается».
              if (game.price != null || game.isFree)
                PriceTag(price: game.price, isFree: game.isFree),
              if (footer != null) ...[const SizedBox(height: 6), footer!],
            ],
          ),
        ),
      ],
    ),
  );
}

/// Место в топе: «#1».
class RankLabel extends StatelessWidget {
  const RankLabel({required this.rank, super.key});

  final int rank;

  @override
  Widget build(BuildContext context) => Text(
    '#$rank',
    style: AppText.title(context).copyWith(
      fontSize: 15,
      color: rank <= 3
          ? AppColors.accent.resolveFrom(context)
          : AppColors.textSecondary.resolveFrom(context),
    ),
  );
}
