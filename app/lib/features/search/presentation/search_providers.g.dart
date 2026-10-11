// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(searchRepository)
final searchRepositoryProvider = SearchRepositoryProvider._();

final class SearchRepositoryProvider
    extends
        $FunctionalProvider<
          SearchRepository,
          SearchRepository,
          SearchRepository
        >
    with $Provider<SearchRepository> {
  SearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchRepositoryHash();

  @$internal
  @override
  $ProviderElement<SearchRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SearchRepository create(Ref ref) {
    return searchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchRepository>(value),
    );
  }
}

String _$searchRepositoryHash() => r'd40ff6a3bced8695cf3285f68f344e94d23a331b';

/// Текст в поисковой строке.

@ProviderFor(SearchText)
final searchTextProvider = SearchTextProvider._();

/// Текст в поисковой строке.
final class SearchTextProvider extends $NotifierProvider<SearchText, String> {
  /// Текст в поисковой строке.
  SearchTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchTextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchTextHash();

  @$internal
  @override
  SearchText create() => SearchText();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchTextHash() => r'd832a9e453aa236ecddf5f20451e1af2f04ded0b';

/// Текст в поисковой строке.

abstract class _$SearchText extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Результаты поиска. Поиск живой, без кэша: запросы пользователя разные,
/// а сервер ищет быстро. null — запрос слишком короткий.

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// Результаты поиска. Поиск живой, без кэша: запросы пользователя разные,
/// а сервер ищет быстро. null — запрос слишком короткий.

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameSummary>?>,
          List<GameSummary>?,
          FutureOr<List<GameSummary>?>
        >
    with
        $FutureModifier<List<GameSummary>?>,
        $FutureProvider<List<GameSummary>?> {
  /// Результаты поиска. Поиск живой, без кэша: запросы пользователя разные,
  /// а сервер ищет быстро. null — запрос слишком короткий.
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<GameSummary>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GameSummary>?> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'46e6313efb59578a4dfc027bf5305e274e4a4ed1';
