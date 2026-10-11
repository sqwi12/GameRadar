// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameSummary {

 int get appId; String get name; String? get headerImageUrl;/// Бесплатная игра: у неё нет цены в магазине.
 bool get isFree;/// Цена в регионе запроса; null — цена ещё не загружалась.
 GamePrice? get price; int? get currentPlayers;@JsonKey(name: 'peak_24h') int? get peak24h;/// Место в топ-1000 по онлайну.
 int? get topRank;
/// Create a copy of GameSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameSummaryCopyWith<GameSummary> get copyWith => _$GameSummaryCopyWithImpl<GameSummary>(this as GameSummary, _$identity);

  /// Serializes this GameSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GameSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameSummary&&(identical(other.appId, _this.appId) || other.appId == _this.appId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.headerImageUrl, _this.headerImageUrl) || other.headerImageUrl == _this.headerImageUrl)&&(identical(other.isFree, _this.isFree) || other.isFree == _this.isFree)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.currentPlayers, _this.currentPlayers) || other.currentPlayers == _this.currentPlayers)&&(identical(other.peak24h, _this.peak24h) || other.peak24h == _this.peak24h)&&(identical(other.topRank, _this.topRank) || other.topRank == _this.topRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GameSummary;
  return Object.hash(runtimeType,_this.appId,_this.name,_this.headerImageUrl,_this.isFree,_this.price,_this.currentPlayers,_this.peak24h,_this.topRank);
}

@override
String toString() {
  final _this = this as GameSummary;
  return 'GameSummary(appId: ${_this.appId}, name: ${_this.name}, headerImageUrl: ${_this.headerImageUrl}, isFree: ${_this.isFree}, price: ${_this.price}, currentPlayers: ${_this.currentPlayers}, peak24h: ${_this.peak24h}, topRank: ${_this.topRank})';
}


}

/// @nodoc
abstract mixin class $GameSummaryCopyWith<$Res>  {
  factory $GameSummaryCopyWith(GameSummary value, $Res Function(GameSummary) _then) = _$GameSummaryCopyWithImpl;
@useResult
$Res call({
 int appId, String name, String? headerImageUrl, bool isFree, GamePrice? price, int? currentPlayers,@JsonKey(name: 'peak_24h') int? peak24h, int? topRank
});


$GamePriceCopyWith<$Res>? get price;

}
/// @nodoc
class _$GameSummaryCopyWithImpl<$Res>
    implements $GameSummaryCopyWith<$Res> {
  _$GameSummaryCopyWithImpl(this._self, this._then);

  final GameSummary _self;
  final $Res Function(GameSummary) _then;

/// Create a copy of GameSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appId = null,Object? name = null,Object? headerImageUrl = freezed,Object? isFree = null,Object? price = freezed,Object? currentPlayers = freezed,Object? peak24h = freezed,Object? topRank = freezed,}) {
  return _then(GameSummary(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,headerImageUrl: freezed == headerImageUrl ? _self.headerImageUrl : headerImageUrl // ignore: cast_nullable_to_non_nullable
as String?,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as GamePrice?,currentPlayers: freezed == currentPlayers ? _self.currentPlayers : currentPlayers // ignore: cast_nullable_to_non_nullable
as int?,peak24h: freezed == peak24h ? _self.peak24h : peak24h // ignore: cast_nullable_to_non_nullable
as int?,topRank: freezed == topRank ? _self.topRank : topRank // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of GameSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamePriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $GamePriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameSummary].
extension GameSummaryPatterns on GameSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameSummary value)  $default,){
final _that = this;
switch (_that) {
case _GameSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameSummary value)?  $default,){
final _that = this;
switch (_that) {
case _GameSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int appId,  String name,  String? headerImageUrl,  bool isFree,  GamePrice? price,  int? currentPlayers, @JsonKey(name: 'peak_24h')  int? peak24h,  int? topRank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameSummary() when $default != null:
return $default(_that.appId,_that.name,_that.headerImageUrl,_that.isFree,_that.price,_that.currentPlayers,_that.peak24h,_that.topRank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int appId,  String name,  String? headerImageUrl,  bool isFree,  GamePrice? price,  int? currentPlayers, @JsonKey(name: 'peak_24h')  int? peak24h,  int? topRank)  $default,) {final _that = this;
switch (_that) {
case _GameSummary():
return $default(_that.appId,_that.name,_that.headerImageUrl,_that.isFree,_that.price,_that.currentPlayers,_that.peak24h,_that.topRank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int appId,  String name,  String? headerImageUrl,  bool isFree,  GamePrice? price,  int? currentPlayers, @JsonKey(name: 'peak_24h')  int? peak24h,  int? topRank)?  $default,) {final _that = this;
switch (_that) {
case _GameSummary() when $default != null:
return $default(_that.appId,_that.name,_that.headerImageUrl,_that.isFree,_that.price,_that.currentPlayers,_that.peak24h,_that.topRank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameSummary implements GameSummary {
  const _GameSummary({required this.appId, required this.name, this.headerImageUrl, this.isFree = false, this.price, this.currentPlayers, @JsonKey(name: 'peak_24h') this.peak24h, this.topRank});
  factory _GameSummary.fromJson(Map<String, dynamic> json) => _$GameSummaryFromJson(json);

@override final  int appId;
@override final  String name;
@override final  String? headerImageUrl;
/// Бесплатная игра: у неё нет цены в магазине.
@override@JsonKey() final  bool isFree;
/// Цена в регионе запроса; null — цена ещё не загружалась.
@override final  GamePrice? price;
@override final  int? currentPlayers;
@override@JsonKey(name: 'peak_24h') final  int? peak24h;
/// Место в топ-1000 по онлайну.
@override final  int? topRank;

/// Create a copy of GameSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameSummaryCopyWith<_GameSummary> get copyWith => __$GameSummaryCopyWithImpl<_GameSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameSummary&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.name, name) || other.name == name)&&(identical(other.headerImageUrl, headerImageUrl) || other.headerImageUrl == headerImageUrl)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.price, price) || other.price == price)&&(identical(other.currentPlayers, currentPlayers) || other.currentPlayers == currentPlayers)&&(identical(other.peak24h, peak24h) || other.peak24h == peak24h)&&(identical(other.topRank, topRank) || other.topRank == topRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,appId,name,headerImageUrl,isFree,price,currentPlayers,peak24h,topRank);
}

@override
String toString() {
    return 'GameSummary(appId: $appId, name: $name, headerImageUrl: $headerImageUrl, isFree: $isFree, price: $price, currentPlayers: $currentPlayers, peak24h: $peak24h, topRank: $topRank)';
}


}

/// @nodoc
abstract mixin class _$GameSummaryCopyWith<$Res> implements $GameSummaryCopyWith<$Res> {
  factory _$GameSummaryCopyWith(_GameSummary value, $Res Function(_GameSummary) _then) = __$GameSummaryCopyWithImpl;
@override @useResult
$Res call({
 int appId, String name, String? headerImageUrl, bool isFree, GamePrice? price, int? currentPlayers,@JsonKey(name: 'peak_24h') int? peak24h, int? topRank
});


@override $GamePriceCopyWith<$Res>? get price;

}
/// @nodoc
class __$GameSummaryCopyWithImpl<$Res>
    implements _$GameSummaryCopyWith<$Res> {
  __$GameSummaryCopyWithImpl(this._self, this._then);

  final _GameSummary _self;
  final $Res Function(_GameSummary) _then;

/// Create a copy of GameSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appId = null,Object? name = null,Object? headerImageUrl = freezed,Object? isFree = null,Object? price = freezed,Object? currentPlayers = freezed,Object? peak24h = freezed,Object? topRank = freezed,}) {
  return _then(_GameSummary(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,headerImageUrl: freezed == headerImageUrl ? _self.headerImageUrl : headerImageUrl // ignore: cast_nullable_to_non_nullable
as String?,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as GamePrice?,currentPlayers: freezed == currentPlayers ? _self.currentPlayers : currentPlayers // ignore: cast_nullable_to_non_nullable
as int?,peak24h: freezed == peak24h ? _self.peak24h : peak24h // ignore: cast_nullable_to_non_nullable
as int?,topRank: freezed == topRank ? _self.topRank : topRank // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of GameSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamePriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $GamePriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}

// dart format on
