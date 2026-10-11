import 'dart:async';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache/cached_resource.dart';
import '../../../core/cache/resource_state.dart';
import '../../../core/providers.dart';
import '../data/watchlist_repository.dart';

part 'watchlist_providers.g.dart';

@Riverpod(keepAlive: true)
WatchlistRepository watchlistRepository(Ref ref) =>
    WatchlistRepository(ref.watch(apiClientProvider));

/// Список отслеживания. Живёт всё время работы приложения: по нему экран
/// игры показывает «Отслеживается».
@Riverpod(keepAlive: true)
class Watchlist extends _$Watchlist {
  ResourceBinding<List<WatchlistItem>>? _binding;

  @override
  ResourceView<List<WatchlistItem>> build() {
    final repository = ref.watch(watchlistRepositoryProvider);
    final binding = _binding = ResourceBinding(
      CachedResource<List<WatchlistItem>>(
        db: ref.watch(appDatabaseProvider),
        key: 'watchlist',
        fetch: repository.list,
        decode: (json) => [
          for (final item in json! as List)
            WatchlistItem.fromJson(item as Map<String, Object?>),
        ],
        encode: (items) => [for (final i in items) i.toJson()],
        staleAfter: const Duration(minutes: 5),
      ),
      read: () => state,
      write: (v) => state = v,
    );
    ref.onDispose(binding.dispose);
    scheduleMicrotask(binding.start);
    return const ResourceView();
  }

  Future<RefreshResult> refresh() => _binding!.refreshByUser();

  Future<void> retry() => _binding!.retry();

  /// Добавляет игру или меняет пороги, затем перезагружает список.
  /// Ошибки (сеть, лимит списка) пробрасываются экрану.
  Future<WatchlistItem> save(int appId, WatchlistUpsertRequest request) async {
    final item = await ref
        .read(watchlistRepositoryProvider)
        .upsert(appId, request);
    unawaited(_binding!.reload());
    return item;
  }

  Future<void> remove(int appId) async {
    await ref.read(watchlistRepositoryProvider).remove(appId);
    unawaited(_binding!.reload());
  }
}

/// Запись списка для игры или null, если игра не отслеживается.
@riverpod
WatchlistItem? watchItem(Ref ref, int appId) => ref
    .watch(watchlistProvider)
    .data
    ?.where((i) => i.game.appId == appId)
    .firstOrNull;
