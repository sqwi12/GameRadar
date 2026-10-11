// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_low.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreLow {

 int get price; int get regularPrice;/// Скидка в тот момент, %.
 int get cut; String get currency;/// Когда цена была такой.
 DateTime get at;
/// Create a copy of StoreLow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreLowCopyWith<StoreLow> get copyWith => _$StoreLowCopyWithImpl<StoreLow>(this as StoreLow, _$identity);

  /// Serializes this StoreLow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StoreLow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreLow&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.regularPrice, _this.regularPrice) || other.regularPrice == _this.regularPrice)&&(identical(other.cut, _this.cut) || other.cut == _this.cut)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.at, _this.at) || other.at == _this.at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StoreLow;
  return Object.hash(runtimeType,_this.price,_this.regularPrice,_this.cut,_this.currency,_this.at);
}

@override
String toString() {
  final _this = this as StoreLow;
  return 'StoreLow(price: ${_this.price}, regularPrice: ${_this.regularPrice}, cut: ${_this.cut}, currency: ${_this.currency}, at: ${_this.at})';
}


}

/// @nodoc
abstract mixin class $StoreLowCopyWith<$Res>  {
  factory $StoreLowCopyWith(StoreLow value, $Res Function(StoreLow) _then) = _$StoreLowCopyWithImpl;
@useResult
$Res call({
 int price, int regularPrice, int cut, String currency, DateTime at
});




}
/// @nodoc
class _$StoreLowCopyWithImpl<$Res>
    implements $StoreLowCopyWith<$Res> {
  _$StoreLowCopyWithImpl(this._self, this._then);

  final StoreLow _self;
  final $Res Function(StoreLow) _then;

/// Create a copy of StoreLow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? price = null,Object? regularPrice = null,Object? cut = null,Object? currency = null,Object? at = null,}) {
  return _then(StoreLow(
price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,regularPrice: null == regularPrice ? _self.regularPrice : regularPrice // ignore: cast_nullable_to_non_nullable
as int,cut: null == cut ? _self.cut : cut // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreLow].
extension StoreLowPatterns on StoreLow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreLow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreLow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreLow value)  $default,){
final _that = this;
switch (_that) {
case _StoreLow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreLow value)?  $default,){
final _that = this;
switch (_that) {
case _StoreLow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int price,  int regularPrice,  int cut,  String currency,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreLow() when $default != null:
return $default(_that.price,_that.regularPrice,_that.cut,_that.currency,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int price,  int regularPrice,  int cut,  String currency,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _StoreLow():
return $default(_that.price,_that.regularPrice,_that.cut,_that.currency,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int price,  int regularPrice,  int cut,  String currency,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _StoreLow() when $default != null:
return $default(_that.price,_that.regularPrice,_that.cut,_that.currency,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreLow implements StoreLow {
  const _StoreLow({required this.price, required this.regularPrice, required this.cut, required this.currency, required this.at});
  factory _StoreLow.fromJson(Map<String, dynamic> json) => _$StoreLowFromJson(json);

@override final  int price;
@override final  int regularPrice;
/// Скидка в тот момент, %.
@override final  int cut;
@override final  String currency;
/// Когда цена была такой.
@override final  DateTime at;

/// Create a copy of StoreLow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreLowCopyWith<_StoreLow> get copyWith => __$StoreLowCopyWithImpl<_StoreLow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreLowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreLow&&(identical(other.price, price) || other.price == price)&&(identical(other.regularPrice, regularPrice) || other.regularPrice == regularPrice)&&(identical(other.cut, cut) || other.cut == cut)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,price,regularPrice,cut,currency,at);
}

@override
String toString() {
    return 'StoreLow(price: $price, regularPrice: $regularPrice, cut: $cut, currency: $currency, at: $at)';
}


}

/// @nodoc
abstract mixin class _$StoreLowCopyWith<$Res> implements $StoreLowCopyWith<$Res> {
  factory _$StoreLowCopyWith(_StoreLow value, $Res Function(_StoreLow) _then) = __$StoreLowCopyWithImpl;
@override @useResult
$Res call({
 int price, int regularPrice, int cut, String currency, DateTime at
});




}
/// @nodoc
class __$StoreLowCopyWithImpl<$Res>
    implements _$StoreLowCopyWith<$Res> {
  __$StoreLowCopyWithImpl(this._self, this._then);

  final _StoreLow _self;
  final $Res Function(_StoreLow) _then;

/// Create a copy of StoreLow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? price = null,Object? regularPrice = null,Object? cut = null,Object? currency = null,Object? at = null,}) {
  return _then(_StoreLow(
price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,regularPrice: null == regularPrice ? _self.regularPrice : regularPrice // ignore: cast_nullable_to_non_nullable
as int,cut: null == cut ? _self.cut : cut // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
