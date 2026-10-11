import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../core/format/formatters.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/game_widgets.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/gen/app_localizations.dart';
import 'game_providers.dart';

/// Лист «Цены в других регионах»: местная цена, она же в тенге по курсу
/// НБК и разница с ценой в Казахстане. Дешевле — выше.
Future<void> showRegionalPrices(BuildContext context, int appId) =>
    GlassModalSheet.show<void>(
      context: context,
      halfSize: 0.75,
      builder: (_) => _RegionalPricesSheet(appId: appId),
    );

class _RegionalPricesSheet extends ConsumerWidget {
  const _RegionalPricesSheet({required this.appId});

  final int appId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final prices = ref.watch(regionalPricesProvider(appId));
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.regionsTitle,
            style: AppText.largeTitle(context).copyWith(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(l10n.regionsIntro, style: AppText.secondary(context)),
          const SizedBox(height: 16),
          switch (prices) {
            AsyncData(:final value) when value.length > 1 => _List(
              prices: value,
            ),
            AsyncData() => Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.regionsEmpty,
                textAlign: TextAlign.center,
                style: AppText.secondary(context),
              ),
            ),
            AsyncError(:final error) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                describeError(l10n, error),
                textAlign: TextAlign.center,
                style: AppText.secondary(context),
              ),
            ),
            _ => const SizedBox(height: 160, child: LoadingView()),
          },
          const SizedBox(height: 12),
          Text(
            l10n.regionsFootnote,
            style: AppText.secondary(context).copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.prices});

  final List<RegionalPrice> prices;

  @override
  Widget build(BuildContext context) {
    final home = prices
        .where((p) => p.price.region == Regions.defaultRegion)
        .firstOrNull
        ?.finalPriceKzt;
    return AppSurface(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < prices.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.only(left: 56),
                child: SizedBox(
                  height: 0.5,
                  width: double.infinity,
                  child: ColoredBox(
                    color: AppColors.controlBorder.resolveFrom(context),
                  ),
                ),
              ),
            _Row(price: prices[i], home: home),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.price, required this.home});

  final RegionalPrice price;

  /// Цена в Казахстане (тенге) — для разницы в процентах.
  final int? home;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final p = price.price;
    final kzt = price.finalPriceKzt;
    final isHome = p.region == Regions.defaultRegion;
    final diff = !isHome && kzt != null && home != null && home! > 0
        ? ((kzt - home!) * 100 / home!).round()
        : null;
    final cheaper = diff != null && diff < 0;
    final muted = AppText.secondary(context).copyWith(fontSize: 12.5);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              regionFlag(p.region),
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  regionName(l10n, p.region),
                  style: AppText.body(context).copyWith(
                    fontWeight: isHome ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    formatPrice(p.finalPrice!, p.currency!, locale),
                    if (p.isDiscounted) l10n.discountBadge(p.discountPct),
                  ].join('  '),
                  style: muted.copyWith(fontFeatures: AppText.tabular),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                kzt == null
                    ? '—'
                    : isHome
                    ? formatPrice(kzt, 'KZT', locale)
                    // Пересчёт по курсу — приблизительный, до целых тенге.
                    : '≈ ${formatPrice((kzt / minorUnitsPerMajor).round() * minorUnitsPerMajor, 'KZT', locale)}',
                style: AppText.title(context)
                    .copyWith(fontSize: 15.5, fontFeatures: AppText.tabular),
              ),
              if (diff != null)
                Text(
                  diff == 0
                      ? l10n.regionsSame
                      : '${diff > 0 ? '+' : '−'}${diff.abs()}%',
                  style: muted.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cheaper
                        ? AppColors.discount.resolveFrom(context)
                        : AppColors.textSecondary.resolveFrom(context),
                  ),
                )
              else if (isHome)
                Text(l10n.regionsHome, style: muted),
            ],
          ),
        ],
      ),
    );
  }
}

/// Флаг страны по коду региона (эмодзи из двух букв).
String regionFlag(String region) => String.fromCharCodes([
  for (final c in region.toUpperCase().codeUnits) 0x1F1E6 + c - 0x41,
]);

/// Название региона на языке приложения.
String regionName(AppLocalizations l10n, String region) => switch (region) {
  'kz' => l10n.regionKz,
  'us' => l10n.regionUs,
  'de' => l10n.regionDe,
  'tr' => l10n.regionTr,
  'ar' => l10n.regionAr,
  'ru' => l10n.regionRu,
  'in' => l10n.regionIn,
  _ => region.toUpperCase(),
};
