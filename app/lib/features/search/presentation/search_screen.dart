import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/game_widgets.dart';
import '../../../core/widgets/glass_screen.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/widgets/resource_scroll_view.dart';
import '../../../core/widgets/settings_button.dart';
import '../../../core/widgets/state_views.dart';
import 'search_providers.dart';

/// Поиск игры по названию среди всего каталога.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  /// Пока идёт новый запрос, показываются прошлые результаты, чтобы список
  /// не мигал индикатором на каждое нажатие клавиши.
  List<Widget> _results(
    BuildContext context,
    String text,
    AsyncValue<List<GameSummary>?> results,
    Widget Function(Widget) fill,
    EdgeInsets padding,
  ) {
    final l10n = context.l10n;
    final games = results.value;
    if (text.isEmpty) {
      return [
        fill(
          MessageView(icon: CupertinoIcons.search, message: l10n.searchHint),
        ),
      ];
    }
    if (text.length < SearchQuery.minLength) {
      return [
        fill(
          MessageView(
            icon: CupertinoIcons.textformat,
            message: l10n.searchTooShort,
          ),
        ),
      ];
    }
    if (results.hasError && !results.isLoading) {
      return [
        fill(
          ErrorView(
            error: results.error!,
            onRetry: () => ref.invalidate(searchResultsProvider),
          ),
        ),
      ];
    }
    if (games == null || (games.isEmpty && results.isLoading)) {
      return [fill(const LoadingView())];
    }
    if (games.isEmpty) {
      return [
        fill(
          MessageView(
            icon: CupertinoIcons.question_circle,
            message: l10n.searchNoResults(text),
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: EdgeInsets.fromLTRB(
          padding.left,
          0,
          padding.right,
          padding.bottom,
        ),
        sliver: separatedList(
          items: games,
          builder: (context, game, _) => GameTile(
            game: game,
            onTap: () => context.push(Routes.game(game.appId)),
          ),
        ),
      ),
    ];
  }

  late final _controller = TextEditingController(
    text: ref.read(searchTextProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = ref.watch(searchTextProvider).trim();
    final results = ref.watch(searchResultsProvider);
    final padding = GlassScreen.contentPadding(context);

    Widget fill(Widget child) => SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: padding.bottom),
        child: child,
      ),
    );

    return GlassScreen(
      title: l10n.searchTitle,
      actions: const [SettingsButton()],
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              padding.left,
              padding.top,
              padding.right,
              16,
            ),
            sliver: SliverToBoxAdapter(
              child: GlassSearchBar(
                controller: _controller,
                placeholder: l10n.searchPlaceholder,
                onChanged: ref.read(searchTextProvider.notifier).set,
                useOwnLayer: true,
              ),
            ),
          ),
          ..._results(context, text, results, fill, padding),
        ],
      ),
    );
  }
}
