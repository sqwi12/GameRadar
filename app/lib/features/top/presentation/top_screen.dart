import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../core/widgets/glass_screen.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/paged_games_view.dart';
import '../../../core/widgets/settings_button.dart';
import '../../../core/widgets/state_views.dart';
import 'top_providers.dart';

/// «Топ по онлайну» с сортировкой и фильтром «Со скидкой».
class TopScreen extends ConsumerWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(topFilterProvider);
    final notifier = ref.read(topListProvider.notifier);

    return GlassScreen(
      title: l10n.topTitle,
      actions: const [SettingsButton()],
      body: PagedGamesView(
        view: ref.watch(topListProvider),
        onRetry: notifier.retry,
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        showRank: filter.sort == TopSort.current,
        empty: MessageView(
          icon: CupertinoIcons.chart_bar_alt_fill,
          message: l10n.topEmpty,
        ),
        header: [
          GlassSegmentedControl(
            segments: [
              GlassSegment(label: l10n.topSortCurrent),
              GlassSegment(label: l10n.topSortPeak),
            ],
            selectedIndex: filter.sort == TopSort.current ? 0 : 1,
            onSegmentSelected: (i) => ref
                .read(topFilterProvider.notifier)
                .setSort(i == 0 ? TopSort.current : TopSort.peak24h),
            useOwnLayer: true,
          ),
          FilterRow(
            children: [
              GlassChip(
                label: l10n.filterDiscounted,
                icon: const Icon(CupertinoIcons.tag_fill),
                selected: filter.onlyDiscounted,
                onTap: ref.read(topFilterProvider.notifier).toggleDiscounted,
                useOwnLayer: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
