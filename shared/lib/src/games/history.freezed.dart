// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerCountPoint {

 DateTime get recordedAt; int get players;
/// Create a copy of PlayerCountPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCountPointCopyWith<PlayerCountPoint> get copyWith => _$PlayerCountPointCopyWithImpl<PlayerCountPoint>(this as PlayerCountPoint, _$identity);

  /// Serializes this PlayerCountPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerCountPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerCountPoint&&(identical(other.recordedAt, _this.recordedAt) || other.recordedAt == _this.recordedAt)&&(identical(other.players, _this.players) || other.players == _this.players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerCountPoint;
  return Object.hash(runtimeType,_this.recordedAt,_this.players);
}

@override
String toString() {
  final _this = this as PlayerCountPoint;
  return 'PlayerCountPoint(recordedAt: ${_this.recordedAt}, players: ${_this.players})';
}


}

/// @nodoc
abstract mixin class $PlayerCountPointCopyWith<$Res>  {
  factory $PlayerCountPointCopyWith(PlayerCountPoint value, $Res Function(PlayerCountPoint) _then) = _$PlayerCountPointCopyWithImpl;
@useResult
$Res call({
 DateTime recordedAt, int players
});




}
/// @nodoc
class _$PlayerCountPointCopyWithImpl<$Res>
    implements $PlayerCountPointCopyWith<$Res> {
  _$PlayerCountPointCopyWithImpl(this._self, this._then);

  final PlayerCountPoint _self;
  final $Res Function(PlayerCountPoint) _then;

/// Create a copy of PlayerCountPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recordedAt = null,Object? players = null,}) {
  return _then(PlayerCountPoint(
recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerCountPoint].
extension PlayerCountPointPatterns on PlayerCountPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerCountPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerCountPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerCountPoint value)  $default,){
final _that = this;
switch (_that) {
case _PlayerCountPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerCountPoint value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerCountPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime recordedAt,  int players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerCountPoint() when $default != null:
return $default(_that.recordedAt,_that.players);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime recordedAt,  int players)  $default,) {final _that = this;
switch (_that) {
case _PlayerCountPoint():
return $default(_that.recordedAt,_that.players);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime recordedAt,  int players)?  $default,) {final _that = this;
switch (_that) {
case _PlayerCountPoint() when $default != null:
return $default(_that.recordedAt,_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerCountPoint implements PlayerCountPoint {
  const _PlayerCountPoint({required this.recordedAt, required this.players});
  factory _PlayerCountPoint.fromJson(Map<String, dynamic> json) => _$PlayerCountPointFromJson(json);

@override final  DateTime recordedAt;
@override final  int players;

/// Create a copy of PlayerCountPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerCountPointCopyWith<_PlayerCountPoint> get copyWith => __$PlayerCountPointCopyWithImpl<_PlayerCountPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerCountPointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerCountPoint&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.players, players) || other.players == players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,recordedAt,players);
}

@override
String toString() {
    return 'PlayerCountPoint(recordedAt: $recordedAt, players: $players)';
}


}

/// @nodoc
abstract mixin class _$PlayerCountPointCopyWith<$Res> implements $PlayerCountPointCopyWith<$Res> {
  factory _$PlayerCountPointCopyWith(_PlayerCountPoint value, $Res Function(_PlayerCountPoint) _then) = __$PlayerCountPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime recordedAt, int players
});




}
/// @nodoc
class __$PlayerCountPointCopyWithImpl<$Res>
    implements _$PlayerCountPointCopyWith<$Res> {
  __$PlayerCountPointCopyWithImpl(this._self, this._then);

  final _PlayerCountPoint _self;
  final $Res Function(_PlayerCountPoint) _then;

/// Create a copy of PlayerCountPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recordedAt = null,Object? players = null,}) {
  return _then(_PlayerCountPoint(
recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PlayerHistory {

 int get appId; HistoryPeriod get period; List<PlayerCountPoint> get points;
/// Create a copy of PlayerHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerHistoryCopyWith<PlayerHistory> get copyWith => _$PlayerHistoryCopyWithImpl<PlayerHistory>(this as PlayerHistory, _$identity);

  /// Serializes this PlayerHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerHistory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerHistory&&(identical(other.appId, _this.appId) || other.appId == _this.appId)&&(identical(other.period, _this.period) || other.period == _this.period)&&const DeepCollectionEquality().equals(other.points, _this.points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerHistory;
  return Object.hash(runtimeType,_this.appId,_this.period,const DeepCollectionEquality().hash(_this.points));
}

@override
String toString() {
  final _this = this as PlayerHistory;
  return 'PlayerHistory(appId: ${_this.appId}, period: ${_this.period}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $PlayerHistoryCopyWith<$Res>  {
  factory $PlayerHistoryCopyWith(PlayerHistory value, $Res Function(PlayerHistory) _then) = _$PlayerHistoryCopyWithImpl;
@useResult
$Res call({
 int appId, HistoryPeriod period, List<PlayerCountPoint> points
});




}
/// @nodoc
class _$PlayerHistoryCopyWithImpl<$Res>
    implements $PlayerHistoryCopyWith<$Res> {
  _$PlayerHistoryCopyWithImpl(this._self, this._then);

  final PlayerHistory _self;
  final $Res Function(PlayerHistory) _then;

/// Create a copy of PlayerHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appId = null,Object? period = null,Object? points = null,}) {
  return _then(PlayerHistory(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as HistoryPeriod,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<PlayerCountPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerHistory].
extension PlayerHistoryPatterns on PlayerHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerHistory value)  $default,){
final _that = this;
switch (_that) {
case _PlayerHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int appId,  HistoryPeriod period,  List<PlayerCountPoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerHistory() when $default != null:
return $default(_that.appId,_that.period,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int appId,  HistoryPeriod period,  List<PlayerCountPoint> points)  $default,) {final _that = this;
switch (_that) {
case _PlayerHistory():
return $default(_that.appId,_that.period,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int appId,  HistoryPeriod period,  List<PlayerCountPoint> points)?  $default,) {final _that = this;
switch (_that) {
case _PlayerHistory() when $default != null:
return $default(_that.appId,_that.period,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerHistory implements PlayerHistory {
  const _PlayerHistory({required this.appId, required this.period, required  List<PlayerCountPoint> points}): _points = points;
  factory _PlayerHistory.fromJson(Map<String, dynamic> json) => _$PlayerHistoryFromJson(json);

@override final  int appId;
@override final  HistoryPeriod period;
 final  List<PlayerCountPoint> _points;
@override List<PlayerCountPoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of PlayerHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerHistoryCopyWith<_PlayerHistory> get copyWith => __$PlayerHistoryCopyWithImpl<_PlayerHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerHistory&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.period, period) || other.period == period)&&const DeepCollectionEquality().equals(other.points, _points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,appId,period,const DeepCollectionEquality().hash(_points));
}

@override
String toString() {
    return 'PlayerHistory(appId: $appId, period: $period, points: $points)';
}


}

/// @nodoc
abstract mixin class _$PlayerHistoryCopyWith<$Res> implements $PlayerHistoryCopyWith<$Res> {
  factory _$PlayerHistoryCopyWith(_PlayerHistory value, $Res Function(_PlayerHistory) _then) = __$PlayerHistoryCopyWithImpl;
@override @useResult
$Res call({
 int appId, HistoryPeriod period, List<PlayerCountPoint> points
});




}
/// @nodoc
class __$PlayerHistoryCopyWithImpl<$Res>
    implements _$PlayerHistoryCopyWith<$Res> {
  __$PlayerHistoryCopyWithImpl(this._self, this._then);

  final _PlayerHistory _self;
  final $Res Function(_PlayerHistory) _then;

/// Create a copy of PlayerHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appId = null,Object? period = null,Object? points = null,}) {
  return _then(_PlayerHistory(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as HistoryPeriod,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<PlayerCountPoint>,
  ));
}


}


/// @nodoc
mixin _$PriceHistoryEntry {

 DateTime get recordedAt; bool get isAvailable; String? get currency; int? get initialPrice; int? get finalPrice; int get discountPct;
/// Create a copy of PriceHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceHistoryEntryCopyWith<PriceHistoryEntry> get copyWith => _$PriceHistoryEntryCopyWithImpl<PriceHistoryEntry>(this as PriceHistoryEntry, _$identity);

  /// Serializes this PriceHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PriceHistoryEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHistoryEntry&&(identical(other.recordedAt, _this.recordedAt) || other.recordedAt == _this.recordedAt)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.initialPrice, _this.initialPrice) || other.initialPrice == _this.initialPrice)&&(identical(other.finalPrice, _this.finalPrice) || other.finalPrice == _this.finalPrice)&&(identical(other.discountPct, _this.discountPct) || other.discountPct == _this.discountPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PriceHistoryEntry;
  return Object.hash(runtimeType,_this.recordedAt,_this.isAvailable,_this.currency,_this.initialPrice,_this.finalPrice,_this.discountPct);
}

@override
String toString() {
  final _this = this as PriceHistoryEntry;
  return 'PriceHistoryEntry(recordedAt: ${_this.recordedAt}, isAvailable: ${_this.isAvailable}, currency: ${_this.currency}, initialPrice: ${_this.initialPrice}, finalPrice: ${_this.finalPrice}, discountPct: ${_this.discountPct})';
}


}

/// @nodoc
abstract mixin class $PriceHistoryEntryCopyWith<$Res>  {
  factory $PriceHistoryEntryCopyWith(PriceHistoryEntry value, $Res Function(PriceHistoryEntry) _then) = _$PriceHistoryEntryCopyWithImpl;
@useResult
$Res call({
 DateTime recordedAt, bool isAvailable, String? currency, int? initialPrice, int? finalPrice, int discountPct
});




}
/// @nodoc
class _$PriceHistoryEntryCopyWithImpl<$Res>
    implements $PriceHistoryEntryCopyWith<$Res> {
  _$PriceHistoryEntryCopyWithImpl(this._self, this._then);

  final PriceHistoryEntry _self;
  final $Res Function(PriceHistoryEntry) _then;

/// Create a copy of PriceHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recordedAt = null,Object? isAvailable = null,Object? currency = freezed,Object? initialPrice = freezed,Object? finalPrice = freezed,Object? discountPct = null,}) {
  return _then(PriceHistoryEntry(
recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,initialPrice: freezed == initialPrice ? _self.initialPrice : initialPrice // ignore: cast_nullable_to_non_nullable
as int?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int?,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceHistoryEntry].
extension PriceHistoryEntryPatterns on PriceHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _PriceHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PriceHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime recordedAt,  bool isAvailable,  String? currency,  int? initialPrice,  int? finalPrice,  int discountPct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceHistoryEntry() when $default != null:
return $default(_that.recordedAt,_that.isAvailable,_that.currency,_that.initialPrice,_that.finalPrice,_that.discountPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime recordedAt,  bool isAvailable,  String? currency,  int? initialPrice,  int? finalPrice,  int discountPct)  $default,) {final _that = this;
switch (_that) {
case _PriceHistoryEntry():
return $default(_that.recordedAt,_that.isAvailable,_that.currency,_that.initialPrice,_that.finalPrice,_that.discountPct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime recordedAt,  bool isAvailable,  String? currency,  int? initialPrice,  int? finalPrice,  int discountPct)?  $default,) {final _that = this;
switch (_that) {
case _PriceHistoryEntry() when $default != null:
return $default(_that.recordedAt,_that.isAvailable,_that.currency,_that.initialPrice,_that.finalPrice,_that.discountPct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceHistoryEntry implements PriceHistoryEntry {
  const _PriceHistoryEntry({required this.recordedAt, required this.isAvailable, this.currency, this.initialPrice, this.finalPrice, this.discountPct = 0});
  factory _PriceHistoryEntry.fromJson(Map<String, dynamic> json) => _$PriceHistoryEntryFromJson(json);

@override final  DateTime recordedAt;
@override final  bool isAvailable;
@override final  String? currency;
@override final  int? initialPrice;
@override final  int? finalPrice;
@override@JsonKey() final  int discountPct;

/// Create a copy of PriceHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceHistoryEntryCopyWith<_PriceHistoryEntry> get copyWith => __$PriceHistoryEntryCopyWithImpl<_PriceHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceHistoryEntry&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.initialPrice, initialPrice) || other.initialPrice == initialPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.discountPct, discountPct) || other.discountPct == discountPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,recordedAt,isAvailable,currency,initialPrice,finalPrice,discountPct);
}

@override
String toString() {
    return 'PriceHistoryEntry(recordedAt: $recordedAt, isAvailable: $isAvailable, currency: $currency, initialPrice: $initialPrice, finalPrice: $finalPrice, discountPct: $discountPct)';
}


}

/// @nodoc
abstract mixin class _$PriceHistoryEntryCopyWith<$Res> implements $PriceHistoryEntryCopyWith<$Res> {
  factory _$PriceHistoryEntryCopyWith(_PriceHistoryEntry value, $Res Function(_PriceHistoryEntry) _then) = __$PriceHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime recordedAt, bool isAvailable, String? currency, int? initialPrice, int? finalPrice, int discountPct
});




}
/// @nodoc
class __$PriceHistoryEntryCopyWithImpl<$Res>
    implements _$PriceHistoryEntryCopyWith<$Res> {
  __$PriceHistoryEntryCopyWithImpl(this._self, this._then);

  final _PriceHistoryEntry _self;
  final $Res Function(_PriceHistoryEntry) _then;

/// Create a copy of PriceHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recordedAt = null,Object? isAvailable = null,Object? currency = freezed,Object? initialPrice = freezed,Object? finalPrice = freezed,Object? discountPct = null,}) {
  return _then(_PriceHistoryEntry(
recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,initialPrice: freezed == initialPrice ? _self.initialPrice : initialPrice // ignore: cast_nullable_to_non_nullable
as int?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int?,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
