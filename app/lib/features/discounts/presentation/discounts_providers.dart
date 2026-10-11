import 'dart:async';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache/cached_resource.dart';
import '../../../core/cache/codecs.dart';
import '../../../core/cache/resource_state.dart';
import '../../../core/providers.dart';
import '../data/discounts_repository.dart';

part 'discounts_providers.g.dart';

const _pageSize = 50;

/// Варианты фильтров на экране (минимальная скидка, %; максимальная цена, ₸).
const discountSteps = [1, 25, 50, 75];
const maxPriceSteps = [2500, 5000, 10000];

@Riverpod(keepAlive: true)
DiscountsRepository discountsRepository(Ref ref) =>
    DiscountsRepository(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
class DiscountsFilter extends _$DiscountsFilter {
  @override
  DiscountsQuery build() => const DiscountsQuery(limit: _pageSize);

  void setSort(DiscountSort sort) => state = state.copyWith(sort: sort);

  void setMinDiscount(int percent) =>
      state = state.copyWith(minDiscountPct: percent);

  /// [tenge] — в основных единицах; повторный выбор того же значения снимает фильтр.
  void toggleMaxPrice(int tenge) {
    final minor = tenge * minorUnitsPerMajor;
    state = state.copyWith(maxPrice: state.maxPrice == minor ? null : minor);
  }
}

@riverpod
class DiscountsList extends _$DiscountsList {
  PagedBinding<GameSummary>? _binding;

  @override
  PagedView<GameSummary> build() {
    final query = ref.watch(discountsFilterProvider);
    final repository = ref.watch(discountsRepositoryProvider);
    final binding = _binding = PagedBinding(
      CachedResource<Paginated<GameSummary>>(
        db: ref.watch(appDatabaseProvider),
        key:
            'discounts:${query.region}:${query.sort.wireName}:'
            '${query.minDiscountPct}:${query.maxPrice}',
        fetch: () => repository.fetch(query),
        decode: decodeGamePage,
        encode: encodeGamePage,
        staleAfter: const Duration(minutes: 15),
      ),
      fetchPage: (offset) => repository.fetch(query.copyWith(offset: offset)),
      read: () => state,
      write: (v) => state = v,
    );
    ref.onDispose(binding.dispose);
    scheduleMicrotask(binding.start);
    return const PagedView();
  }

  Future<RefreshResult> refresh() => _binding!.refreshByUser();

  Future<void> retry() => _binding!.retry();

  Future<void> loadMore() => _binding!.loadMore();
}
