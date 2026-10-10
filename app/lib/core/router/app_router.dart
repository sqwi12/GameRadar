import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/discounts/presentation/discounts_screen.dart';
import '../../features/game/presentation/game_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/top/presentation/top_screen.dart';
import '../../features/watchlist/presentation/watchlist_screen.dart';
import '../widgets/l10n.dart';
import 'routes.dart';

part 'app_router.g.dart';

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
        StatefulShellBranch(
          routes: [
            GoRoute(path: Routes.top, builder: (_, _) => const TopScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.discounts,
              builder: (_, _) => const DiscountsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.search,
              builder: (_, _) => const SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.watchlist,
              builder: (_, _) => const WatchlistScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(path: Routes.settings, builder: (_, _) => const SettingsScreen()),
    GoRoute(
      path: '/game/:id',
      builder: (_, state) =>
          GameScreen(appId: int.tryParse(state.pathParameters['id']!) ?? 0),
    ),
  ],
);

/// Каркас с нижней навигацией.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        // Повторное нажатие на активную вкладку возвращает к её началу.
        onDestinationSelected: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.leaderboard_outlined),
            selectedIcon: const Icon(Icons.leaderboard),
            label: l10n.tabTop,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_offer_outlined),
            selectedIcon: const Icon(Icons.local_offer),
            label: l10n.tabDiscounts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: l10n.tabSearch,
          ),
          NavigationDestination(
            icon: const Icon(Icons.radar_outlined),
            selectedIcon: const Icon(Icons.radar),
            label: l10n.tabWatchlist,
          ),
        ],
      ),
    );
  }
}
