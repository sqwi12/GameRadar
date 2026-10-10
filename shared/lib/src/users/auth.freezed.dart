// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnonymousAuthRequest {

 String get deviceId;/// Начальные настройки при первом входе (язык и часовой пояс устройства).
/// Для уже существующего пользователя игнорируются.
 UserSettings? get initialSettings;
/// Create a copy of AnonymousAuthRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnonymousAuthRequestCopyWith<AnonymousAuthRequest> get copyWith => _$AnonymousAuthRequestCopyWithImpl<AnonymousAuthRequest>(this as AnonymousAuthRequest, _$identity);

  /// Serializes this AnonymousAuthRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AnonymousAuthRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnonymousAuthRequest&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.initialSettings, _this.initialSettings) || other.initialSettings == _this.initialSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AnonymousAuthRequest;
  return Object.hash(runtimeType,_this.deviceId,_this.initialSettings);
}

@override
String toString() {
  final _this = this as AnonymousAuthRequest;
  return 'AnonymousAuthRequest(deviceId: ${_this.deviceId}, initialSettings: ${_this.initialSettings})';
}


}

/// @nodoc
abstract mixin class $AnonymousAuthRequestCopyWith<$Res>  {
  factory $AnonymousAuthRequestCopyWith(AnonymousAuthRequest value, $Res Function(AnonymousAuthRequest) _then) = _$AnonymousAuthRequestCopyWithImpl;
@useResult
$Res call({
 String deviceId, UserSettings? initialSettings
});


$UserSettingsCopyWith<$Res>? get initialSettings;

}
/// @nodoc
class _$AnonymousAuthRequestCopyWithImpl<$Res>
    implements $AnonymousAuthRequestCopyWith<$Res> {
  _$AnonymousAuthRequestCopyWithImpl(this._self, this._then);

  final AnonymousAuthRequest _self;
  final $Res Function(AnonymousAuthRequest) _then;

/// Create a copy of AnonymousAuthRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? initialSettings = freezed,}) {
  return _then(AnonymousAuthRequest(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,initialSettings: freezed == initialSettings ? _self.initialSettings : initialSettings // ignore: cast_nullable_to_non_nullable
as UserSettings?,
  ));
}
/// Create a copy of AnonymousAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res>? get initialSettings {
    if (_self.initialSettings == null) {
    return null;
  }

  return $UserSettingsCopyWith<$Res>(_self.initialSettings!, (value) {
    return _then(_self.copyWith(initialSettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnonymousAuthRequest].
extension AnonymousAuthRequestPatterns on AnonymousAuthRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnonymousAuthRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnonymousAuthRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnonymousAuthRequest value)  $default,){
final _that = this;
switch (_that) {
case _AnonymousAuthRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnonymousAuthRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AnonymousAuthRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  UserSettings? initialSettings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnonymousAuthRequest() when $default != null:
return $default(_that.deviceId,_that.initialSettings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  UserSettings? initialSettings)  $default,) {final _that = this;
switch (_that) {
case _AnonymousAuthRequest():
return $default(_that.deviceId,_that.initialSettings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  UserSettings? initialSettings)?  $default,) {final _that = this;
switch (_that) {
case _AnonymousAuthRequest() when $default != null:
return $default(_that.deviceId,_that.initialSettings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnonymousAuthRequest extends AnonymousAuthRequest {
  const _AnonymousAuthRequest({required this.deviceId, this.initialSettings}): super._();
  factory _AnonymousAuthRequest.fromJson(Map<String, dynamic> json) => _$AnonymousAuthRequestFromJson(json);

@override final  String deviceId;
/// Начальные настройки при первом входе (язык и часовой пояс устройства).
/// Для уже существующего пользователя игнорируются.
@override final  UserSettings? initialSettings;

/// Create a copy of AnonymousAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnonymousAuthRequestCopyWith<_AnonymousAuthRequest> get copyWith => __$AnonymousAuthRequestCopyWithImpl<_AnonymousAuthRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnonymousAuthRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnonymousAuthRequest&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.initialSettings, initialSettings) || other.initialSettings == initialSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,initialSettings);
}

@override
String toString() {
    return 'AnonymousAuthRequest(deviceId: $deviceId, initialSettings: $initialSettings)';
}


}

/// @nodoc
abstract mixin class _$AnonymousAuthRequestCopyWith<$Res> implements $AnonymousAuthRequestCopyWith<$Res> {
  factory _$AnonymousAuthRequestCopyWith(_AnonymousAuthRequest value, $Res Function(_AnonymousAuthRequest) _then) = __$AnonymousAuthRequestCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, UserSettings? initialSettings
});


@override $UserSettingsCopyWith<$Res>? get initialSettings;

}
/// @nodoc
class __$AnonymousAuthRequestCopyWithImpl<$Res>
    implements _$AnonymousAuthRequestCopyWith<$Res> {
  __$AnonymousAuthRequestCopyWithImpl(this._self, this._then);

  final _AnonymousAuthRequest _self;
  final $Res Function(_AnonymousAuthRequest) _then;

/// Create a copy of AnonymousAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? initialSettings = freezed,}) {
  return _then(_AnonymousAuthRequest(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,initialSettings: freezed == initialSettings ? _self.initialSettings : initialSettings // ignore: cast_nullable_to_non_nullable
as UserSettings?,
  ));
}

/// Create a copy of AnonymousAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res>? get initialSettings {
    if (_self.initialSettings == null) {
    return null;
  }

  return $UserSettingsCopyWith<$Res>(_self.initialSettings!, (value) {
    return _then(_self.copyWith(initialSettings: value));
  });
}
}


/// @nodoc
mixin _$AuthResponse {

 String get accessToken; DateTime get expiresAt; UserProfile get user;
/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthResponseCopyWith<AuthResponse> get copyWith => _$AuthResponseCopyWithImpl<AuthResponse>(this as AuthResponse, _$identity);

  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuthResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthResponse&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.user, _this.user) || other.user == _this.user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuthResponse;
  return Object.hash(runtimeType,_this.accessToken,_this.expiresAt,_this.user);
}

@override
String toString() {
  final _this = this as AuthResponse;
  return 'AuthResponse(accessToken: ${_this.accessToken}, expiresAt: ${_this.expiresAt}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $AuthResponseCopyWith<$Res>  {
  factory $AuthResponseCopyWith(AuthResponse value, $Res Function(AuthResponse) _then) = _$AuthResponseCopyWithImpl;
@useResult
$Res call({
 String accessToken, DateTime expiresAt, UserProfile user
});


$UserProfileCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthResponseCopyWithImpl<$Res>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._self, this._then);

  final AuthResponse _self;
  final $Res Function(AuthResponse) _then;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? expiresAt = null,Object? user = null,}) {
  return _then(AuthResponse(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserProfile,
  ));
}
/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get user {
  
  return $UserProfileCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthResponse].
extension AuthResponsePatterns on AuthResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthResponse value)  $default,){
final _that = this;
switch (_that) {
case _AuthResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AuthResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  DateTime expiresAt,  UserProfile user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthResponse() when $default != null:
return $default(_that.accessToken,_that.expiresAt,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  DateTime expiresAt,  UserProfile user)  $default,) {final _that = this;
switch (_that) {
case _AuthResponse():
return $default(_that.accessToken,_that.expiresAt,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  DateTime expiresAt,  UserProfile user)?  $default,) {final _that = this;
switch (_that) {
case _AuthResponse() when $default != null:
return $default(_that.accessToken,_that.expiresAt,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthResponse implements AuthResponse {
  const _AuthResponse({required this.accessToken, required this.expiresAt, required this.user});
  factory _AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

@override final  String accessToken;
@override final  DateTime expiresAt;
@override final  UserProfile user;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthResponseCopyWith<_AuthResponse> get copyWith => __$AuthResponseCopyWithImpl<_AuthResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthResponse&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,expiresAt,user);
}

@override
String toString() {
    return 'AuthResponse(accessToken: $accessToken, expiresAt: $expiresAt, user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthResponseCopyWith<$Res> implements $AuthResponseCopyWith<$Res> {
  factory _$AuthResponseCopyWith(_AuthResponse value, $Res Function(_AuthResponse) _then) = __$AuthResponseCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, DateTime expiresAt, UserProfile user
});


@override $UserProfileCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthResponseCopyWithImpl<$Res>
    implements _$AuthResponseCopyWith<$Res> {
  __$AuthResponseCopyWithImpl(this._self, this._then);

  final _AuthResponse _self;
  final $Res Function(_AuthResponse) _then;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? expiresAt = null,Object? user = null,}) {
  return _then(_AuthResponse(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserProfile,
  ));
}

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get user {
  
  return $UserProfileCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
