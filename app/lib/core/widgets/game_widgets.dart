import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../format/formatters.dart';
import '../network/api_urls.dart';
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.cardBorder.resolveFrom(context),
            width: 0.5,
          ),
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
    final resolved = resolveImageUrl(url);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: 460 / 215,
          child: resolved == null
              ? placeholder
              : CachedNetworkImage(
                  imageUrl: resolved,
                  fit: BoxFit.cover,
                  // Декодируем в размере показа: меньше памяти и работы GPU.
                  memCacheWidth: width == null
                      ? null
                      : (width! * MediaQuery.devicePixelRatioOf(context))
                            .round(),
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
      color: AppColors.discountTint.resolveFrom(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(large ? 9 : 6),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 9 : 6,
        vertical: large ? 3 : 1.5,
      ),
      child: Text(
        context.l10n.discountBadge(percent),
        style: TextStyle(
          color: AppColors.discount.resolveFrom(context),
          fontSize: large ? 16 : 12.5,
          fontWeight: FontWeight.w700,
          fontFeatures: AppText.tabular,
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
    this.alignEnd = false,
    super.key,
  });

  final GamePrice? price;
  final bool isFree;
  final bool large;

  /// Прижать к правому краю (в строке списка).
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final p = price;
    final main = AppText.title(context).copyWith(
      fontSize: large ? 26 : 15,
      fontWeight: large ? FontWeight.w700 : FontWeight.w600,
      letterSpacing: large ? -0.6 : -0.2,
      fontFeatures: AppText.tabular,
    );
    final muted = AppText.secondary(context)
        .copyWith(fontSize: large ? 15 : 12.5, fontFeatures: AppText.tabular);

    if (p == null) {
      return Text(
        isFree ? l10n.priceFree : l10n.priceUnknown,
        style: isFree ? main : muted,
        textAlign: alignEnd ? TextAlign.end : null,
      );
    }
    if (!p.isAvailable || p.finalPrice == null || p.currency == null) {
      return Text(
        isFree ? l10n.priceFree : l10n.priceUnavailable,
        style: isFree ? main : muted,
        textAlign: alignEnd ? TextAlign.end : null,
      );
    }
    final current = formatPrice(p.finalPrice!, p.currency!, locale);
    final currentText = Text(
      current,
      style: main.copyWith(
        color: p.isDiscounted ? AppColors.discount.resolveFrom(context) : null,
      ),
    );
    if (alignEnd) {
      // В строке списка — всегда одинаково: скидка и старая цена сверху,
      // итоговая цена под ними, всё по правому краю.
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (p.isDiscounted) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (p.initialPrice != null) ...[
                  Text(
                    formatPrice(p.initialPrice!, p.currency!, locale),
                    style: muted.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                DiscountBadge(percent: p.discountPct),
              ],
            ),
            const SizedBox(height: 3),
          ],
          currentText,
        ],
      );
    }
    return Wrap(
      spacing: large ? 10 : 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (p.isDiscounted) DiscountBadge(percent: p.discountPct, large: large),
        if (p.isDiscounted && p.initialPrice != null)
          Text(
            formatPrice(p.initialPrice!, p.currency!, locale),
            style: muted.copyWith(decoration: TextDecoration.lineThrough),
          ),
        currentText,
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
        Icon(CupertinoIcons.person_2_fill, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          formatPlayers(
            players,
            Localizations.localeOf(context).toLanguageTag(),
          ),
          style: AppText.secondary(context).copyWith(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFeatures: AppText.tabular,
          ),
        ),
      ],
    );
  }
}

/// Строка списка игр: обложка (с местом в топе), название, онлайн и цена.
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

  /// Плашка в углу обложки, например место в топе.
  final Widget? trailing;

  /// Под строкой с ценой, например пороги отслеживания.
  final Widget? footer;

  static const _imageWidth = 120.0;

  @override
  Widget build(BuildContext context) {
    // Цены ещё нет (игру никто не открывал) — не пишем «загружается».
    final hasPrice = game.price != null || game.isFree;
    final hasMeta = hasPrice || game.currentPlayers != null;
    return AppSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  GameImage(
                    url: game.headerImageUrl,
                    width: _imageWidth,
                    radius: 10,
                  ),
                  if (trailing != null)
                    Positioned(left: 5, top: 5, child: trailing!),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ConstrainedBox(
                  // Не ниже обложки: название сверху, онлайн и цена снизу.
                  constraints: const BoxConstraints(
                    minHeight: _imageWidth * 215 / 460,
                  ),
                  // Без IntrinsicHeight (двойное измерение каждой строки):
                  // при неограниченной высоте Column берёт высоту детей, но
                  // не меньше minHeight, а spaceBetween прижимает цену вниз.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        game.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.title(context)
                            .copyWith(fontSize: 15.5, height: 1.2),
                      ),
                      if (hasMeta) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (game.currentPlayers != null)
                                PlayersLabel(players: game.currentPlayers!),
                              const SizedBox(width: 8),
                              Expanded(
                                child: hasPrice
                                    ? PriceTag(
                                        price: game.price,
                                        isFree: game.isFree,
                                        alignEnd: true,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (footer != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: footer!,
            ),
          ],
        ],
      ),
    );
  }
}

/// Место в топе: плашка «#1» в углу обложки, у первой тройки — акцентная.
class RankLabel extends StatelessWidget {
  const RankLabel({required this.rank, super.key});

  final int rank;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: AppColors.overlayChip,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        '#$rank',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFeatures: AppText.tabular,
          // Обложка тёмная в любой теме — цвета из тёмной палитры.
          color: rank <= 3
              ? AppColors.accent.darkColor
              : const Color(0xFFF2F5FA),
        ),
      ),
    ),
  );
}
