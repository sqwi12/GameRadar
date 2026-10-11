import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/format/formatters.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Ссылка, открывающая игру в GameRadar: `gameradar://app/game/730`.
/// Android передаёт её путь (`/game/730`) в навигацию приложения.
Uri gameDeepLink(int appId) =>
    Uri(scheme: 'gameradar', host: 'app', path: '/game/$appId');

/// Текст «поделиться»: название, цена (со скидкой) и страница в Steam.
/// Это только текст для собеседника — само приложение к Steam не ходит.
String shareGameText(AppLocalizations l10n, GameDetails game, String locale) {
  final p = game.price;
  final price = switch (p) {
    _ when game.isFree => l10n.priceFree,
    GamePrice(
      isAvailable: true,
      finalPrice: final price?,
      currency: final currency?,
    ) =>
      p.isDiscounted
          ? '${formatPrice(price, currency, locale)} '
                '(${l10n.discountBadge(p.discountPct)})'
          : formatPrice(price, currency, locale),
    _ => null,
  };
  return [
    price == null ? game.name : '${game.name} — $price',
    game.storeUrl.toString(),
    l10n.shareVia,
  ].join('\n');
}

Future<void> shareGame(
  AppLocalizations l10n,
  GameDetails game,
  String locale,
) => SharePlus.instance.share(
  ShareParams(text: shareGameText(l10n, game, locale), subject: game.name),
);
