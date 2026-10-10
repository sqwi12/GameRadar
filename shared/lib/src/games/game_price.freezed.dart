// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamePrice {

 String get region;/// false — в регионе нет цены: игра бесплатна или не продаётся.
 bool get isAvailable;/// ISO 4217, например `KZT`.
 String? get currency; int? get initialPrice; int? get finalPrice; int get discountPct;/// Когда worker последний раз проверял цену.
 DateTime get checkedAt;/// Когда цена последний раз менялась.
 DateTime get changedAt;
/// Create a copy of GamePrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamePriceCopyWith<GamePrice> get copyWith => _$GamePriceCopyWithImpl<GamePrice>(this as GamePrice, _$identity);

  /// Serializes this GamePrice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GamePrice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamePrice&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.initialPrice, _this.initialPrice) || other.initialPrice == _this.initialPrice)&&(identical(other.finalPrice, _this.finalPrice) || other.finalPrice == _this.finalPrice)&&(identical(other.discountPct, _this.discountPct) || other.discountPct == _this.discountPct)&&(identical(other.checkedAt, _this.checkedAt) || other.checkedAt == _this.checkedAt)&&(identical(other.changedAt, _this.changedAt) || other.changedAt == _this.changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GamePrice;
  return Object.hash(runtimeType,_this.region,_this.isAvailable,_this.currency,_this.initialPrice,_this.finalPrice,_this.discountPct,_this.checkedAt,_this.changedAt);
}

@override
String toString() {
  final _this = this as GamePrice;
  return 'GamePrice(region: ${_this.region}, isAvailable: ${_this.isAvailable}, currency: ${_this.currency}, initialPrice: ${_this.initialPrice}, finalPrice: ${_this.finalPrice}, discountPct: ${_this.discountPct}, checkedAt: ${_this.checkedAt}, changedAt: ${_this.changedAt})';
}


}

/// @nodoc
abstract mixin class $GamePriceCopyWith<$Res>  {
  factory $GamePriceCopyWith(GamePrice value, $Res Function(GamePrice) _then) = _$GamePriceCopyWithImpl;
@useResult
$Res call({
 String region, bool isAvailable, String? currency, int? initialPrice, int? finalPrice, int discountPct, DateTime checkedAt, DateTime changedAt
});




}
/// @nodoc
class _$GamePriceCopyWithImpl<$Res>
    implements $GamePriceCopyWith<$Res> {
  _$GamePriceCopyWithImpl(this._self, this._then);

  final GamePrice _self;
  final $Res Function(GamePrice) _then;

/// Create a copy of GamePrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? region = null,Object? isAvailable = null,Object? currency = freezed,Object? initialPrice = freezed,Object? finalPrice = freezed,Object? discountPct = null,Object? checkedAt = null,Object? changedAt = null,}) {
  return _then(GamePrice(
region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,initialPrice: freezed == initialPrice ? _self.initialPrice : initialPrice // ignore: cast_nullable_to_non_nullable
as int?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int?,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as int,checkedAt: null == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GamePrice].
extension GamePricePatterns on GamePrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GamePrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GamePrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GamePrice value)  $default,){
final _that = this;
switch (_that) {
case _GamePrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GamePrice value)?  $default,){
final _that = this;
switch (_that) {
case _GamePrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String region,  bool isAvailable,  String? currency,  int? initialPrice,  int? finalPrice,  int discountPct,  DateTime checkedAt,  DateTime changedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GamePrice() when $default != null:
return $default(_that.region,_that.isAvailable,_that.currency,_that.initialPrice,_that.finalPrice,_that.discountPct,_that.checkedAt,_that.changedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String region,  bool isAvailable,  String? currency,  int? initialPrice,  int? finalPrice,  int discountPct,  DateTime checkedAt,  DateTime changedAt)  $default,) {final _that = this;
switch (_that) {
case _GamePrice():
return $default(_that.region,_that.isAvailable,_that.currency,_that.initialPrice,_that.finalPrice,_that.discountPct,_that.checkedAt,_that.changedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String region,  bool isAvailable,  String? currency,  int? initialPrice,  int? finalPrice,  int discountPct,  DateTime checkedAt,  DateTime changedAt)?  $default,) {final _that = this;
switch (_that) {
case _GamePrice() when $default != null:
return $default(_that.region,_that.isAvailable,_that.currency,_that.initialPrice,_that.finalPrice,_that.discountPct,_that.checkedAt,_that.changedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GamePrice extends GamePrice {
  const _GamePrice({required this.region, required this.isAvailable, this.currency, this.initialPrice, this.finalPrice, this.discountPct = 0, required this.checkedAt, required this.changedAt}): super._();
  factory _GamePrice.fromJson(Map<String, dynamic> json) => _$GamePriceFromJson(json);

@override final  String region;
/// false — в регионе нет цены: игра бесплатна или не продаётся.
@override final  bool isAvailable;
/// ISO 4217, например `KZT`.
@override final  String? currency;
@override final  int? initialPrice;
@override final  int? finalPrice;
@override@JsonKey() final  int discountPct;
/// Когда worker последний раз проверял цену.
@override final  DateTime checkedAt;
/// Когда цена последний раз менялась.
@override final  DateTime changedAt;

/// Create a copy of GamePrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamePriceCopyWith<_GamePrice> get copyWith => __$GamePriceCopyWithImpl<_GamePrice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GamePriceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GamePrice&&(identical(other.region, region) || other.region == region)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.initialPrice, initialPrice) || other.initialPrice == initialPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.discountPct, discountPct) || other.discountPct == discountPct)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,region,isAvailable,currency,initialPrice,finalPrice,discountPct,checkedAt,changedAt);
}

@override
String toString() {
    return 'GamePrice(region: $region, isAvailable: $isAvailable, currency: $currency, initialPrice: $initialPrice, finalPrice: $finalPrice, discountPct: $discountPct, checkedAt: $checkedAt, changedAt: $changedAt)';
}


}

/// @nodoc
abstract mixin class _$GamePriceCopyWith<$Res> implements $GamePriceCopyWith<$Res> {
  factory _$GamePriceCopyWith(_GamePrice value, $Res Function(_GamePrice) _then) = __$GamePriceCopyWithImpl;
@override @useResult
$Res call({
 String region, bool isAvailable, String? currency, int? initialPrice, int? finalPrice, int discountPct, DateTime checkedAt, DateTime changedAt
});




}
/// @nodoc
class __$GamePriceCopyWithImpl<$Res>
    implements _$GamePriceCopyWith<$Res> {
  __$GamePriceCopyWithImpl(this._self, this._then);

  final _GamePrice _self;
  final $Res Function(_GamePrice) _then;

/// Create a copy of GamePrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? region = null,Object? isAvailable = null,Object? currency = freezed,Object? initialPrice = freezed,Object? finalPrice = freezed,Object? discountPct = null,Object? checkedAt = null,Object? changedAt = null,}) {
  return _then(_GamePrice(
region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,initialPrice: freezed == initialPrice ? _self.initialPrice : initialPrice // ignore: cast_nullable_to_non_nullable
as int?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int?,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as int,checkedAt: null == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
