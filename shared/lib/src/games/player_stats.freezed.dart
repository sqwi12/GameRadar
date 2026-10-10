// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerStats {

 int? get current;@JsonKey(name: 'peak_24h') int? get peak24h;@JsonKey(name: 'peak_7d') int? get peak7d;@JsonKey(name: 'peak_30d') int? get peak30d;/// Время последнего замера онлайна.
 DateTime? get checkedAt;
/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStatsCopyWith<PlayerStats> get copyWith => _$PlayerStatsCopyWithImpl<PlayerStats>(this as PlayerStats, _$identity);

  /// Serializes this PlayerStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerStats&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.peak24h, _this.peak24h) || other.peak24h == _this.peak24h)&&(identical(other.peak7d, _this.peak7d) || other.peak7d == _this.peak7d)&&(identical(other.peak30d, _this.peak30d) || other.peak30d == _this.peak30d)&&(identical(other.checkedAt, _this.checkedAt) || other.checkedAt == _this.checkedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerStats;
  return Object.hash(runtimeType,_this.current,_this.peak24h,_this.peak7d,_this.peak30d,_this.checkedAt);
}

@override
String toString() {
  final _this = this as PlayerStats;
  return 'PlayerStats(current: ${_this.current}, peak24h: ${_this.peak24h}, peak7d: ${_this.peak7d}, peak30d: ${_this.peak30d}, checkedAt: ${_this.checkedAt})';
}


}

/// @nodoc
abstract mixin class $PlayerStatsCopyWith<$Res>  {
  factory $PlayerStatsCopyWith(PlayerStats value, $Res Function(PlayerStats) _then) = _$PlayerStatsCopyWithImpl;
@useResult
$Res call({
 int? current,@JsonKey(name: 'peak_24h') int? peak24h,@JsonKey(name: 'peak_7d') int? peak7d,@JsonKey(name: 'peak_30d') int? peak30d, DateTime? checkedAt
});




}
/// @nodoc
class _$PlayerStatsCopyWithImpl<$Res>
    implements $PlayerStatsCopyWith<$Res> {
  _$PlayerStatsCopyWithImpl(this._self, this._then);

  final PlayerStats _self;
  final $Res Function(PlayerStats) _then;

/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = freezed,Object? peak24h = freezed,Object? peak7d = freezed,Object? peak30d = freezed,Object? checkedAt = freezed,}) {
  return _then(PlayerStats(
current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int?,peak24h: freezed == peak24h ? _self.peak24h : peak24h // ignore: cast_nullable_to_non_nullable
as int?,peak7d: freezed == peak7d ? _self.peak7d : peak7d // ignore: cast_nullable_to_non_nullable
as int?,peak30d: freezed == peak30d ? _self.peak30d : peak30d // ignore: cast_nullable_to_non_nullable
as int?,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerStats].
extension PlayerStatsPatterns on PlayerStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerStats value)  $default,){
final _that = this;
switch (_that) {
case _PlayerStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerStats value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? current, @JsonKey(name: 'peak_24h')  int? peak24h, @JsonKey(name: 'peak_7d')  int? peak7d, @JsonKey(name: 'peak_30d')  int? peak30d,  DateTime? checkedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
return $default(_that.current,_that.peak24h,_that.peak7d,_that.peak30d,_that.checkedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? current, @JsonKey(name: 'peak_24h')  int? peak24h, @JsonKey(name: 'peak_7d')  int? peak7d, @JsonKey(name: 'peak_30d')  int? peak30d,  DateTime? checkedAt)  $default,) {final _that = this;
switch (_that) {
case _PlayerStats():
return $default(_that.current,_that.peak24h,_that.peak7d,_that.peak30d,_that.checkedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? current, @JsonKey(name: 'peak_24h')  int? peak24h, @JsonKey(name: 'peak_7d')  int? peak7d, @JsonKey(name: 'peak_30d')  int? peak30d,  DateTime? checkedAt)?  $default,) {final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
return $default(_that.current,_that.peak24h,_that.peak7d,_that.peak30d,_that.checkedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerStats implements PlayerStats {
  const _PlayerStats({this.current, @JsonKey(name: 'peak_24h') this.peak24h, @JsonKey(name: 'peak_7d') this.peak7d, @JsonKey(name: 'peak_30d') this.peak30d, this.checkedAt});
  factory _PlayerStats.fromJson(Map<String, dynamic> json) => _$PlayerStatsFromJson(json);

@override final  int? current;
@override@JsonKey(name: 'peak_24h') final  int? peak24h;
@override@JsonKey(name: 'peak_7d') final  int? peak7d;
@override@JsonKey(name: 'peak_30d') final  int? peak30d;
/// Время последнего замера онлайна.
@override final  DateTime? checkedAt;

/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStatsCopyWith<_PlayerStats> get copyWith => __$PlayerStatsCopyWithImpl<_PlayerStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerStats&&(identical(other.current, current) || other.current == current)&&(identical(other.peak24h, peak24h) || other.peak24h == peak24h)&&(identical(other.peak7d, peak7d) || other.peak7d == peak7d)&&(identical(other.peak30d, peak30d) || other.peak30d == peak30d)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,current,peak24h,peak7d,peak30d,checkedAt);
}

@override
String toString() {
    return 'PlayerStats(current: $current, peak24h: $peak24h, peak7d: $peak7d, peak30d: $peak30d, checkedAt: $checkedAt)';
}


}

/// @nodoc
abstract mixin class _$PlayerStatsCopyWith<$Res> implements $PlayerStatsCopyWith<$Res> {
  factory _$PlayerStatsCopyWith(_PlayerStats value, $Res Function(_PlayerStats) _then) = __$PlayerStatsCopyWithImpl;
@override @useResult
$Res call({
 int? current,@JsonKey(name: 'peak_24h') int? peak24h,@JsonKey(name: 'peak_7d') int? peak7d,@JsonKey(name: 'peak_30d') int? peak30d, DateTime? checkedAt
});




}
/// @nodoc
class __$PlayerStatsCopyWithImpl<$Res>
    implements _$PlayerStatsCopyWith<$Res> {
  __$PlayerStatsCopyWithImpl(this._self, this._then);

  final _PlayerStats _self;
  final $Res Function(_PlayerStats) _then;

/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = freezed,Object? peak24h = freezed,Object? peak7d = freezed,Object? peak30d = freezed,Object? checkedAt = freezed,}) {
  return _then(_PlayerStats(
current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int?,peak24h: freezed == peak24h ? _self.peak24h : peak24h // ignore: cast_nullable_to_non_nullable
as int?,peak7d: freezed == peak7d ? _self.peak7d : peak7d // ignore: cast_nullable_to_non_nullable
as int?,peak30d: freezed == peak30d ? _self.peak30d : peak30d // ignore: cast_nullable_to_non_nullable
as int?,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
