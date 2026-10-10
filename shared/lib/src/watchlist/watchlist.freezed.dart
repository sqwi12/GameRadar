// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchlistUpsertRequest {

/// Уведомить, когда цена станет не выше этой (минимальные единицы валюты).
 int? get targetPrice;/// Уведомить, когда скидка станет не меньше этой, %.
 int? get minDiscountPct;
/// Create a copy of WatchlistUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistUpsertRequestCopyWith<WatchlistUpsertRequest> get copyWith => _$WatchlistUpsertRequestCopyWithImpl<WatchlistUpsertRequest>(this as WatchlistUpsertRequest, _$identity);

  /// Serializes this WatchlistUpsertRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WatchlistUpsertRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistUpsertRequest&&(identical(other.targetPrice, _this.targetPrice) || other.targetPrice == _this.targetPrice)&&(identical(other.minDiscountPct, _this.minDiscountPct) || other.minDiscountPct == _this.minDiscountPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WatchlistUpsertRequest;
  return Object.hash(runtimeType,_this.targetPrice,_this.minDiscountPct);
}

@override
String toString() {
  final _this = this as WatchlistUpsertRequest;
  return 'WatchlistUpsertRequest(targetPrice: ${_this.targetPrice}, minDiscountPct: ${_this.minDiscountPct})';
}


}

/// @nodoc
abstract mixin class $WatchlistUpsertRequestCopyWith<$Res>  {
  factory $WatchlistUpsertRequestCopyWith(WatchlistUpsertRequest value, $Res Function(WatchlistUpsertRequest) _then) = _$WatchlistUpsertRequestCopyWithImpl;
@useResult
$Res call({
 int? targetPrice, int? minDiscountPct
});




}
/// @nodoc
class _$WatchlistUpsertRequestCopyWithImpl<$Res>
    implements $WatchlistUpsertRequestCopyWith<$Res> {
  _$WatchlistUpsertRequestCopyWithImpl(this._self, this._then);

  final WatchlistUpsertRequest _self;
  final $Res Function(WatchlistUpsertRequest) _then;

/// Create a copy of WatchlistUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetPrice = freezed,Object? minDiscountPct = freezed,}) {
  return _then(WatchlistUpsertRequest(
targetPrice: freezed == targetPrice ? _self.targetPrice : targetPrice // ignore: cast_nullable_to_non_nullable
as int?,minDiscountPct: freezed == minDiscountPct ? _self.minDiscountPct : minDiscountPct // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchlistUpsertRequest].
extension WatchlistUpsertRequestPatterns on WatchlistUpsertRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchlistUpsertRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchlistUpsertRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchlistUpsertRequest value)  $default,){
final _that = this;
switch (_that) {
case _WatchlistUpsertRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchlistUpsertRequest value)?  $default,){
final _that = this;
switch (_that) {
case _WatchlistUpsertRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? targetPrice,  int? minDiscountPct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchlistUpsertRequest() when $default != null:
return $default(_that.targetPrice,_that.minDiscountPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? targetPrice,  int? minDiscountPct)  $default,) {final _that = this;
switch (_that) {
case _WatchlistUpsertRequest():
return $default(_that.targetPrice,_that.minDiscountPct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? targetPrice,  int? minDiscountPct)?  $default,) {final _that = this;
switch (_that) {
case _WatchlistUpsertRequest() when $default != null:
return $default(_that.targetPrice,_that.minDiscountPct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchlistUpsertRequest extends WatchlistUpsertRequest {
  const _WatchlistUpsertRequest({this.targetPrice, this.minDiscountPct}): super._();
  factory _WatchlistUpsertRequest.fromJson(Map<String, dynamic> json) => _$WatchlistUpsertRequestFromJson(json);

/// Уведомить, когда цена станет не выше этой (минимальные единицы валюты).
@override final  int? targetPrice;
/// Уведомить, когда скидка станет не меньше этой, %.
@override final  int? minDiscountPct;

/// Create a copy of WatchlistUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchlistUpsertRequestCopyWith<_WatchlistUpsertRequest> get copyWith => __$WatchlistUpsertRequestCopyWithImpl<_WatchlistUpsertRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistUpsertRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchlistUpsertRequest&&(identical(other.targetPrice, targetPrice) || other.targetPrice == targetPrice)&&(identical(other.minDiscountPct, minDiscountPct) || other.minDiscountPct == minDiscountPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,targetPrice,minDiscountPct);
}

@override
String toString() {
    return 'WatchlistUpsertRequest(targetPrice: $targetPrice, minDiscountPct: $minDiscountPct)';
}


}

/// @nodoc
abstract mixin class _$WatchlistUpsertRequestCopyWith<$Res> implements $WatchlistUpsertRequestCopyWith<$Res> {
  factory _$WatchlistUpsertRequestCopyWith(_WatchlistUpsertRequest value, $Res Function(_WatchlistUpsertRequest) _then) = __$WatchlistUpsertRequestCopyWithImpl;
@override @useResult
$Res call({
 int? targetPrice, int? minDiscountPct
});




}
/// @nodoc
class __$WatchlistUpsertRequestCopyWithImpl<$Res>
    implements _$WatchlistUpsertRequestCopyWith<$Res> {
  __$WatchlistUpsertRequestCopyWithImpl(this._self, this._then);

  final _WatchlistUpsertRequest _self;
  final $Res Function(_WatchlistUpsertRequest) _then;

/// Create a copy of WatchlistUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetPrice = freezed,Object? minDiscountPct = freezed,}) {
  return _then(_WatchlistUpsertRequest(
targetPrice: freezed == targetPrice ? _self.targetPrice : targetPrice // ignore: cast_nullable_to_non_nullable
as int?,minDiscountPct: freezed == minDiscountPct ? _self.minDiscountPct : minDiscountPct // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$WatchlistItem {

 GameSummary get game; String get region; int? get targetPrice; int? get minDiscountPct;/// Цена, о которой уже отправлено уведомление.
 int? get lastNotifiedPrice; DateTime? get lastNotifiedAt; DateTime get createdAt;
/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistItemCopyWith<WatchlistItem> get copyWith => _$WatchlistItemCopyWithImpl<WatchlistItem>(this as WatchlistItem, _$identity);

  /// Serializes this WatchlistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WatchlistItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistItem&&(identical(other.game, _this.game) || other.game == _this.game)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.targetPrice, _this.targetPrice) || other.targetPrice == _this.targetPrice)&&(identical(other.minDiscountPct, _this.minDiscountPct) || other.minDiscountPct == _this.minDiscountPct)&&(identical(other.lastNotifiedPrice, _this.lastNotifiedPrice) || other.lastNotifiedPrice == _this.lastNotifiedPrice)&&(identical(other.lastNotifiedAt, _this.lastNotifiedAt) || other.lastNotifiedAt == _this.lastNotifiedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WatchlistItem;
  return Object.hash(runtimeType,_this.game,_this.region,_this.targetPrice,_this.minDiscountPct,_this.lastNotifiedPrice,_this.lastNotifiedAt,_this.createdAt);
}

@override
String toString() {
  final _this = this as WatchlistItem;
  return 'WatchlistItem(game: ${_this.game}, region: ${_this.region}, targetPrice: ${_this.targetPrice}, minDiscountPct: ${_this.minDiscountPct}, lastNotifiedPrice: ${_this.lastNotifiedPrice}, lastNotifiedAt: ${_this.lastNotifiedAt}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $WatchlistItemCopyWith<$Res>  {
  factory $WatchlistItemCopyWith(WatchlistItem value, $Res Function(WatchlistItem) _then) = _$WatchlistItemCopyWithImpl;
@useResult
$Res call({
 GameSummary game, String region, int? targetPrice, int? minDiscountPct, int? lastNotifiedPrice, DateTime? lastNotifiedAt, DateTime createdAt
});


$GameSummaryCopyWith<$Res> get game;

}
/// @nodoc
class _$WatchlistItemCopyWithImpl<$Res>
    implements $WatchlistItemCopyWith<$Res> {
  _$WatchlistItemCopyWithImpl(this._self, this._then);

  final WatchlistItem _self;
  final $Res Function(WatchlistItem) _then;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? game = null,Object? region = null,Object? targetPrice = freezed,Object? minDiscountPct = freezed,Object? lastNotifiedPrice = freezed,Object? lastNotifiedAt = freezed,Object? createdAt = null,}) {
  return _then(WatchlistItem(
game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as GameSummary,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,targetPrice: freezed == targetPrice ? _self.targetPrice : targetPrice // ignore: cast_nullable_to_non_nullable
as int?,minDiscountPct: freezed == minDiscountPct ? _self.minDiscountPct : minDiscountPct // ignore: cast_nullable_to_non_nullable
as int?,lastNotifiedPrice: freezed == lastNotifiedPrice ? _self.lastNotifiedPrice : lastNotifiedPrice // ignore: cast_nullable_to_non_nullable
as int?,lastNotifiedAt: freezed == lastNotifiedAt ? _self.lastNotifiedAt : lastNotifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameSummaryCopyWith<$Res> get game {
  
  return $GameSummaryCopyWith<$Res>(_self.game, (value) {
    return _then(_self.copyWith(game: value));
  });
}
}


/// Adds pattern-matching-related methods to [WatchlistItem].
extension WatchlistItemPatterns on WatchlistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchlistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchlistItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchlistItem value)  $default,){
final _that = this;
switch (_that) {
case _WatchlistItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchlistItem value)?  $default,){
final _that = this;
switch (_that) {
case _WatchlistItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GameSummary game,  String region,  int? targetPrice,  int? minDiscountPct,  int? lastNotifiedPrice,  DateTime? lastNotifiedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchlistItem() when $default != null:
return $default(_that.game,_that.region,_that.targetPrice,_that.minDiscountPct,_that.lastNotifiedPrice,_that.lastNotifiedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GameSummary game,  String region,  int? targetPrice,  int? minDiscountPct,  int? lastNotifiedPrice,  DateTime? lastNotifiedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WatchlistItem():
return $default(_that.game,_that.region,_that.targetPrice,_that.minDiscountPct,_that.lastNotifiedPrice,_that.lastNotifiedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GameSummary game,  String region,  int? targetPrice,  int? minDiscountPct,  int? lastNotifiedPrice,  DateTime? lastNotifiedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WatchlistItem() when $default != null:
return $default(_that.game,_that.region,_that.targetPrice,_that.minDiscountPct,_that.lastNotifiedPrice,_that.lastNotifiedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchlistItem extends WatchlistItem {
  const _WatchlistItem({required this.game, required this.region, this.targetPrice, this.minDiscountPct, this.lastNotifiedPrice, this.lastNotifiedAt, required this.createdAt}): super._();
  factory _WatchlistItem.fromJson(Map<String, dynamic> json) => _$WatchlistItemFromJson(json);

@override final  GameSummary game;
@override final  String region;
@override final  int? targetPrice;
@override final  int? minDiscountPct;
/// Цена, о которой уже отправлено уведомление.
@override final  int? lastNotifiedPrice;
@override final  DateTime? lastNotifiedAt;
@override final  DateTime createdAt;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchlistItemCopyWith<_WatchlistItem> get copyWith => __$WatchlistItemCopyWithImpl<_WatchlistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchlistItem&&(identical(other.game, game) || other.game == game)&&(identical(other.region, region) || other.region == region)&&(identical(other.targetPrice, targetPrice) || other.targetPrice == targetPrice)&&(identical(other.minDiscountPct, minDiscountPct) || other.minDiscountPct == minDiscountPct)&&(identical(other.lastNotifiedPrice, lastNotifiedPrice) || other.lastNotifiedPrice == lastNotifiedPrice)&&(identical(other.lastNotifiedAt, lastNotifiedAt) || other.lastNotifiedAt == lastNotifiedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,game,region,targetPrice,minDiscountPct,lastNotifiedPrice,lastNotifiedAt,createdAt);
}

@override
String toString() {
    return 'WatchlistItem(game: $game, region: $region, targetPrice: $targetPrice, minDiscountPct: $minDiscountPct, lastNotifiedPrice: $lastNotifiedPrice, lastNotifiedAt: $lastNotifiedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WatchlistItemCopyWith<$Res> implements $WatchlistItemCopyWith<$Res> {
  factory _$WatchlistItemCopyWith(_WatchlistItem value, $Res Function(_WatchlistItem) _then) = __$WatchlistItemCopyWithImpl;
@override @useResult
$Res call({
 GameSummary game, String region, int? targetPrice, int? minDiscountPct, int? lastNotifiedPrice, DateTime? lastNotifiedAt, DateTime createdAt
});


@override $GameSummaryCopyWith<$Res> get game;

}
/// @nodoc
class __$WatchlistItemCopyWithImpl<$Res>
    implements _$WatchlistItemCopyWith<$Res> {
  __$WatchlistItemCopyWithImpl(this._self, this._then);

  final _WatchlistItem _self;
  final $Res Function(_WatchlistItem) _then;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? game = null,Object? region = null,Object? targetPrice = freezed,Object? minDiscountPct = freezed,Object? lastNotifiedPrice = freezed,Object? lastNotifiedAt = freezed,Object? createdAt = null,}) {
  return _then(_WatchlistItem(
game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as GameSummary,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,targetPrice: freezed == targetPrice ? _self.targetPrice : targetPrice // ignore: cast_nullable_to_non_nullable
as int?,minDiscountPct: freezed == minDiscountPct ? _self.minDiscountPct : minDiscountPct // ignore: cast_nullable_to_non_nullable
as int?,lastNotifiedPrice: freezed == lastNotifiedPrice ? _self.lastNotifiedPrice : lastNotifiedPrice // ignore: cast_nullable_to_non_nullable
as int?,lastNotifiedAt: freezed == lastNotifiedAt ? _self.lastNotifiedAt : lastNotifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameSummaryCopyWith<$Res> get game {
  
  return $GameSummaryCopyWith<$Res>(_self.game, (value) {
    return _then(_self.copyWith(game: value));
  });
}
}

// dart format on
