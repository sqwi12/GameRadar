import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/game_widgets.dart';
import '../../../core/widgets/glass_screen.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/resource_scroll_view.dart';
import '../../../core/widgets/settings_button.dart';
import '../../../core/widgets/state_views.dart';
import '../../game/presentation/game_screen.dart';
import 'watchlist_providers.dart';

/// Отслеживаемые игры: цена сейчас, пороги и «Цель достигнута».
/// Игры, у которых цель достигнута, — наверху.
class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final notifier = ref.read(watchlistProvider.notifier);

    return GlassScreen(
      title: l10n.watchlistTitle,
      actions: const [SettingsButton()],
      body: ResourceScrollView<List<WatchlistItem>>(
        view: ref.watch(watchlistProvider),
        onRetry: notifier.retry,
        onRefresh: notifier.refresh,
        isEmpty: (items) => items.isEmpty,
        empty: MessageView(
          icon: CupertinoIcons.scope,
          message: l10n.watchlistEmpty,
        ),
        slivers: (context, items) {
          final sorted = [...items]
            ..sort((a, b) {
              final reached =
                  (b.isTargetReached ? 1 : 0) - (a.isTargetReached ? 1 : 0);
              return reached != 0
                  ? reached
                  : b.createdAt.compareTo(a.createdAt);
            });
          return [
            separatedList(
              items: sorted,
              builder: (context, item, _) => GameTile(
                game: item.game,
                footer: ThresholdsLabel(item: item),
                onTap: () => context.push(Routes.game(item.game.appId)),
              ),
            ),
          ];
        },
      ),
    );
  }
}
