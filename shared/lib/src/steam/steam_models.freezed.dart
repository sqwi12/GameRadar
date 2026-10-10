// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'steam_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SteamPriceOverview {

 int get appId;/// false — Steam не знает игру или она не продаётся в регионе.
 bool get success;/// null — цены нет (бесплатная игра, ещё не вышла и т.п.).
 String? get currency; int? get initialPrice; int? get finalPrice; int get discountPct;
/// Create a copy of SteamPriceOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SteamPriceOverviewCopyWith<SteamPriceOverview> get copyWith => _$SteamPriceOverviewCopyWithImpl<SteamPriceOverview>(this as SteamPriceOverview, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SteamPriceOverview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SteamPriceOverview&&(identical(other.appId, _this.appId) || other.appId == _this.appId)&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.initialPrice, _this.initialPrice) || other.initialPrice == _this.initialPrice)&&(identical(other.finalPrice, _this.finalPrice) || other.finalPrice == _this.finalPrice)&&(identical(other.discountPct, _this.discountPct) || other.discountPct == _this.discountPct));
}


@override
int get hashCode {
  final _this = this as SteamPriceOverview;
  return Object.hash(runtimeType,_this.appId,_this.success,_this.currency,_this.initialPrice,_this.finalPrice,_this.discountPct);
}

@override
String toString() {
  final _this = this as SteamPriceOverview;
  return 'SteamPriceOverview(appId: ${_this.appId}, success: ${_this.success}, currency: ${_this.currency}, initialPrice: ${_this.initialPrice}, finalPrice: ${_this.finalPrice}, discountPct: ${_this.discountPct})';
}


}

/// @nodoc
abstract mixin class $SteamPriceOverviewCopyWith<$Res>  {
  factory $SteamPriceOverviewCopyWith(SteamPriceOverview value, $Res Function(SteamPriceOverview) _then) = _$SteamPriceOverviewCopyWithImpl;
@useResult
$Res call({
 int appId, bool success, String? currency, int? initialPrice, int? finalPrice, int discountPct
});




}
/// @nodoc
class _$SteamPriceOverviewCopyWithImpl<$Res>
    implements $SteamPriceOverviewCopyWith<$Res> {
  _$SteamPriceOverviewCopyWithImpl(this._self, this._then);

  final SteamPriceOverview _self;
  final $Res Function(SteamPriceOverview) _then;

/// Create a copy of SteamPriceOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appId = null,Object? success = null,Object? currency = freezed,Object? initialPrice = freezed,Object? finalPrice = freezed,Object? discountPct = null,}) {
  return _then(SteamPriceOverview(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,initialPrice: freezed == initialPrice ? _self.initialPrice : initialPrice // ignore: cast_nullable_to_non_nullable
as int?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int?,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SteamPriceOverview].
extension SteamPriceOverviewPatterns on SteamPriceOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SteamPriceOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SteamPriceOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SteamPriceOverview value)  $default,){
final _that = this;
switch (_that) {
case _SteamPriceOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SteamPriceOverview value)?  $default,){
final _that = this;
switch (_that) {
case _SteamPriceOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int appId,  bool success,  String? currency,  int? initialPrice,  int? finalPrice,  int discountPct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SteamPriceOverview() when $default != null:
return $default(_that.appId,_that.success,_that.currency,_that.initialPrice,_that.finalPrice,_that.discountPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int appId,  bool success,  String? currency,  int? initialPrice,  int? finalPrice,  int discountPct)  $default,) {final _that = this;
switch (_that) {
case _SteamPriceOverview():
return $default(_that.appId,_that.success,_that.currency,_that.initialPrice,_that.finalPrice,_that.discountPct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int appId,  bool success,  String? currency,  int? initialPrice,  int? finalPrice,  int discountPct)?  $default,) {final _that = this;
switch (_that) {
case _SteamPriceOverview() when $default != null:
return $default(_that.appId,_that.success,_that.currency,_that.initialPrice,_that.finalPrice,_that.discountPct);case _:
  return null;

}
}

}

/// @nodoc


class _SteamPriceOverview extends SteamPriceOverview {
  const _SteamPriceOverview({required this.appId, required this.success, this.currency, this.initialPrice, this.finalPrice, this.discountPct = 0}): super._();
  

@override final  int appId;
/// false — Steam не знает игру или она не продаётся в регионе.
@override final  bool success;
/// null — цены нет (бесплатная игра, ещё не вышла и т.п.).
@override final  String? currency;
@override final  int? initialPrice;
@override final  int? finalPrice;
@override@JsonKey() final  int discountPct;

/// Create a copy of SteamPriceOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SteamPriceOverviewCopyWith<_SteamPriceOverview> get copyWith => __$SteamPriceOverviewCopyWithImpl<_SteamPriceOverview>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SteamPriceOverview&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.success, success) || other.success == success)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.initialPrice, initialPrice) || other.initialPrice == initialPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.discountPct, discountPct) || other.discountPct == discountPct));
}


@override
int get hashCode {
    return Object.hash(runtimeType,appId,success,currency,initialPrice,finalPrice,discountPct);
}

@override
String toString() {
    return 'SteamPriceOverview(appId: $appId, success: $success, currency: $currency, initialPrice: $initialPrice, finalPrice: $finalPrice, discountPct: $discountPct)';
}


}

/// @nodoc
abstract mixin class _$SteamPriceOverviewCopyWith<$Res> implements $SteamPriceOverviewCopyWith<$Res> {
  factory _$SteamPriceOverviewCopyWith(_SteamPriceOverview value, $Res Function(_SteamPriceOverview) _then) = __$SteamPriceOverviewCopyWithImpl;
@override @useResult
$Res call({
 int appId, bool success, String? currency, int? initialPrice, int? finalPrice, int discountPct
});




}
/// @nodoc
class __$SteamPriceOverviewCopyWithImpl<$Res>
    implements _$SteamPriceOverviewCopyWith<$Res> {
  __$SteamPriceOverviewCopyWithImpl(this._self, this._then);

  final _SteamPriceOverview _self;
  final $Res Function(_SteamPriceOverview) _then;

/// Create a copy of SteamPriceOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appId = null,Object? success = null,Object? currency = freezed,Object? initialPrice = freezed,Object? finalPrice = freezed,Object? discountPct = null,}) {
  return _then(_SteamPriceOverview(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,initialPrice: freezed == initialPrice ? _self.initialPrice : initialPrice // ignore: cast_nullable_to_non_nullable
as int?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as int?,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SteamAppDetails {

 int get appId; String get name; String get type; bool get isFree; String? get shortDescription; String? get headerImageUrl; List<String> get developers; List<String> get publishers; List<String> get genres;/// null — дата не указана, не распознана или игра ещё не вышла.
 DateTime? get releaseDate; bool get comingSoon;
/// Create a copy of SteamAppDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SteamAppDetailsCopyWith<SteamAppDetails> get copyWith => _$SteamAppDetailsCopyWithImpl<SteamAppDetails>(this as SteamAppDetails, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SteamAppDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SteamAppDetails&&(identical(other.appId, _this.appId) || other.appId == _this.appId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.isFree, _this.isFree) || other.isFree == _this.isFree)&&(identical(other.shortDescription, _this.shortDescription) || other.shortDescription == _this.shortDescription)&&(identical(other.headerImageUrl, _this.headerImageUrl) || other.headerImageUrl == _this.headerImageUrl)&&const DeepCollectionEquality().equals(other.developers, _this.developers)&&const DeepCollectionEquality().equals(other.publishers, _this.publishers)&&const DeepCollectionEquality().equals(other.genres, _this.genres)&&(identical(other.releaseDate, _this.releaseDate) || other.releaseDate == _this.releaseDate)&&(identical(other.comingSoon, _this.comingSoon) || other.comingSoon == _this.comingSoon));
}


@override
int get hashCode {
  final _this = this as SteamAppDetails;
  return Object.hash(runtimeType,_this.appId,_this.name,_this.type,_this.isFree,_this.shortDescription,_this.headerImageUrl,const DeepCollectionEquality().hash(_this.developers),const DeepCollectionEquality().hash(_this.publishers),const DeepCollectionEquality().hash(_this.genres),_this.releaseDate,_this.comingSoon);
}

@override
String toString() {
  final _this = this as SteamAppDetails;
  return 'SteamAppDetails(appId: ${_this.appId}, name: ${_this.name}, type: ${_this.type}, isFree: ${_this.isFree}, shortDescription: ${_this.shortDescription}, headerImageUrl: ${_this.headerImageUrl}, developers: ${_this.developers}, publishers: ${_this.publishers}, genres: ${_this.genres}, releaseDate: ${_this.releaseDate}, comingSoon: ${_this.comingSoon})';
}


}

/// @nodoc
abstract mixin class $SteamAppDetailsCopyWith<$Res>  {
  factory $SteamAppDetailsCopyWith(SteamAppDetails value, $Res Function(SteamAppDetails) _then) = _$SteamAppDetailsCopyWithImpl;
@useResult
$Res call({
 int appId, String name, String type, bool isFree, String? shortDescription, String? headerImageUrl, List<String> developers, List<String> publishers, List<String> genres, DateTime? releaseDate, bool comingSoon
});




}
/// @nodoc
class _$SteamAppDetailsCopyWithImpl<$Res>
    implements $SteamAppDetailsCopyWith<$Res> {
  _$SteamAppDetailsCopyWithImpl(this._self, this._then);

  final SteamAppDetails _self;
  final $Res Function(SteamAppDetails) _then;

/// Create a copy of SteamAppDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appId = null,Object? name = null,Object? type = null,Object? isFree = null,Object? shortDescription = freezed,Object? headerImageUrl = freezed,Object? developers = null,Object? publishers = null,Object? genres = null,Object? releaseDate = freezed,Object? comingSoon = null,}) {
  return _then(SteamAppDetails(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,headerImageUrl: freezed == headerImageUrl ? _self.headerImageUrl : headerImageUrl // ignore: cast_nullable_to_non_nullable
as String?,developers: null == developers ? _self.developers : developers // ignore: cast_nullable_to_non_nullable
as List<String>,publishers: null == publishers ? _self.publishers : publishers // ignore: cast_nullable_to_non_nullable
as List<String>,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SteamAppDetails].
extension SteamAppDetailsPatterns on SteamAppDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SteamAppDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SteamAppDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SteamAppDetails value)  $default,){
final _that = this;
switch (_that) {
case _SteamAppDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SteamAppDetails value)?  $default,){
final _that = this;
switch (_that) {
case _SteamAppDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int appId,  String name,  String type,  bool isFree,  String? shortDescription,  String? headerImageUrl,  List<String> developers,  List<String> publishers,  List<String> genres,  DateTime? releaseDate,  bool comingSoon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SteamAppDetails() when $default != null:
return $default(_that.appId,_that.name,_that.type,_that.isFree,_that.shortDescription,_that.headerImageUrl,_that.developers,_that.publishers,_that.genres,_that.releaseDate,_that.comingSoon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int appId,  String name,  String type,  bool isFree,  String? shortDescription,  String? headerImageUrl,  List<String> developers,  List<String> publishers,  List<String> genres,  DateTime? releaseDate,  bool comingSoon)  $default,) {final _that = this;
switch (_that) {
case _SteamAppDetails():
return $default(_that.appId,_that.name,_that.type,_that.isFree,_that.shortDescription,_that.headerImageUrl,_that.developers,_that.publishers,_that.genres,_that.releaseDate,_that.comingSoon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int appId,  String name,  String type,  bool isFree,  String? shortDescription,  String? headerImageUrl,  List<String> developers,  List<String> publishers,  List<String> genres,  DateTime? releaseDate,  bool comingSoon)?  $default,) {final _that = this;
switch (_that) {
case _SteamAppDetails() when $default != null:
return $default(_that.appId,_that.name,_that.type,_that.isFree,_that.shortDescription,_that.headerImageUrl,_that.developers,_that.publishers,_that.genres,_that.releaseDate,_that.comingSoon);case _:
  return null;

}
}

}

/// @nodoc


class _SteamAppDetails implements SteamAppDetails {
  const _SteamAppDetails({required this.appId, required this.name, required this.type, this.isFree = false, this.shortDescription, this.headerImageUrl,  List<String> developers = const <String>[],  List<String> publishers = const <String>[],  List<String> genres = const <String>[], this.releaseDate, this.comingSoon = false}): _developers = developers,_publishers = publishers,_genres = genres;
  

@override final  int appId;
@override final  String name;
@override final  String type;
@override@JsonKey() final  bool isFree;
@override final  String? shortDescription;
@override final  String? headerImageUrl;
 final  List<String> _developers;
@override@JsonKey() List<String> get developers {
  if (_developers is EqualUnmodifiableListView) return _developers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_developers);
}

 final  List<String> _publishers;
@override@JsonKey() List<String> get publishers {
  if (_publishers is EqualUnmodifiableListView) return _publishers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_publishers);
}

 final  List<String> _genres;
@override@JsonKey() List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

/// null — дата не указана, не распознана или игра ещё не вышла.
@override final  DateTime? releaseDate;
@override@JsonKey() final  bool comingSoon;

/// Create a copy of SteamAppDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SteamAppDetailsCopyWith<_SteamAppDetails> get copyWith => __$SteamAppDetailsCopyWithImpl<_SteamAppDetails>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SteamAppDetails&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.headerImageUrl, headerImageUrl) || other.headerImageUrl == headerImageUrl)&&const DeepCollectionEquality().equals(other.developers, _developers)&&const DeepCollectionEquality().equals(other.publishers, _publishers)&&const DeepCollectionEquality().equals(other.genres, _genres)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.comingSoon, comingSoon) || other.comingSoon == comingSoon));
}


@override
int get hashCode {
    return Object.hash(runtimeType,appId,name,type,isFree,shortDescription,headerImageUrl,const DeepCollectionEquality().hash(_developers),const DeepCollectionEquality().hash(_publishers),const DeepCollectionEquality().hash(_genres),releaseDate,comingSoon);
}

@override
String toString() {
    return 'SteamAppDetails(appId: $appId, name: $name, type: $type, isFree: $isFree, shortDescription: $shortDescription, headerImageUrl: $headerImageUrl, developers: $developers, publishers: $publishers, genres: $genres, releaseDate: $releaseDate, comingSoon: $comingSoon)';
}


}

/// @nodoc
abstract mixin class _$SteamAppDetailsCopyWith<$Res> implements $SteamAppDetailsCopyWith<$Res> {
  factory _$SteamAppDetailsCopyWith(_SteamAppDetails value, $Res Function(_SteamAppDetails) _then) = __$SteamAppDetailsCopyWithImpl;
@override @useResult
$Res call({
 int appId, String name, String type, bool isFree, String? shortDescription, String? headerImageUrl, List<String> developers, List<String> publishers, List<String> genres, DateTime? releaseDate, bool comingSoon
});




}
/// @nodoc
class __$SteamAppDetailsCopyWithImpl<$Res>
    implements _$SteamAppDetailsCopyWith<$Res> {
  __$SteamAppDetailsCopyWithImpl(this._self, this._then);

  final _SteamAppDetails _self;
  final $Res Function(_SteamAppDetails) _then;

/// Create a copy of SteamAppDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appId = null,Object? name = null,Object? type = null,Object? isFree = null,Object? shortDescription = freezed,Object? headerImageUrl = freezed,Object? developers = null,Object? publishers = null,Object? genres = null,Object? releaseDate = freezed,Object? comingSoon = null,}) {
  return _then(_SteamAppDetails(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,headerImageUrl: freezed == headerImageUrl ? _self.headerImageUrl : headerImageUrl // ignore: cast_nullable_to_non_nullable
as String?,developers: null == developers ? _self._developers : developers // ignore: cast_nullable_to_non_nullable
as List<String>,publishers: null == publishers ? _self._publishers : publishers // ignore: cast_nullable_to_non_nullable
as List<String>,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SteamReviewSummary {

 int get totalPositive; int get totalReviews;
/// Create a copy of SteamReviewSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SteamReviewSummaryCopyWith<SteamReviewSummary> get copyWith => _$SteamReviewSummaryCopyWithImpl<SteamReviewSummary>(this as SteamReviewSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SteamReviewSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SteamReviewSummary&&(identical(other.totalPositive, _this.totalPositive) || other.totalPositive == _this.totalPositive)&&(identical(other.totalReviews, _this.totalReviews) || other.totalReviews == _this.totalReviews));
}


@override
int get hashCode {
  final _this = this as SteamReviewSummary;
  return Object.hash(runtimeType,_this.totalPositive,_this.totalReviews);
}

@override
String toString() {
  final _this = this as SteamReviewSummary;
  return 'SteamReviewSummary(totalPositive: ${_this.totalPositive}, totalReviews: ${_this.totalReviews})';
}


}

/// @nodoc
abstract mixin class $SteamReviewSummaryCopyWith<$Res>  {
  factory $SteamReviewSummaryCopyWith(SteamReviewSummary value, $Res Function(SteamReviewSummary) _then) = _$SteamReviewSummaryCopyWithImpl;
@useResult
$Res call({
 int totalPositive, int totalReviews
});




}
/// @nodoc
class _$SteamReviewSummaryCopyWithImpl<$Res>
    implements $SteamReviewSummaryCopyWith<$Res> {
  _$SteamReviewSummaryCopyWithImpl(this._self, this._then);

  final SteamReviewSummary _self;
  final $Res Function(SteamReviewSummary) _then;

/// Create a copy of SteamReviewSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalPositive = null,Object? totalReviews = null,}) {
  return _then(SteamReviewSummary(
totalPositive: null == totalPositive ? _self.totalPositive : totalPositive // ignore: cast_nullable_to_non_nullable
as int,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SteamReviewSummary].
extension SteamReviewSummaryPatterns on SteamReviewSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SteamReviewSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SteamReviewSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SteamReviewSummary value)  $default,){
final _that = this;
switch (_that) {
case _SteamReviewSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SteamReviewSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SteamReviewSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalPositive,  int totalReviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SteamReviewSummary() when $default != null:
return $default(_that.totalPositive,_that.totalReviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalPositive,  int totalReviews)  $default,) {final _that = this;
switch (_that) {
case _SteamReviewSummary():
return $default(_that.totalPositive,_that.totalReviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalPositive,  int totalReviews)?  $default,) {final _that = this;
switch (_that) {
case _SteamReviewSummary() when $default != null:
return $default(_that.totalPositive,_that.totalReviews);case _:
  return null;

}
}

}

/// @nodoc


class _SteamReviewSummary implements SteamReviewSummary {
  const _SteamReviewSummary({required this.totalPositive, required this.totalReviews});
  

@override final  int totalPositive;
@override final  int totalReviews;

/// Create a copy of SteamReviewSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SteamReviewSummaryCopyWith<_SteamReviewSummary> get copyWith => __$SteamReviewSummaryCopyWithImpl<_SteamReviewSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SteamReviewSummary&&(identical(other.totalPositive, totalPositive) || other.totalPositive == totalPositive)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalPositive,totalReviews);
}

@override
String toString() {
    return 'SteamReviewSummary(totalPositive: $totalPositive, totalReviews: $totalReviews)';
}


}

/// @nodoc
abstract mixin class _$SteamReviewSummaryCopyWith<$Res> implements $SteamReviewSummaryCopyWith<$Res> {
  factory _$SteamReviewSummaryCopyWith(_SteamReviewSummary value, $Res Function(_SteamReviewSummary) _then) = __$SteamReviewSummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalPositive, int totalReviews
});




}
/// @nodoc
class __$SteamReviewSummaryCopyWithImpl<$Res>
    implements _$SteamReviewSummaryCopyWith<$Res> {
  __$SteamReviewSummaryCopyWithImpl(this._self, this._then);

  final _SteamReviewSummary _self;
  final $Res Function(_SteamReviewSummary) _then;

/// Create a copy of SteamReviewSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalPositive = null,Object? totalReviews = null,}) {
  return _then(_SteamReviewSummary(
totalPositive: null == totalPositive ? _self.totalPositive : totalPositive // ignore: cast_nullable_to_non_nullable
as int,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SteamAppListEntry {

 int get appId; String get name;
/// Create a copy of SteamAppListEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SteamAppListEntryCopyWith<SteamAppListEntry> get copyWith => _$SteamAppListEntryCopyWithImpl<SteamAppListEntry>(this as SteamAppListEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SteamAppListEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SteamAppListEntry&&(identical(other.appId, _this.appId) || other.appId == _this.appId)&&(identical(other.name, _this.name) || other.name == _this.name));
}


@override
int get hashCode {
  final _this = this as SteamAppListEntry;
  return Object.hash(runtimeType,_this.appId,_this.name);
}

@override
String toString() {
  final _this = this as SteamAppListEntry;
  return 'SteamAppListEntry(appId: ${_this.appId}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $SteamAppListEntryCopyWith<$Res>  {
  factory $SteamAppListEntryCopyWith(SteamAppListEntry value, $Res Function(SteamAppListEntry) _then) = _$SteamAppListEntryCopyWithImpl;
@useResult
$Res call({
 int appId, String name
});




}
/// @nodoc
class _$SteamAppListEntryCopyWithImpl<$Res>
    implements $SteamAppListEntryCopyWith<$Res> {
  _$SteamAppListEntryCopyWithImpl(this._self, this._then);

  final SteamAppListEntry _self;
  final $Res Function(SteamAppListEntry) _then;

/// Create a copy of SteamAppListEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appId = null,Object? name = null,}) {
  return _then(SteamAppListEntry(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SteamAppListEntry].
extension SteamAppListEntryPatterns on SteamAppListEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SteamAppListEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SteamAppListEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SteamAppListEntry value)  $default,){
final _that = this;
switch (_that) {
case _SteamAppListEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SteamAppListEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SteamAppListEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int appId,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SteamAppListEntry() when $default != null:
return $default(_that.appId,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int appId,  String name)  $default,) {final _that = this;
switch (_that) {
case _SteamAppListEntry():
return $default(_that.appId,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int appId,  String name)?  $default,) {final _that = this;
switch (_that) {
case _SteamAppListEntry() when $default != null:
return $default(_that.appId,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _SteamAppListEntry implements SteamAppListEntry {
  const _SteamAppListEntry({required this.appId, required this.name});
  

@override final  int appId;
@override final  String name;

/// Create a copy of SteamAppListEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SteamAppListEntryCopyWith<_SteamAppListEntry> get copyWith => __$SteamAppListEntryCopyWithImpl<_SteamAppListEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SteamAppListEntry&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,appId,name);
}

@override
String toString() {
    return 'SteamAppListEntry(appId: $appId, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SteamAppListEntryCopyWith<$Res> implements $SteamAppListEntryCopyWith<$Res> {
  factory _$SteamAppListEntryCopyWith(_SteamAppListEntry value, $Res Function(_SteamAppListEntry) _then) = __$SteamAppListEntryCopyWithImpl;
@override @useResult
$Res call({
 int appId, String name
});




}
/// @nodoc
class __$SteamAppListEntryCopyWithImpl<$Res>
    implements _$SteamAppListEntryCopyWith<$Res> {
  __$SteamAppListEntryCopyWithImpl(this._self, this._then);

  final _SteamAppListEntry _self;
  final $Res Function(_SteamAppListEntry) _then;

/// Create a copy of SteamAppListEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appId = null,Object? name = null,}) {
  return _then(_SteamAppListEntry(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SteamAppListPage {

 List<SteamAppListEntry> get apps; bool get haveMoreResults;/// Передаётся в следующий запрос как `last_appid`.
 int? get lastAppId;
/// Create a copy of SteamAppListPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SteamAppListPageCopyWith<SteamAppListPage> get copyWith => _$SteamAppListPageCopyWithImpl<SteamAppListPage>(this as SteamAppListPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SteamAppListPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SteamAppListPage&&const DeepCollectionEquality().equals(other.apps, _this.apps)&&(identical(other.haveMoreResults, _this.haveMoreResults) || other.haveMoreResults == _this.haveMoreResults)&&(identical(other.lastAppId, _this.lastAppId) || other.lastAppId == _this.lastAppId));
}


@override
int get hashCode {
  final _this = this as SteamAppListPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.apps),_this.haveMoreResults,_this.lastAppId);
}

@override
String toString() {
  final _this = this as SteamAppListPage;
  return 'SteamAppListPage(apps: ${_this.apps}, haveMoreResults: ${_this.haveMoreResults}, lastAppId: ${_this.lastAppId})';
}


}

/// @nodoc
abstract mixin class $SteamAppListPageCopyWith<$Res>  {
  factory $SteamAppListPageCopyWith(SteamAppListPage value, $Res Function(SteamAppListPage) _then) = _$SteamAppListPageCopyWithImpl;
@useResult
$Res call({
 List<SteamAppListEntry> apps, bool haveMoreResults, int? lastAppId
});




}
/// @nodoc
class _$SteamAppListPageCopyWithImpl<$Res>
    implements $SteamAppListPageCopyWith<$Res> {
  _$SteamAppListPageCopyWithImpl(this._self, this._then);

  final SteamAppListPage _self;
  final $Res Function(SteamAppListPage) _then;

/// Create a copy of SteamAppListPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apps = null,Object? haveMoreResults = null,Object? lastAppId = freezed,}) {
  return _then(SteamAppListPage(
apps: null == apps ? _self.apps : apps // ignore: cast_nullable_to_non_nullable
as List<SteamAppListEntry>,haveMoreResults: null == haveMoreResults ? _self.haveMoreResults : haveMoreResults // ignore: cast_nullable_to_non_nullable
as bool,lastAppId: freezed == lastAppId ? _self.lastAppId : lastAppId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SteamAppListPage].
extension SteamAppListPagePatterns on SteamAppListPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SteamAppListPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SteamAppListPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SteamAppListPage value)  $default,){
final _that = this;
switch (_that) {
case _SteamAppListPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SteamAppListPage value)?  $default,){
final _that = this;
switch (_that) {
case _SteamAppListPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SteamAppListEntry> apps,  bool haveMoreResults,  int? lastAppId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SteamAppListPage() when $default != null:
return $default(_that.apps,_that.haveMoreResults,_that.lastAppId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SteamAppListEntry> apps,  bool haveMoreResults,  int? lastAppId)  $default,) {final _that = this;
switch (_that) {
case _SteamAppListPage():
return $default(_that.apps,_that.haveMoreResults,_that.lastAppId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SteamAppListEntry> apps,  bool haveMoreResults,  int? lastAppId)?  $default,) {final _that = this;
switch (_that) {
case _SteamAppListPage() when $default != null:
return $default(_that.apps,_that.haveMoreResults,_that.lastAppId);case _:
  return null;

}
}

}

/// @nodoc


class _SteamAppListPage implements SteamAppListPage {
  const _SteamAppListPage({required  List<SteamAppListEntry> apps, required this.haveMoreResults, this.lastAppId}): _apps = apps;
  

 final  List<SteamAppListEntry> _apps;
@override List<SteamAppListEntry> get apps {
  if (_apps is EqualUnmodifiableListView) return _apps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_apps);
}

@override final  bool haveMoreResults;
/// Передаётся в следующий запрос как `last_appid`.
@override final  int? lastAppId;

/// Create a copy of SteamAppListPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SteamAppListPageCopyWith<_SteamAppListPage> get copyWith => __$SteamAppListPageCopyWithImpl<_SteamAppListPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SteamAppListPage&&const DeepCollectionEquality().equals(other.apps, _apps)&&(identical(other.haveMoreResults, haveMoreResults) || other.haveMoreResults == haveMoreResults)&&(identical(other.lastAppId, lastAppId) || other.lastAppId == lastAppId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_apps),haveMoreResults,lastAppId);
}

@override
String toString() {
    return 'SteamAppListPage(apps: $apps, haveMoreResults: $haveMoreResults, lastAppId: $lastAppId)';
}


}

/// @nodoc
abstract mixin class _$SteamAppListPageCopyWith<$Res> implements $SteamAppListPageCopyWith<$Res> {
  factory _$SteamAppListPageCopyWith(_SteamAppListPage value, $Res Function(_SteamAppListPage) _then) = __$SteamAppListPageCopyWithImpl;
@override @useResult
$Res call({
 List<SteamAppListEntry> apps, bool haveMoreResults, int? lastAppId
});




}
/// @nodoc
class __$SteamAppListPageCopyWithImpl<$Res>
    implements _$SteamAppListPageCopyWith<$Res> {
  __$SteamAppListPageCopyWithImpl(this._self, this._then);

  final _SteamAppListPage _self;
  final $Res Function(_SteamAppListPage) _then;

/// Create a copy of SteamAppListPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apps = null,Object? haveMoreResults = null,Object? lastAppId = freezed,}) {
  return _then(_SteamAppListPage(
apps: null == apps ? _self._apps : apps // ignore: cast_nullable_to_non_nullable
as List<SteamAppListEntry>,haveMoreResults: null == haveMoreResults ? _self.haveMoreResults : haveMoreResults // ignore: cast_nullable_to_non_nullable
as bool,lastAppId: freezed == lastAppId ? _self.lastAppId : lastAppId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$SteamChartEntry {

 int get rank; int get appId; int get concurrentInGame; int? get peakInGame;
/// Create a copy of SteamChartEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SteamChartEntryCopyWith<SteamChartEntry> get copyWith => _$SteamChartEntryCopyWithImpl<SteamChartEntry>(this as SteamChartEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SteamChartEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SteamChartEntry&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.appId, _this.appId) || other.appId == _this.appId)&&(identical(other.concurrentInGame, _this.concurrentInGame) || other.concurrentInGame == _this.concurrentInGame)&&(identical(other.peakInGame, _this.peakInGame) || other.peakInGame == _this.peakInGame));
}


@override
int get hashCode {
  final _this = this as SteamChartEntry;
  return Object.hash(runtimeType,_this.rank,_this.appId,_this.concurrentInGame,_this.peakInGame);
}

@override
String toString() {
  final _this = this as SteamChartEntry;
  return 'SteamChartEntry(rank: ${_this.rank}, appId: ${_this.appId}, concurrentInGame: ${_this.concurrentInGame}, peakInGame: ${_this.peakInGame})';
}


}

/// @nodoc
abstract mixin class $SteamChartEntryCopyWith<$Res>  {
  factory $SteamChartEntryCopyWith(SteamChartEntry value, $Res Function(SteamChartEntry) _then) = _$SteamChartEntryCopyWithImpl;
@useResult
$Res call({
 int rank, int appId, int concurrentInGame, int? peakInGame
});




}
/// @nodoc
class _$SteamChartEntryCopyWithImpl<$Res>
    implements $SteamChartEntryCopyWith<$Res> {
  _$SteamChartEntryCopyWithImpl(this._self, this._then);

  final SteamChartEntry _self;
  final $Res Function(SteamChartEntry) _then;

/// Create a copy of SteamChartEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? appId = null,Object? concurrentInGame = null,Object? peakInGame = freezed,}) {
  return _then(SteamChartEntry(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,concurrentInGame: null == concurrentInGame ? _self.concurrentInGame : concurrentInGame // ignore: cast_nullable_to_non_nullable
as int,peakInGame: freezed == peakInGame ? _self.peakInGame : peakInGame // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SteamChartEntry].
extension SteamChartEntryPatterns on SteamChartEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SteamChartEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SteamChartEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SteamChartEntry value)  $default,){
final _that = this;
switch (_that) {
case _SteamChartEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SteamChartEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SteamChartEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  int appId,  int concurrentInGame,  int? peakInGame)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SteamChartEntry() when $default != null:
return $default(_that.rank,_that.appId,_that.concurrentInGame,_that.peakInGame);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  int appId,  int concurrentInGame,  int? peakInGame)  $default,) {final _that = this;
switch (_that) {
case _SteamChartEntry():
return $default(_that.rank,_that.appId,_that.concurrentInGame,_that.peakInGame);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  int appId,  int concurrentInGame,  int? peakInGame)?  $default,) {final _that = this;
switch (_that) {
case _SteamChartEntry() when $default != null:
return $default(_that.rank,_that.appId,_that.concurrentInGame,_that.peakInGame);case _:
  return null;

}
}

}

/// @nodoc


class _SteamChartEntry implements SteamChartEntry {
  const _SteamChartEntry({required this.rank, required this.appId, required this.concurrentInGame, this.peakInGame});
  

@override final  int rank;
@override final  int appId;
@override final  int concurrentInGame;
@override final  int? peakInGame;

/// Create a copy of SteamChartEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SteamChartEntryCopyWith<_SteamChartEntry> get copyWith => __$SteamChartEntryCopyWithImpl<_SteamChartEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SteamChartEntry&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.concurrentInGame, concurrentInGame) || other.concurrentInGame == concurrentInGame)&&(identical(other.peakInGame, peakInGame) || other.peakInGame == peakInGame));
}


@override
int get hashCode {
    return Object.hash(runtimeType,rank,appId,concurrentInGame,peakInGame);
}

@override
String toString() {
    return 'SteamChartEntry(rank: $rank, appId: $appId, concurrentInGame: $concurrentInGame, peakInGame: $peakInGame)';
}


}

/// @nodoc
abstract mixin class _$SteamChartEntryCopyWith<$Res> implements $SteamChartEntryCopyWith<$Res> {
  factory _$SteamChartEntryCopyWith(_SteamChartEntry value, $Res Function(_SteamChartEntry) _then) = __$SteamChartEntryCopyWithImpl;
@override @useResult
$Res call({
 int rank, int appId, int concurrentInGame, int? peakInGame
});




}
/// @nodoc
class __$SteamChartEntryCopyWithImpl<$Res>
    implements _$SteamChartEntryCopyWith<$Res> {
  __$SteamChartEntryCopyWithImpl(this._self, this._then);

  final _SteamChartEntry _self;
  final $Res Function(_SteamChartEntry) _then;

/// Create a copy of SteamChartEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? appId = null,Object? concurrentInGame = null,Object? peakInGame = freezed,}) {
  return _then(_SteamChartEntry(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,concurrentInGame: null == concurrentInGame ? _self.concurrentInGame : concurrentInGame // ignore: cast_nullable_to_non_nullable
as int,peakInGame: freezed == peakInGame ? _self.peakInGame : peakInGame // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
