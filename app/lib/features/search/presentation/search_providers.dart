import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../data/search_repository.dart';

part 'search_providers.g.dart';

@Riverpod(keepAlive: true)
SearchRepository searchRepository(Ref ref) =>
    SearchRepository(ref.watch(apiClientProvider));

/// Текст в поисковой строке.
@Riverpod(keepAlive: true)
class SearchText extends _$SearchText {
  @override
  String build() => '';

  void set(String text) => state = text;
}

/// Результаты поиска. Поиск живой, без кэша: запросы пользователя разные,
/// а сервер ищет быстро. null — запрос слишком короткий.
@riverpod
Future<List<GameSummary>?> searchResults(Ref ref) async {
  final text = ref.watch(searchTextProvider).trim();
  if (text.length < SearchQuery.minLength) return null;

  // Задержка ввода: пока пользователь печатает, запросы не отправляются —
  // каждое изменение текста пересоздаёт провайдер и отменяет прошлый.
  final cancel = CancelToken();
  ref.onDispose(cancel.cancel);
  await Future<void>.delayed(const Duration(milliseconds: 350));
  if (cancel.isCancelled) throw StateError('отменено');

  return ref
      .read(searchRepositoryProvider)
      .search(
        SearchQuery(text: text, limit: SearchQuery.maxLimit),
        cancelToken: cancel,
      );
}
