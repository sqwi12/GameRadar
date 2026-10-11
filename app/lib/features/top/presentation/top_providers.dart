import 'dart:async';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache/cached_resource.dart';
import '../../../core/cache/codecs.dart';
import '../../../core/cache/resource_state.dart';
import '../../../core/providers.dart';
import '../data/top_repository.dart';

part 'top_providers.g.dart';

const _pageSize = 50;

@Riverpod(keepAlive: true)
TopRepository topRepository(Ref ref) =>
    TopRepository(ref.watch(apiClientProvider));

/// Фильтры топа: сортировка и «только со скидкой».
@Riverpod(keepAlive: true)
class TopFilter extends _$TopFilter {
  @override
  TopQuery build() => const TopQuery(limit: _pageSize);

  void setSort(TopSort sort) => state = state.copyWith(sort: sort);

  void toggleDiscounted() =>
      state = state.copyWith(onlyDiscounted: !state.onlyDiscounted);
}

/// Список топа: первая страница из кэша, следующие — при прокрутке.
@riverpod
class TopList extends _$TopList {
  PagedBinding<GameSummary>? _binding;

  @override
  PagedView<GameSummary> build() {
    final query = ref.watch(topFilterProvider);
    final repository = ref.watch(topRepositoryProvider);
    final binding = _binding = PagedBinding(
      CachedResource<Paginated<GameSummary>>(
        db: ref.watch(appDatabaseProvider),
        key:
            'top:${query.region}:${query.sort.wireName}:${query.onlyDiscounted}',
        fetch: () => repository.fetch(query),
        decode: decodeGamePage,
        encode: encodeGamePage,
        // Онлайн топа на сервере обновляется раз в 25–30 минут.
        staleAfter: const Duration(minutes: 10),
      ),
      fetchPage: (offset) => repository.fetch(query.copyWith(offset: offset)),
      read: () => state,
      write: (v) => state = v,
    );
    ref.onDispose(binding.dispose);
    // Состояние ещё не задано: запуск после возврата из build.
    scheduleMicrotask(binding.start);
    return const PagedView();
  }

  Future<RefreshResult> refresh() => _binding!.refreshByUser();

  Future<void> retry() => _binding!.retry();

  Future<void> loadMore() => _binding!.loadMore();
}
