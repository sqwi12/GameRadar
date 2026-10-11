// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_queries.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchQuery {

 String get text; String get region; int get limit;
/// Create a copy of SearchQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchQueryCopyWith<SearchQuery> get copyWith => _$SearchQueryCopyWithImpl<SearchQuery>(this as SearchQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchQuery&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.limit, _this.limit) || other.limit == _this.limit));
}


@override
int get hashCode {
  final _this = this as SearchQuery;
  return Object.hash(runtimeType,_this.text,_this.region,_this.limit);
}

@override
String toString() {
  final _this = this as SearchQuery;
  return 'SearchQuery(text: ${_this.text}, region: ${_this.region}, limit: ${_this.limit})';
}


}

/// @nodoc
abstract mixin class $SearchQueryCopyWith<$Res>  {
  factory $SearchQueryCopyWith(SearchQuery value, $Res Function(SearchQuery) _then) = _$SearchQueryCopyWithImpl;
@useResult
$Res call({
 String text, String region, int limit
});




}
/// @nodoc
class _$SearchQueryCopyWithImpl<$Res>
    implements $SearchQueryCopyWith<$Res> {
  _$SearchQueryCopyWithImpl(this._self, this._then);

  final SearchQuery _self;
  final $Res Function(SearchQuery) _then;

/// Create a copy of SearchQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? region = null,Object? limit = null,}) {
  return _then(SearchQuery(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchQuery].
extension SearchQueryPatterns on SearchQuery {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchQuery() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchQuery value)  $default,){
final _that = this;
switch (_that) {
case _SearchQuery():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchQuery value)?  $default,){
final _that = this;
switch (_that) {
case _SearchQuery() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String region,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchQuery() when $default != null:
return $default(_that.text,_that.region,_that.limit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String region,  int limit)  $default,) {final _that = this;
switch (_that) {
case _SearchQuery():
return $default(_that.text,_that.region,_that.limit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String region,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _SearchQuery() when $default != null:
return $default(_that.text,_that.region,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _SearchQuery extends SearchQuery {
  const _SearchQuery({required this.text, this.region = Regions.defaultRegion, this.limit = PageLimits.defaultLimit}): super._();
  

@override final  String text;
@override@JsonKey() final  String region;
@override@JsonKey() final  int limit;

/// Create a copy of SearchQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchQueryCopyWith<_SearchQuery> get copyWith => __$SearchQueryCopyWithImpl<_SearchQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchQuery&&(identical(other.text, text) || other.text == text)&&(identical(other.region, region) || other.region == region)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,region,limit);
}

@override
String toString() {
    return 'SearchQuery(text: $text, region: $region, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$SearchQueryCopyWith<$Res> implements $SearchQueryCopyWith<$Res> {
  factory _$SearchQueryCopyWith(_SearchQuery value, $Res Function(_SearchQuery) _then) = __$SearchQueryCopyWithImpl;
@override @useResult
$Res call({
 String text, String region, int limit
});




}
/// @nodoc
class __$SearchQueryCopyWithImpl<$Res>
    implements _$SearchQueryCopyWith<$Res> {
  __$SearchQueryCopyWithImpl(this._self, this._then);

  final _SearchQuery _self;
  final $Res Function(_SearchQuery) _then;

/// Create a copy of SearchQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? region = null,Object? limit = null,}) {
  return _then(_SearchQuery(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TopQuery {

 TopSort get sort; String get region;/// Только игры со скидкой.
 bool get onlyDiscounted;/// Только бесплатные игры.
 bool get onlyFree;/// Жанр Steam (см. [SteamGenres]); null — любые.
 String? get genre; int get offset; int get limit;
/// Create a copy of TopQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopQueryCopyWith<TopQuery> get copyWith => _$TopQueryCopyWithImpl<TopQuery>(this as TopQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TopQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopQuery&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.onlyDiscounted, _this.onlyDiscounted) || other.onlyDiscounted == _this.onlyDiscounted)&&(identical(other.onlyFree, _this.onlyFree) || other.onlyFree == _this.onlyFree)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.offset, _this.offset) || other.offset == _this.offset)&&(identical(other.limit, _this.limit) || other.limit == _this.limit));
}


@override
int get hashCode {
  final _this = this as TopQuery;
  return Object.hash(runtimeType,_this.sort,_this.region,_this.onlyDiscounted,_this.onlyFree,_this.genre,_this.offset,_this.limit);
}

@override
String toString() {
  final _this = this as TopQuery;
  return 'TopQuery(sort: ${_this.sort}, region: ${_this.region}, onlyDiscounted: ${_this.onlyDiscounted}, onlyFree: ${_this.onlyFree}, genre: ${_this.genre}, offset: ${_this.offset}, limit: ${_this.limit})';
}


}

/// @nodoc
abstract mixin class $TopQueryCopyWith<$Res>  {
  factory $TopQueryCopyWith(TopQuery value, $Res Function(TopQuery) _then) = _$TopQueryCopyWithImpl;
@useResult
$Res call({
 TopSort sort, String region, bool onlyDiscounted, bool onlyFree, String? genre, int offset, int limit
});




}
/// @nodoc
class _$TopQueryCopyWithImpl<$Res>
    implements $TopQueryCopyWith<$Res> {
  _$TopQueryCopyWithImpl(this._self, this._then);

  final TopQuery _self;
  final $Res Function(TopQuery) _then;

/// Create a copy of TopQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sort = null,Object? region = null,Object? onlyDiscounted = null,Object? onlyFree = null,Object? genre = freezed,Object? offset = null,Object? limit = null,}) {
  return _then(TopQuery(
sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as TopSort,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,onlyDiscounted: null == onlyDiscounted ? _self.onlyDiscounted : onlyDiscounted // ignore: cast_nullable_to_non_nullable
as bool,onlyFree: null == onlyFree ? _self.onlyFree : onlyFree // ignore: cast_nullable_to_non_nullable
as bool,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TopQuery].
extension TopQueryPatterns on TopQuery {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopQuery() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopQuery value)  $default,){
final _that = this;
switch (_that) {
case _TopQuery():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopQuery value)?  $default,){
final _that = this;
switch (_that) {
case _TopQuery() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TopSort sort,  String region,  bool onlyDiscounted,  bool onlyFree,  String? genre,  int offset,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopQuery() when $default != null:
return $default(_that.sort,_that.region,_that.onlyDiscounted,_that.onlyFree,_that.genre,_that.offset,_that.limit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TopSort sort,  String region,  bool onlyDiscounted,  bool onlyFree,  String? genre,  int offset,  int limit)  $default,) {final _that = this;
switch (_that) {
case _TopQuery():
return $default(_that.sort,_that.region,_that.onlyDiscounted,_that.onlyFree,_that.genre,_that.offset,_that.limit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TopSort sort,  String region,  bool onlyDiscounted,  bool onlyFree,  String? genre,  int offset,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _TopQuery() when $default != null:
return $default(_that.sort,_that.region,_that.onlyDiscounted,_that.onlyFree,_that.genre,_that.offset,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _TopQuery extends TopQuery {
  const _TopQuery({this.sort = TopSort.current, this.region = Regions.defaultRegion, this.onlyDiscounted = false, this.onlyFree = false, this.genre, this.offset = 0, this.limit = PageLimits.defaultLimit}): super._();
  

@override@JsonKey() final  TopSort sort;
@override@JsonKey() final  String region;
/// Только игры со скидкой.
@override@JsonKey() final  bool onlyDiscounted;
/// Только бесплатные игры.
@override@JsonKey() final  bool onlyFree;
/// Жанр Steam (см. [SteamGenres]); null — любые.
@override final  String? genre;
@override@JsonKey() final  int offset;
@override@JsonKey() final  int limit;

/// Create a copy of TopQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopQueryCopyWith<_TopQuery> get copyWith => __$TopQueryCopyWithImpl<_TopQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopQuery&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.region, region) || other.region == region)&&(identical(other.onlyDiscounted, onlyDiscounted) || other.onlyDiscounted == onlyDiscounted)&&(identical(other.onlyFree, onlyFree) || other.onlyFree == onlyFree)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sort,region,onlyDiscounted,onlyFree,genre,offset,limit);
}

@override
String toString() {
    return 'TopQuery(sort: $sort, region: $region, onlyDiscounted: $onlyDiscounted, onlyFree: $onlyFree, genre: $genre, offset: $offset, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$TopQueryCopyWith<$Res> implements $TopQueryCopyWith<$Res> {
  factory _$TopQueryCopyWith(_TopQuery value, $Res Function(_TopQuery) _then) = __$TopQueryCopyWithImpl;
@override @useResult
$Res call({
 TopSort sort, String region, bool onlyDiscounted, bool onlyFree, String? genre, int offset, int limit
});




}
/// @nodoc
class __$TopQueryCopyWithImpl<$Res>
    implements _$TopQueryCopyWith<$Res> {
  __$TopQueryCopyWithImpl(this._self, this._then);

  final _TopQuery _self;
  final $Res Function(_TopQuery) _then;

/// Create a copy of TopQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sort = null,Object? region = null,Object? onlyDiscounted = null,Object? onlyFree = null,Object? genre = freezed,Object? offset = null,Object? limit = null,}) {
  return _then(_TopQuery(
sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as TopSort,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,onlyDiscounted: null == onlyDiscounted ? _self.onlyDiscounted : onlyDiscounted // ignore: cast_nullable_to_non_nullable
as bool,onlyFree: null == onlyFree ? _self.onlyFree : onlyFree // ignore: cast_nullable_to_non_nullable
as bool,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$DiscountsQuery {

 DiscountSort get sort; String get region;/// Минимальная скидка, %.
 int get minDiscountPct;/// Максимальная цена со скидкой в минимальных единицах валюты.
 int? get maxPrice;/// Жанр Steam (см. [SteamGenres]); null — любые.
 String? get genre; int get offset; int get limit;
/// Create a copy of DiscountsQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscountsQueryCopyWith<DiscountsQuery> get copyWith => _$DiscountsQueryCopyWithImpl<DiscountsQuery>(this as DiscountsQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiscountsQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscountsQuery&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.minDiscountPct, _this.minDiscountPct) || other.minDiscountPct == _this.minDiscountPct)&&(identical(other.maxPrice, _this.maxPrice) || other.maxPrice == _this.maxPrice)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.offset, _this.offset) || other.offset == _this.offset)&&(identical(other.limit, _this.limit) || other.limit == _this.limit));
}


@override
int get hashCode {
  final _this = this as DiscountsQuery;
  return Object.hash(runtimeType,_this.sort,_this.region,_this.minDiscountPct,_this.maxPrice,_this.genre,_this.offset,_this.limit);
}

@override
String toString() {
  final _this = this as DiscountsQuery;
  return 'DiscountsQuery(sort: ${_this.sort}, region: ${_this.region}, minDiscountPct: ${_this.minDiscountPct}, maxPrice: ${_this.maxPrice}, genre: ${_this.genre}, offset: ${_this.offset}, limit: ${_this.limit})';
}


}

/// @nodoc
abstract mixin class $DiscountsQueryCopyWith<$Res>  {
  factory $DiscountsQueryCopyWith(DiscountsQuery value, $Res Function(DiscountsQuery) _then) = _$DiscountsQueryCopyWithImpl;
@useResult
$Res call({
 DiscountSort sort, String region, int minDiscountPct, int? maxPrice, String? genre, int offset, int limit
});




}
/// @nodoc
class _$DiscountsQueryCopyWithImpl<$Res>
    implements $DiscountsQueryCopyWith<$Res> {
  _$DiscountsQueryCopyWithImpl(this._self, this._then);

  final DiscountsQuery _self;
  final $Res Function(DiscountsQuery) _then;

/// Create a copy of DiscountsQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sort = null,Object? region = null,Object? minDiscountPct = null,Object? maxPrice = freezed,Object? genre = freezed,Object? offset = null,Object? limit = null,}) {
  return _then(DiscountsQuery(
sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as DiscountSort,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,minDiscountPct: null == minDiscountPct ? _self.minDiscountPct : minDiscountPct // ignore: cast_nullable_to_non_nullable
as int,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscountsQuery].
extension DiscountsQueryPatterns on DiscountsQuery {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscountsQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscountsQuery() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscountsQuery value)  $default,){
final _that = this;
switch (_that) {
case _DiscountsQuery():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscountsQuery value)?  $default,){
final _that = this;
switch (_that) {
case _DiscountsQuery() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiscountSort sort,  String region,  int minDiscountPct,  int? maxPrice,  String? genre,  int offset,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscountsQuery() when $default != null:
return $default(_that.sort,_that.region,_that.minDiscountPct,_that.maxPrice,_that.genre,_that.offset,_that.limit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiscountSort sort,  String region,  int minDiscountPct,  int? maxPrice,  String? genre,  int offset,  int limit)  $default,) {final _that = this;
switch (_that) {
case _DiscountsQuery():
return $default(_that.sort,_that.region,_that.minDiscountPct,_that.maxPrice,_that.genre,_that.offset,_that.limit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiscountSort sort,  String region,  int minDiscountPct,  int? maxPrice,  String? genre,  int offset,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _DiscountsQuery() when $default != null:
return $default(_that.sort,_that.region,_that.minDiscountPct,_that.maxPrice,_that.genre,_that.offset,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _DiscountsQuery extends DiscountsQuery {
  const _DiscountsQuery({this.sort = DiscountSort.discount, this.region = Regions.defaultRegion, this.minDiscountPct = 1, this.maxPrice, this.genre, this.offset = 0, this.limit = PageLimits.defaultLimit}): super._();
  

@override@JsonKey() final  DiscountSort sort;
@override@JsonKey() final  String region;
/// Минимальная скидка, %.
@override@JsonKey() final  int minDiscountPct;
/// Максимальная цена со скидкой в минимальных единицах валюты.
@override final  int? maxPrice;
/// Жанр Steam (см. [SteamGenres]); null — любые.
@override final  String? genre;
@override@JsonKey() final  int offset;
@override@JsonKey() final  int limit;

/// Create a copy of DiscountsQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscountsQueryCopyWith<_DiscountsQuery> get copyWith => __$DiscountsQueryCopyWithImpl<_DiscountsQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscountsQuery&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.region, region) || other.region == region)&&(identical(other.minDiscountPct, minDiscountPct) || other.minDiscountPct == minDiscountPct)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sort,region,minDiscountPct,maxPrice,genre,offset,limit);
}

@override
String toString() {
    return 'DiscountsQuery(sort: $sort, region: $region, minDiscountPct: $minDiscountPct, maxPrice: $maxPrice, genre: $genre, offset: $offset, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$DiscountsQueryCopyWith<$Res> implements $DiscountsQueryCopyWith<$Res> {
  factory _$DiscountsQueryCopyWith(_DiscountsQuery value, $Res Function(_DiscountsQuery) _then) = __$DiscountsQueryCopyWithImpl;
@override @useResult
$Res call({
 DiscountSort sort, String region, int minDiscountPct, int? maxPrice, String? genre, int offset, int limit
});




}
/// @nodoc
class __$DiscountsQueryCopyWithImpl<$Res>
    implements _$DiscountsQueryCopyWith<$Res> {
  __$DiscountsQueryCopyWithImpl(this._self, this._then);

  final _DiscountsQuery _self;
  final $Res Function(_DiscountsQuery) _then;

/// Create a copy of DiscountsQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sort = null,Object? region = null,Object? minDiscountPct = null,Object? maxPrice = freezed,Object? genre = freezed,Object? offset = null,Object? limit = null,}) {
  return _then(_DiscountsQuery(
sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as DiscountSort,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,minDiscountPct: null == minDiscountPct ? _self.minDiscountPct : minDiscountPct // ignore: cast_nullable_to_non_nullable
as int,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
