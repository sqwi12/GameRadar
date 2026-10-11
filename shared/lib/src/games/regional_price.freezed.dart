// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'regional_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegionalPrice {

 GamePrice get price;/// Итоговая цена в тенге (минимальные единицы); null — нет курса.
 int? get finalPriceKzt;
/// Create a copy of RegionalPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegionalPriceCopyWith<RegionalPrice> get copyWith => _$RegionalPriceCopyWithImpl<RegionalPrice>(this as RegionalPrice, _$identity);

  /// Serializes this RegionalPrice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RegionalPrice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegionalPrice&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.finalPriceKzt, _this.finalPriceKzt) || other.finalPriceKzt == _this.finalPriceKzt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RegionalPrice;
  return Object.hash(runtimeType,_this.price,_this.finalPriceKzt);
}

@override
String toString() {
  final _this = this as RegionalPrice;
  return 'RegionalPrice(price: ${_this.price}, finalPriceKzt: ${_this.finalPriceKzt})';
}


}

/// @nodoc
abstract mixin class $RegionalPriceCopyWith<$Res>  {
  factory $RegionalPriceCopyWith(RegionalPrice value, $Res Function(RegionalPrice) _then) = _$RegionalPriceCopyWithImpl;
@useResult
$Res call({
 GamePrice price, int? finalPriceKzt
});


$GamePriceCopyWith<$Res> get price;

}
/// @nodoc
class _$RegionalPriceCopyWithImpl<$Res>
    implements $RegionalPriceCopyWith<$Res> {
  _$RegionalPriceCopyWithImpl(this._self, this._then);

  final RegionalPrice _self;
  final $Res Function(RegionalPrice) _then;

/// Create a copy of RegionalPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? price = null,Object? finalPriceKzt = freezed,}) {
  return _then(RegionalPrice(
price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as GamePrice,finalPriceKzt: freezed == finalPriceKzt ? _self.finalPriceKzt : finalPriceKzt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of RegionalPrice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamePriceCopyWith<$Res> get price {
  
  return $GamePriceCopyWith<$Res>(_self.price, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegionalPrice].
extension RegionalPricePatterns on RegionalPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegionalPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegionalPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegionalPrice value)  $default,){
final _that = this;
switch (_that) {
case _RegionalPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegionalPrice value)?  $default,){
final _that = this;
switch (_that) {
case _RegionalPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GamePrice price,  int? finalPriceKzt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegionalPrice() when $default != null:
return $default(_that.price,_that.finalPriceKzt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GamePrice price,  int? finalPriceKzt)  $default,) {final _that = this;
switch (_that) {
case _RegionalPrice():
return $default(_that.price,_that.finalPriceKzt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GamePrice price,  int? finalPriceKzt)?  $default,) {final _that = this;
switch (_that) {
case _RegionalPrice() when $default != null:
return $default(_that.price,_that.finalPriceKzt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegionalPrice implements RegionalPrice {
  const _RegionalPrice({required this.price, this.finalPriceKzt});
  factory _RegionalPrice.fromJson(Map<String, dynamic> json) => _$RegionalPriceFromJson(json);

@override final  GamePrice price;
/// Итоговая цена в тенге (минимальные единицы); null — нет курса.
@override final  int? finalPriceKzt;

/// Create a copy of RegionalPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegionalPriceCopyWith<_RegionalPrice> get copyWith => __$RegionalPriceCopyWithImpl<_RegionalPrice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegionalPriceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegionalPrice&&(identical(other.price, price) || other.price == price)&&(identical(other.finalPriceKzt, finalPriceKzt) || other.finalPriceKzt == finalPriceKzt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,price,finalPriceKzt);
}

@override
String toString() {
    return 'RegionalPrice(price: $price, finalPriceKzt: $finalPriceKzt)';
}


}

/// @nodoc
abstract mixin class _$RegionalPriceCopyWith<$Res> implements $RegionalPriceCopyWith<$Res> {
  factory _$RegionalPriceCopyWith(_RegionalPrice value, $Res Function(_RegionalPrice) _then) = __$RegionalPriceCopyWithImpl;
@override @useResult
$Res call({
 GamePrice price, int? finalPriceKzt
});


@override $GamePriceCopyWith<$Res> get price;

}
/// @nodoc
class __$RegionalPriceCopyWithImpl<$Res>
    implements _$RegionalPriceCopyWith<$Res> {
  __$RegionalPriceCopyWithImpl(this._self, this._then);

  final _RegionalPrice _self;
  final $Res Function(_RegionalPrice) _then;

/// Create a copy of RegionalPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? price = null,Object? finalPriceKzt = freezed,}) {
  return _then(_RegionalPrice(
price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as GamePrice,finalPriceKzt: freezed == finalPriceKzt ? _self.finalPriceKzt : finalPriceKzt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of RegionalPrice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamePriceCopyWith<$Res> get price {
  
  return $GamePriceCopyWith<$Res>(_self.price, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}

// dart format on
