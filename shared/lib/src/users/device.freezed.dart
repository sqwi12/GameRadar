// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceRegisterRequest {

 String get fcmToken; DevicePlatform get platform;
/// Create a copy of DeviceRegisterRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceRegisterRequestCopyWith<DeviceRegisterRequest> get copyWith => _$DeviceRegisterRequestCopyWithImpl<DeviceRegisterRequest>(this as DeviceRegisterRequest, _$identity);

  /// Serializes this DeviceRegisterRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceRegisterRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceRegisterRequest&&(identical(other.fcmToken, _this.fcmToken) || other.fcmToken == _this.fcmToken)&&(identical(other.platform, _this.platform) || other.platform == _this.platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceRegisterRequest;
  return Object.hash(runtimeType,_this.fcmToken,_this.platform);
}

@override
String toString() {
  final _this = this as DeviceRegisterRequest;
  return 'DeviceRegisterRequest(fcmToken: ${_this.fcmToken}, platform: ${_this.platform})';
}


}

/// @nodoc
abstract mixin class $DeviceRegisterRequestCopyWith<$Res>  {
  factory $DeviceRegisterRequestCopyWith(DeviceRegisterRequest value, $Res Function(DeviceRegisterRequest) _then) = _$DeviceRegisterRequestCopyWithImpl;
@useResult
$Res call({
 String fcmToken, DevicePlatform platform
});




}
/// @nodoc
class _$DeviceRegisterRequestCopyWithImpl<$Res>
    implements $DeviceRegisterRequestCopyWith<$Res> {
  _$DeviceRegisterRequestCopyWithImpl(this._self, this._then);

  final DeviceRegisterRequest _self;
  final $Res Function(DeviceRegisterRequest) _then;

/// Create a copy of DeviceRegisterRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fcmToken = null,Object? platform = null,}) {
  return _then(DeviceRegisterRequest(
fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as DevicePlatform,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceRegisterRequest].
extension DeviceRegisterRequestPatterns on DeviceRegisterRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceRegisterRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceRegisterRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceRegisterRequest value)  $default,){
final _that = this;
switch (_that) {
case _DeviceRegisterRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceRegisterRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceRegisterRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fcmToken,  DevicePlatform platform)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceRegisterRequest() when $default != null:
return $default(_that.fcmToken,_that.platform);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fcmToken,  DevicePlatform platform)  $default,) {final _that = this;
switch (_that) {
case _DeviceRegisterRequest():
return $default(_that.fcmToken,_that.platform);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fcmToken,  DevicePlatform platform)?  $default,) {final _that = this;
switch (_that) {
case _DeviceRegisterRequest() when $default != null:
return $default(_that.fcmToken,_that.platform);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceRegisterRequest extends DeviceRegisterRequest {
  const _DeviceRegisterRequest({required this.fcmToken, required this.platform}): super._();
  factory _DeviceRegisterRequest.fromJson(Map<String, dynamic> json) => _$DeviceRegisterRequestFromJson(json);

@override final  String fcmToken;
@override final  DevicePlatform platform;

/// Create a copy of DeviceRegisterRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceRegisterRequestCopyWith<_DeviceRegisterRequest> get copyWith => __$DeviceRegisterRequestCopyWithImpl<_DeviceRegisterRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceRegisterRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceRegisterRequest&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,fcmToken,platform);
}

@override
String toString() {
    return 'DeviceRegisterRequest(fcmToken: $fcmToken, platform: $platform)';
}


}

/// @nodoc
abstract mixin class _$DeviceRegisterRequestCopyWith<$Res> implements $DeviceRegisterRequestCopyWith<$Res> {
  factory _$DeviceRegisterRequestCopyWith(_DeviceRegisterRequest value, $Res Function(_DeviceRegisterRequest) _then) = __$DeviceRegisterRequestCopyWithImpl;
@override @useResult
$Res call({
 String fcmToken, DevicePlatform platform
});




}
/// @nodoc
class __$DeviceRegisterRequestCopyWithImpl<$Res>
    implements _$DeviceRegisterRequestCopyWith<$Res> {
  __$DeviceRegisterRequestCopyWithImpl(this._self, this._then);

  final _DeviceRegisterRequest _self;
  final $Res Function(_DeviceRegisterRequest) _then;

/// Create a copy of DeviceRegisterRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fcmToken = null,Object? platform = null,}) {
  return _then(_DeviceRegisterRequest(
fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as DevicePlatform,
  ));
}


}

// dart format on
