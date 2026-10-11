import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../../../core/format/formatters.dart';
import '../../../core/widgets/glass_screen.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/paged_games_view.dart';
import '../../../core/widgets/settings_button.dart';
import '../../../core/widgets/state_views.dart';
import 'discounts_providers.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/genre_chip.dart';
import 'sale_banner.dart';

/// «Скидки сейчас»: сортировка, минимальная скидка и максимальная цена.
class DiscountsScreen extends ConsumerWidget {
  const DiscountsScreen({super.key});

  static const _sorts = [
    DiscountSort.discount,
    DiscountSort.price,
    DiscountSort.players,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final filter = ref.watch(discountsFilterProvider);
    final filters = ref.read(discountsFilterProvider.notifier);
    final notifier = ref.read(discountsListProvider.notifier);

    return GlassScreen(
      title: l10n.discountsTitle,
      actions: const [SettingsButton()],
      body: PagedGamesView(
        view: ref.watch(discountsListProvider),
        onRetry: notifier.retry,
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        empty: MessageView(
          icon: CupertinoIcons.tag,
          message: l10n.discountsEmpty,
        ),
        header: [
          const SaleBanner(),
          AppSegmentedControl(
            labels: [l10n.sortDiscount, l10n.sortPrice, l10n.sortPlayers],
            selectedIndex: _sorts.indexOf(filter.sort),
            onSelected: (i) => filters.setSort(_sorts[i]),
          ),
          FilterRow(
            children: [
              GenreChip(genre: filter.genre, onSelected: filters.setGenre),
              for (final pct in discountSteps.skip(1))
                AppChip(
                  label: l10n.minDiscountChip(pct),
                  selected: filter.minDiscountPct == pct,
                  // Повторное нажатие снимает фильтр (любая скидка).
                  onTap: () => filters.setMinDiscount(
                    filter.minDiscountPct == pct ? discountSteps.first : pct,
                  ),
                ),
              for (final tenge in maxPriceSteps)
                AppChip(
                  label: l10n.maxPriceChip(
                    formatPrice(tenge * minorUnitsPerMajor, 'KZT', locale),
                  ),
                  selected: filter.maxPrice == tenge * minorUnitsPerMajor,
                  onTap: () => filters.toggleMaxPrice(tenge),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
