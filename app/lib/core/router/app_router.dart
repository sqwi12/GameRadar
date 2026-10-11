import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/discounts/presentation/discounts_screen.dart';
import '../../features/game/presentation/game_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/top/presentation/top_screen.dart';
import '../../features/watchlist/presentation/watchlist_screen.dart';
import '../theme/app_background.dart';
import '../theme/app_theme.dart';
import '../widgets/l10n.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// Страница с iOS-переходом (свайп назад от края экрана).
Page<void> _page(GoRouterState state, Widget child) =>
    CupertinoPage<void>(key: state.pageKey, child: child);

/// Навигация: четыре вкладки с собственным стеком у каждой
/// (StatefulShellRoute сохраняет прокрутку и состояние при переключении),
/// а настройки и экран игры открываются поверх вкладок.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(
  initialLocation: Routes.top,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => HomeShell(shell: shell),
      branches: [
        for (final (path, screen) in [
          (Routes.top, const TopScreen()),
          (Routes.discounts, const DiscountsScreen()),
          (Routes.search, const SearchScreen()),
          (Routes.watchlist, const WatchlistScreen()),
        ])
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: path,
                pageBuilder: (_, state) => _page(state, screen),
              ),
            ],
          ),
      ],
    ),
    GoRoute(
      path: Routes.settings,
      pageBuilder: (_, state) =>
          _page(state, const _Backdrop(child: SettingsScreen())),
    ),
    GoRoute(
      path: '/game/:id',
      pageBuilder: (_, state) => _page(
        state,
        _Backdrop(
          child: GameScreen(
            appId: int.tryParse(state.pathParameters['id']!) ?? 0,
          ),
        ),
      ),
    ),
  ],
);

/// Фон для экранов поверх вкладок (у вкладок фон рисует HomeShell).
class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Stack(fit: StackFit.expand, children: [const AppBackground(), child]);
}

/// Каркас вкладок: общий фон и плавающая стеклянная панель вкладок.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = AppColors.accent.resolveFrom(context);
    final unselected = AppColors.textSecondary.resolveFrom(context);
    return GlassScaffold(
      background: const AppBackground(),
      body: shell,
      bottomBar: GlassTabBar.bottom(
        selectedIndex: shell.currentIndex,
        // Повторное нажатие на активную вкладку возвращает к её началу.
        onTabSelected: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        selectedIconColor: selected,
        selectedLabelColor: selected,
        unselectedIconColor: unselected,
        unselectedLabelColor: unselected,
        tabs: [
          GlassTab(
            icon: const Icon(CupertinoIcons.chart_bar_alt_fill),
            label: l10n.tabTop,
          ),
          GlassTab(
            icon: const Icon(CupertinoIcons.tag_fill),
            label: l10n.tabDiscounts,
          ),
          GlassTab(
            icon: const Icon(CupertinoIcons.search),
            label: l10n.tabSearch,
          ),
          GlassTab(
            icon: const Icon(CupertinoIcons.scope),
            label: l10n.tabWatchlist,
          ),
        ],
      ),
    );
  }
}
