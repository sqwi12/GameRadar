import 'dart:async';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache/cached_resource.dart';
import '../../../core/cache/resource_state.dart';
import '../../../core/providers.dart';
import '../../settings/presentation/settings_providers.dart';
import '../data/game_repository.dart';

part 'game_providers.g.dart';

@Riverpod(keepAlive: true)
GameRepository gameRepository(Ref ref) =>
    GameRepository(ref.watch(apiClientProvider));

/// Данные экрана игры (кэш + обновление).
@riverpod
class GameDetailsState extends _$GameDetailsState {
  ResourceBinding<GameDetails>? _binding;

  @override
  ResourceView<GameDetails> build(int appId) {
    const region = Regions.defaultRegion;
    final repository = ref.watch(gameRepositoryProvider);
    final binding = _binding = ResourceBinding(
      CachedResource<GameDetails>(
        db: ref.watch(appDatabaseProvider),
        key: 'game:$appId:$region',
        fetch: () => repository.details(appId, region),
        decode: (json) => GameDetails.fromJson(json! as Map<String, Object?>),
        encode: (d) => d.toJson(),
        // Каждое открытие экрана продлевает «просмотр» на сервере, а свежие
        // данные от worker'а появляются в течение минут.
        staleAfter: const Duration(minutes: 2),
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
}

/// Цены в других регионах — только по запросу (лист сравнения), без кэша.
@Riverpod(retry: noRetry)
Future<List<RegionalPrice>> regionalPrices(Ref ref, int appId) =>
    ref.watch(gameRepositoryProvider).regionalPrices(appId);

/// История цены для графика и «лучшей цены».
@riverpod
class PriceHistoryState extends _$PriceHistoryState {
  ResourceBinding<List<PriceHistoryEntry>>? _binding;

  @override
  ResourceView<List<PriceHistoryEntry>> build(int appId) {
    const region = Regions.defaultRegion;
    final repository = ref.watch(gameRepositoryProvider);
    final binding = _binding = ResourceBinding(
      CachedResource<List<PriceHistoryEntry>>(
        db: ref.watch(appDatabaseProvider),
        key: 'prices:$appId:$region',
        fetch: () => repository.priceHistory(appId, region),
        decode: (json) => [
          for (final e in json! as List)
            PriceHistoryEntry.fromJson(e as Map<String, Object?>),
        ],
        encode: (entries) => [for (final e in entries) e.toJson()],
        staleAfter: const Duration(minutes: 15),
      ),
      read: () => state,
      write: (v) => state = v,
    );
    ref.onDispose(binding.dispose);
    scheduleMicrotask(binding.start);
    return const ResourceView();
  }

  Future<void> retry() => _binding!.retry();
}

/// История онлайна за выбранный период для графика.
@riverpod
class PlayerHistoryState extends _$PlayerHistoryState {
  ResourceBinding<PlayerHistory>? _binding;

  @override
  ResourceView<PlayerHistory> build(int appId, HistoryPeriod period) {
    final repository = ref.watch(gameRepositoryProvider);
    final binding = _binding = ResourceBinding(
      CachedResource<PlayerHistory>(
        db: ref.watch(appDatabaseProvider),
        key: 'players:$appId:${period.wireName}',
        fetch: () => repository.playerHistory(appId, period),
        decode: (json) => PlayerHistory.fromJson(json! as Map<String, Object?>),
        encode: (h) => h.toJson(),
        staleAfter: const Duration(minutes: 15),
      ),
      read: () => state,
      write: (v) => state = v,
    );
    ref.onDispose(binding.dispose);
    scheduleMicrotask(binding.start);
    return const ResourceView();
  }

  Future<void> retry() => _binding!.retry();
}
