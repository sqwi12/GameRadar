import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/api_error.dart';
import '../common/region.dart';
import '../common/validation.dart';

part 'game_queries.freezed.dart';

// Параметры списков передаются в query-строке, поэтому у этих моделей нет JSON:
// приложение собирает их через toQueryParameters(), сервер разбирает через
// fromQueryParameters(), которые бросают RequestValidationException.

/// Ограничения пагинации, общие для всех списков.
abstract final class PageLimits {
  static const defaultLimit = 20;
  static const maxLimit = 100;
}

void _validatePaging(
  Validator v,
  int offset,
  int limit, {
  int max = PageLimits.maxLimit,
}) {
  v
    ..range('offset', offset, min: 0)
    ..range('limit', limit, min: 1, max: max);
}

void _validateRegion(Validator v, String region) {
  if (!Regions.isValid(region)) v.add('region', FieldErrorCode.invalidFormat);
}

/// GET /games/search
@freezed
abstract class SearchQuery with _$SearchQuery {
  const SearchQuery._();

  const factory SearchQuery({
    required String text,
    @Default(Regions.defaultRegion) String region,
    @Default(PageLimits.defaultLimit) int limit,
  }) = _SearchQuery;

  static const minLength = 2;
  static const maxLength = 100;
  static const maxLimit = 50;

  factory SearchQuery.fromQueryParameters(Map<String, String> params) {
    final v = Validator();
    final query = SearchQuery(
      text: (params['q'] ?? '').trim(),
      region: params['region'] ?? Regions.defaultRegion,
      limit: parseIntParam(params, 'limit', v) ?? PageLimits.defaultLimit,
    );
    query._validate(v);
    v.throwIfInvalid();
    return query;
  }

  void _validate(Validator v) {
    if (text.length < minLength) {
      v.add('q', FieldErrorCode.required);
    } else if (text.length > maxLength) {
      v.add('q', FieldErrorCode.tooLong);
    }
    _validateRegion(v, region);
    v.range('limit', limit, min: 1, max: maxLimit);
  }

  List<FieldError> validate() {
    final v = Validator();
    _validate(v);
    return v.errors;
  }

  Map<String, String> toQueryParameters() => {
    'q': text.trim(),
    'region': region,
    'limit': '$limit',
  };
}

/// Сортировка топа.
enum TopSort {
  /// По текущему онлайну.
  current('current'),

  /// По пику за 24 часа.
  peak24h('peak_24h');

  const TopSort(this.wireName);
  final String wireName;
}

/// Основные жанры Steam (так они хранятся в каталоге — по-английски).
abstract final class SteamGenres {
  static const common = [
    'Action',
    'Adventure',
    'RPG',
    'Strategy',
    'Simulation',
    'Indie',
    'Casual',
    'Sports',
    'Racing',
    'Massively Multiplayer',
    'Early Access',
  ];

  static const maxLength = 40;
}

void _validateGenre(Validator v, String? genre) {
  if (genre != null &&
      (genre.isEmpty || genre.length > SteamGenres.maxLength)) {
    v.add('genre', FieldErrorCode.invalidFormat);
  }
}

/// GET /games/top
@freezed
abstract class TopQuery with _$TopQuery {
  const TopQuery._();

  const factory TopQuery({
    @Default(TopSort.current) TopSort sort,
    @Default(Regions.defaultRegion) String region,

    /// Только игры со скидкой.
    @Default(false) bool onlyDiscounted,

    /// Только бесплатные игры.
    @Default(false) bool onlyFree,

    /// Жанр Steam (см. [SteamGenres]); null — любые.
    String? genre,
    @Default(0) int offset,
    @Default(PageLimits.defaultLimit) int limit,
  }) = _TopQuery;

  factory TopQuery.fromQueryParameters(Map<String, String> params) {
    final v = Validator();
    final query = TopQuery(
      sort:
          parseEnumParam(
            params,
            'sort',
            TopSort.values,
            (s) => s.wireName,
            v,
          ) ??
          TopSort.current,
      region: params['region'] ?? Regions.defaultRegion,
      onlyDiscounted: params['only_discounted'] == 'true',
      onlyFree: params['only_free'] == 'true',
      genre: params['genre'],
      offset: parseIntParam(params, 'offset', v) ?? 0,
      limit: parseIntParam(params, 'limit', v) ?? PageLimits.defaultLimit,
    );
    query._validate(v);
    v.throwIfInvalid();
    return query;
  }

  void _validate(Validator v) {
    _validateRegion(v, region);
    _validateGenre(v, genre);
    _validatePaging(v, offset, limit);
  }

  List<FieldError> validate() {
    final v = Validator();
    _validate(v);
    return v.errors;
  }

  Map<String, String> toQueryParameters() => {
    'sort': sort.wireName,
    'region': region,
    if (onlyDiscounted) 'only_discounted': 'true',
    if (onlyFree) 'only_free': 'true',
    'genre': ?genre,
    'offset': '$offset',
    'limit': '$limit',
  };
}

/// Сортировка экрана «Скидки сейчас».
enum DiscountSort {
  /// Сначала самые большие скидки.
  discount('discount'),

  /// Сначала самые дешёвые.
  price('price'),

  /// Сначала самые популярные по онлайну.
  players('players');

  const DiscountSort(this.wireName);
  final String wireName;
}

/// GET /games/discounts
@freezed
abstract class DiscountsQuery with _$DiscountsQuery {
  const DiscountsQuery._();

  const factory DiscountsQuery({
    @Default(DiscountSort.discount) DiscountSort sort,
    @Default(Regions.defaultRegion) String region,

    /// Минимальная скидка, %.
    @Default(1) int minDiscountPct,

    /// Максимальная цена со скидкой в минимальных единицах валюты.
    int? maxPrice,

    /// Жанр Steam (см. [SteamGenres]); null — любые.
    String? genre,
    @Default(0) int offset,
    @Default(PageLimits.defaultLimit) int limit,
  }) = _DiscountsQuery;

  factory DiscountsQuery.fromQueryParameters(Map<String, String> params) {
    final v = Validator();
    final query = DiscountsQuery(
      sort:
          parseEnumParam(
            params,
            'sort',
            DiscountSort.values,
            (s) => s.wireName,
            v,
          ) ??
          DiscountSort.discount,
      region: params['region'] ?? Regions.defaultRegion,
      minDiscountPct: parseIntParam(params, 'min_discount_pct', v) ?? 1,
      maxPrice: parseIntParam(params, 'max_price', v),
      genre: params['genre'],
      offset: parseIntParam(params, 'offset', v) ?? 0,
      limit: parseIntParam(params, 'limit', v) ?? PageLimits.defaultLimit,
    );
    query._validate(v);
    v.throwIfInvalid();
    return query;
  }

  void _validate(Validator v) {
    _validateRegion(v, region);
    v
      ..range('min_discount_pct', minDiscountPct, min: 1, max: 100)
      ..range('max_price', maxPrice, min: 0);
    _validateGenre(v, genre);
    _validatePaging(v, offset, limit);
  }

  List<FieldError> validate() {
    final v = Validator();
    _validate(v);
    return v.errors;
  }

  Map<String, String> toQueryParameters() => {
    'sort': sort.wireName,
    'region': region,
    'min_discount_pct': '$minDiscountPct',
    if (maxPrice != null) 'max_price': '$maxPrice',
    'genre': ?genre,
    'offset': '$offset',
    'limit': '$limit',
  };
}
