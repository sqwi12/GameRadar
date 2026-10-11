import 'package:flutter/cupertino.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:go_router/go_router.dart';

import '../cache/cached_resource.dart';
import '../cache/resource_state.dart';
import '../router/routes.dart';
import 'game_widgets.dart';
import 'resource_scroll_view.dart';

/// Постраничный список игр: кэш первой страницы, догрузка у конца списка.
class PagedGamesView extends StatelessWidget {
  const PagedGamesView({
    required this.view,
    required this.onRetry,
    required this.onRefresh,
    required this.onLoadMore,
    required this.empty,
    this.header = const [],
    this.showRank = false,
    super.key,
  });

  final PagedView<GameSummary> view;
  final VoidCallback onRetry;
  final Future<RefreshResult> Function() onRefresh;
  final VoidCallback onLoadMore;
  final Widget empty;
  final List<Widget> header;
  final bool showRank;

  @override
  Widget build(BuildContext context) {
    final items = view.items;
    return NotificationListener<ScrollNotification>(
      // Догружаем следующую страницу заранее, за ~2 экрана до конца.
      onNotification: (n) {
        if (n.metrics.extentAfter < n.metrics.viewportDimension * 2) {
          onLoadMore();
        }
        return false;
      },
      child: ResourceScrollView<Paginated<GameSummary>>(
        view: view.first,
        onRetry: onRetry,
        onRefresh: onRefresh,
        header: header,
        isEmpty: (page) => page.items.isEmpty,
        empty: empty,
        slivers: (context, _) => [
          separatedList(
            items: items,
            builder: (context, game, _) => GameTile(
              game: game,
              trailing: showRank && game.topRank != null
                  ? RankLabel(rank: game.topRank!)
                  : null,
              onTap: () => context.push(Routes.game(game.appId)),
            ),
          ),
          if (view.hasMore || view.loadingMore || view.moreError != null)
            SliverToBoxAdapter(
              child: LoadMoreFooter(
                loading: view.loadingMore,
                error: view.moreError,
                onRetry: onLoadMore,
              ),
            ),
        ],
      ),
    );
  }
}

/// Горизонтальный ряд фильтров с прокруткой.
class FilterRow extends StatelessWidget {
  const FilterRow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    clipBehavior: Clip.none,
    child: Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          children[i],
        ],
      ],
    ),
  );
}
