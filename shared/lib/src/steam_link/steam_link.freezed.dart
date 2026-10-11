// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'steam_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SteamLink {

/// Что ввёл пользователь (ссылка или ник).
 String get profileInput; SteamLinkStatus get status; String? get steamId; String? get personaName;/// Игр в списке желаемого Steam и сколько из них в отслеживаемых
/// (меньше, если упёрлись в лимит списка).
 int? get wishlistCount; int? get importedCount;/// Порог скидки для импортированных игр.
 int get importMinDiscountPct; DateTime? get syncedAt;
/// Create a copy of SteamLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SteamLinkCopyWith<SteamLink> get copyWith => _$SteamLinkCopyWithImpl<SteamLink>(this as SteamLink, _$identity);

  /// Serializes this SteamLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SteamLink;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SteamLink&&(identical(other.profileInput, _this.profileInput) || other.profileInput == _this.profileInput)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.steamId, _this.steamId) || other.steamId == _this.steamId)&&(identical(other.personaName, _this.personaName) || other.personaName == _this.personaName)&&(identical(other.wishlistCount, _this.wishlistCount) || other.wishlistCount == _this.wishlistCount)&&(identical(other.importedCount, _this.importedCount) || other.importedCount == _this.importedCount)&&(identical(other.importMinDiscountPct, _this.importMinDiscountPct) || other.importMinDiscountPct == _this.importMinDiscountPct)&&(identical(other.syncedAt, _this.syncedAt) || other.syncedAt == _this.syncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SteamLink;
  return Object.hash(runtimeType,_this.profileInput,_this.status,_this.steamId,_this.personaName,_this.wishlistCount,_this.importedCount,_this.importMinDiscountPct,_this.syncedAt);
}

@override
String toString() {
  final _this = this as SteamLink;
  return 'SteamLink(profileInput: ${_this.profileInput}, status: ${_this.status}, steamId: ${_this.steamId}, personaName: ${_this.personaName}, wishlistCount: ${_this.wishlistCount}, importedCount: ${_this.importedCount}, importMinDiscountPct: ${_this.importMinDiscountPct}, syncedAt: ${_this.syncedAt})';
}


}

/// @nodoc
abstract mixin class $SteamLinkCopyWith<$Res>  {
  factory $SteamLinkCopyWith(SteamLink value, $Res Function(SteamLink) _then) = _$SteamLinkCopyWithImpl;
@useResult
$Res call({
 String profileInput, SteamLinkStatus status, String? steamId, String? personaName, int? wishlistCount, int? importedCount, int importMinDiscountPct, DateTime? syncedAt
});




}
/// @nodoc
class _$SteamLinkCopyWithImpl<$Res>
    implements $SteamLinkCopyWith<$Res> {
  _$SteamLinkCopyWithImpl(this._self, this._then);

  final SteamLink _self;
  final $Res Function(SteamLink) _then;

/// Create a copy of SteamLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileInput = null,Object? status = null,Object? steamId = freezed,Object? personaName = freezed,Object? wishlistCount = freezed,Object? importedCount = freezed,Object? importMinDiscountPct = null,Object? syncedAt = freezed,}) {
  return _then(SteamLink(
profileInput: null == profileInput ? _self.profileInput : profileInput // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SteamLinkStatus,steamId: freezed == steamId ? _self.steamId : steamId // ignore: cast_nullable_to_non_nullable
as String?,personaName: freezed == personaName ? _self.personaName : personaName // ignore: cast_nullable_to_non_nullable
as String?,wishlistCount: freezed == wishlistCount ? _self.wishlistCount : wishlistCount // ignore: cast_nullable_to_non_nullable
as int?,importedCount: freezed == importedCount ? _self.importedCount : importedCount // ignore: cast_nullable_to_non_nullable
as int?,importMinDiscountPct: null == importMinDiscountPct ? _self.importMinDiscountPct : importMinDiscountPct // ignore: cast_nullable_to_non_nullable
as int,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SteamLink].
extension SteamLinkPatterns on SteamLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SteamLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SteamLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SteamLink value)  $default,){
final _that = this;
switch (_that) {
case _SteamLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SteamLink value)?  $default,){
final _that = this;
switch (_that) {
case _SteamLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String profileInput,  SteamLinkStatus status,  String? steamId,  String? personaName,  int? wishlistCount,  int? importedCount,  int importMinDiscountPct,  DateTime? syncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SteamLink() when $default != null:
return $default(_that.profileInput,_that.status,_that.steamId,_that.personaName,_that.wishlistCount,_that.importedCount,_that.importMinDiscountPct,_that.syncedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String profileInput,  SteamLinkStatus status,  String? steamId,  String? personaName,  int? wishlistCount,  int? importedCount,  int importMinDiscountPct,  DateTime? syncedAt)  $default,) {final _that = this;
switch (_that) {
case _SteamLink():
return $default(_that.profileInput,_that.status,_that.steamId,_that.personaName,_that.wishlistCount,_that.importedCount,_that.importMinDiscountPct,_that.syncedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String profileInput,  SteamLinkStatus status,  String? steamId,  String? personaName,  int? wishlistCount,  int? importedCount,  int importMinDiscountPct,  DateTime? syncedAt)?  $default,) {final _that = this;
switch (_that) {
case _SteamLink() when $default != null:
return $default(_that.profileInput,_that.status,_that.steamId,_that.personaName,_that.wishlistCount,_that.importedCount,_that.importMinDiscountPct,_that.syncedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SteamLink implements SteamLink {
  const _SteamLink({required this.profileInput, required this.status, this.steamId, this.personaName, this.wishlistCount, this.importedCount, required this.importMinDiscountPct, this.syncedAt});
  factory _SteamLink.fromJson(Map<String, dynamic> json) => _$SteamLinkFromJson(json);

/// Что ввёл пользователь (ссылка или ник).
@override final  String profileInput;
@override final  SteamLinkStatus status;
@override final  String? steamId;
@override final  String? personaName;
/// Игр в списке желаемого Steam и сколько из них в отслеживаемых
/// (меньше, если упёрлись в лимит списка).
@override final  int? wishlistCount;
@override final  int? importedCount;
/// Порог скидки для импортированных игр.
@override final  int importMinDiscountPct;
@override final  DateTime? syncedAt;

/// Create a copy of SteamLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SteamLinkCopyWith<_SteamLink> get copyWith => __$SteamLinkCopyWithImpl<_SteamLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SteamLinkToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SteamLink&&(identical(other.profileInput, profileInput) || other.profileInput == profileInput)&&(identical(other.status, status) || other.status == status)&&(identical(other.steamId, steamId) || other.steamId == steamId)&&(identical(other.personaName, personaName) || other.personaName == personaName)&&(identical(other.wishlistCount, wishlistCount) || other.wishlistCount == wishlistCount)&&(identical(other.importedCount, importedCount) || other.importedCount == importedCount)&&(identical(other.importMinDiscountPct, importMinDiscountPct) || other.importMinDiscountPct == importMinDiscountPct)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,profileInput,status,steamId,personaName,wishlistCount,importedCount,importMinDiscountPct,syncedAt);
}

@override
String toString() {
    return 'SteamLink(profileInput: $profileInput, status: $status, steamId: $steamId, personaName: $personaName, wishlistCount: $wishlistCount, importedCount: $importedCount, importMinDiscountPct: $importMinDiscountPct, syncedAt: $syncedAt)';
}


}

/// @nodoc
abstract mixin class _$SteamLinkCopyWith<$Res> implements $SteamLinkCopyWith<$Res> {
  factory _$SteamLinkCopyWith(_SteamLink value, $Res Function(_SteamLink) _then) = __$SteamLinkCopyWithImpl;
@override @useResult
$Res call({
 String profileInput, SteamLinkStatus status, String? steamId, String? personaName, int? wishlistCount, int? importedCount, int importMinDiscountPct, DateTime? syncedAt
});




}
/// @nodoc
class __$SteamLinkCopyWithImpl<$Res>
    implements _$SteamLinkCopyWith<$Res> {
  __$SteamLinkCopyWithImpl(this._self, this._then);

  final _SteamLink _self;
  final $Res Function(_SteamLink) _then;

/// Create a copy of SteamLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileInput = null,Object? status = null,Object? steamId = freezed,Object? personaName = freezed,Object? wishlistCount = freezed,Object? importedCount = freezed,Object? importMinDiscountPct = null,Object? syncedAt = freezed,}) {
  return _then(_SteamLink(
profileInput: null == profileInput ? _self.profileInput : profileInput // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SteamLinkStatus,steamId: freezed == steamId ? _self.steamId : steamId // ignore: cast_nullable_to_non_nullable
as String?,personaName: freezed == personaName ? _self.personaName : personaName // ignore: cast_nullable_to_non_nullable
as String?,wishlistCount: freezed == wishlistCount ? _self.wishlistCount : wishlistCount // ignore: cast_nullable_to_non_nullable
as int?,importedCount: freezed == importedCount ? _self.importedCount : importedCount // ignore: cast_nullable_to_non_nullable
as int?,importMinDiscountPct: null == importMinDiscountPct ? _self.importMinDiscountPct : importMinDiscountPct // ignore: cast_nullable_to_non_nullable
as int,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SteamLinkRequest {

 String get profile; int get importMinDiscountPct;
/// Create a copy of SteamLinkRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SteamLinkRequestCopyWith<SteamLinkRequest> get copyWith => _$SteamLinkRequestCopyWithImpl<SteamLinkRequest>(this as SteamLinkRequest, _$identity);

  /// Serializes this SteamLinkRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SteamLinkRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SteamLinkRequest&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.importMinDiscountPct, _this.importMinDiscountPct) || other.importMinDiscountPct == _this.importMinDiscountPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SteamLinkRequest;
  return Object.hash(runtimeType,_this.profile,_this.importMinDiscountPct);
}

@override
String toString() {
  final _this = this as SteamLinkRequest;
  return 'SteamLinkRequest(profile: ${_this.profile}, importMinDiscountPct: ${_this.importMinDiscountPct})';
}


}

/// @nodoc
abstract mixin class $SteamLinkRequestCopyWith<$Res>  {
  factory $SteamLinkRequestCopyWith(SteamLinkRequest value, $Res Function(SteamLinkRequest) _then) = _$SteamLinkRequestCopyWithImpl;
@useResult
$Res call({
 String profile, int importMinDiscountPct
});




}
/// @nodoc
class _$SteamLinkRequestCopyWithImpl<$Res>
    implements $SteamLinkRequestCopyWith<$Res> {
  _$SteamLinkRequestCopyWithImpl(this._self, this._then);

  final SteamLinkRequest _self;
  final $Res Function(SteamLinkRequest) _then;

/// Create a copy of SteamLinkRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = null,Object? importMinDiscountPct = null,}) {
  return _then(SteamLinkRequest(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String,importMinDiscountPct: null == importMinDiscountPct ? _self.importMinDiscountPct : importMinDiscountPct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SteamLinkRequest].
extension SteamLinkRequestPatterns on SteamLinkRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SteamLinkRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SteamLinkRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SteamLinkRequest value)  $default,){
final _that = this;
switch (_that) {
case _SteamLinkRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SteamLinkRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SteamLinkRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String profile,  int importMinDiscountPct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SteamLinkRequest() when $default != null:
return $default(_that.profile,_that.importMinDiscountPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String profile,  int importMinDiscountPct)  $default,) {final _that = this;
switch (_that) {
case _SteamLinkRequest():
return $default(_that.profile,_that.importMinDiscountPct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String profile,  int importMinDiscountPct)?  $default,) {final _that = this;
switch (_that) {
case _SteamLinkRequest() when $default != null:
return $default(_that.profile,_that.importMinDiscountPct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SteamLinkRequest extends SteamLinkRequest {
  const _SteamLinkRequest({required this.profile, this.importMinDiscountPct = SteamLinkRequest.defaultMinDiscount}): super._();
  factory _SteamLinkRequest.fromJson(Map<String, dynamic> json) => _$SteamLinkRequestFromJson(json);

@override final  String profile;
@override@JsonKey() final  int importMinDiscountPct;

/// Create a copy of SteamLinkRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SteamLinkRequestCopyWith<_SteamLinkRequest> get copyWith => __$SteamLinkRequestCopyWithImpl<_SteamLinkRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SteamLinkRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SteamLinkRequest&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.importMinDiscountPct, importMinDiscountPct) || other.importMinDiscountPct == importMinDiscountPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,profile,importMinDiscountPct);
}

@override
String toString() {
    return 'SteamLinkRequest(profile: $profile, importMinDiscountPct: $importMinDiscountPct)';
}


}

/// @nodoc
abstract mixin class _$SteamLinkRequestCopyWith<$Res> implements $SteamLinkRequestCopyWith<$Res> {
  factory _$SteamLinkRequestCopyWith(_SteamLinkRequest value, $Res Function(_SteamLinkRequest) _then) = __$SteamLinkRequestCopyWithImpl;
@override @useResult
$Res call({
 String profile, int importMinDiscountPct
});




}
/// @nodoc
class __$SteamLinkRequestCopyWithImpl<$Res>
    implements _$SteamLinkRequestCopyWith<$Res> {
  __$SteamLinkRequestCopyWithImpl(this._self, this._then);

  final _SteamLinkRequest _self;
  final $Res Function(_SteamLinkRequest) _then;

/// Create a copy of SteamLinkRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? importMinDiscountPct = null,}) {
  return _then(_SteamLinkRequest(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String,importMinDiscountPct: null == importMinDiscountPct ? _self.importMinDiscountPct : importMinDiscountPct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
