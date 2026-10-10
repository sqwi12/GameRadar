// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameDetails {

 int get appId; String get name;@JsonKey(unknownEnumValue: GameType.unknown) GameType get type; bool get isFree; String? get headerImageUrl;/// Краткое описание по языкам: `{"ru": "...", "en": "..."}`.
 Map<String, String> get shortDescription; List<String> get developers; List<String> get publishers; List<String> get genres;@DateOnlyConverter() DateTime? get releaseDate; ReviewSummary? get reviews; PlayerStats get players;/// Цена в регионе запроса; null — цена ещё не загружалась.
 GamePrice? get price; int? get topRank;/// Когда worker последний раз обновлял описание.
 DateTime? get detailsCheckedAt;
/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameDetailsCopyWith<GameDetails> get copyWith => _$GameDetailsCopyWithImpl<GameDetails>(this as GameDetails, _$identity);

  /// Serializes this GameDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GameDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameDetails&&(identical(other.appId, _this.appId) || other.appId == _this.appId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.isFree, _this.isFree) || other.isFree == _this.isFree)&&(identical(other.headerImageUrl, _this.headerImageUrl) || other.headerImageUrl == _this.headerImageUrl)&&const DeepCollectionEquality().equals(other.shortDescription, _this.shortDescription)&&const DeepCollectionEquality().equals(other.developers, _this.developers)&&const DeepCollectionEquality().equals(other.publishers, _this.publishers)&&const DeepCollectionEquality().equals(other.genres, _this.genres)&&(identical(other.releaseDate, _this.releaseDate) || other.releaseDate == _this.releaseDate)&&(identical(other.reviews, _this.reviews) || other.reviews == _this.reviews)&&(identical(other.players, _this.players) || other.players == _this.players)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.topRank, _this.topRank) || other.topRank == _this.topRank)&&(identical(other.detailsCheckedAt, _this.detailsCheckedAt) || other.detailsCheckedAt == _this.detailsCheckedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GameDetails;
  return Object.hash(runtimeType,_this.appId,_this.name,_this.type,_this.isFree,_this.headerImageUrl,const DeepCollectionEquality().hash(_this.shortDescription),const DeepCollectionEquality().hash(_this.developers),const DeepCollectionEquality().hash(_this.publishers),const DeepCollectionEquality().hash(_this.genres),_this.releaseDate,_this.reviews,_this.players,_this.price,_this.topRank,_this.detailsCheckedAt);
}

@override
String toString() {
  final _this = this as GameDetails;
  return 'GameDetails(appId: ${_this.appId}, name: ${_this.name}, type: ${_this.type}, isFree: ${_this.isFree}, headerImageUrl: ${_this.headerImageUrl}, shortDescription: ${_this.shortDescription}, developers: ${_this.developers}, publishers: ${_this.publishers}, genres: ${_this.genres}, releaseDate: ${_this.releaseDate}, reviews: ${_this.reviews}, players: ${_this.players}, price: ${_this.price}, topRank: ${_this.topRank}, detailsCheckedAt: ${_this.detailsCheckedAt})';
}


}

/// @nodoc
abstract mixin class $GameDetailsCopyWith<$Res>  {
  factory $GameDetailsCopyWith(GameDetails value, $Res Function(GameDetails) _then) = _$GameDetailsCopyWithImpl;
@useResult
$Res call({
 int appId, String name,@JsonKey(unknownEnumValue: GameType.unknown) GameType type, bool isFree, String? headerImageUrl, Map<String, String> shortDescription, List<String> developers, List<String> publishers, List<String> genres,@DateOnlyConverter() DateTime? releaseDate, ReviewSummary? reviews, PlayerStats players, GamePrice? price, int? topRank, DateTime? detailsCheckedAt
});


$ReviewSummaryCopyWith<$Res>? get reviews;$PlayerStatsCopyWith<$Res> get players;$GamePriceCopyWith<$Res>? get price;

}
/// @nodoc
class _$GameDetailsCopyWithImpl<$Res>
    implements $GameDetailsCopyWith<$Res> {
  _$GameDetailsCopyWithImpl(this._self, this._then);

  final GameDetails _self;
  final $Res Function(GameDetails) _then;

/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appId = null,Object? name = null,Object? type = null,Object? isFree = null,Object? headerImageUrl = freezed,Object? shortDescription = null,Object? developers = null,Object? publishers = null,Object? genres = null,Object? releaseDate = freezed,Object? reviews = freezed,Object? players = null,Object? price = freezed,Object? topRank = freezed,Object? detailsCheckedAt = freezed,}) {
  return _then(GameDetails(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GameType,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,headerImageUrl: freezed == headerImageUrl ? _self.headerImageUrl : headerImageUrl // ignore: cast_nullable_to_non_nullable
as String?,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as Map<String, String>,developers: null == developers ? _self.developers : developers // ignore: cast_nullable_to_non_nullable
as List<String>,publishers: null == publishers ? _self.publishers : publishers // ignore: cast_nullable_to_non_nullable
as List<String>,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reviews: freezed == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as ReviewSummary?,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as PlayerStats,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as GamePrice?,topRank: freezed == topRank ? _self.topRank : topRank // ignore: cast_nullable_to_non_nullable
as int?,detailsCheckedAt: freezed == detailsCheckedAt ? _self.detailsCheckedAt : detailsCheckedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewSummaryCopyWith<$Res>? get reviews {
    if (_self.reviews == null) {
    return null;
  }

  return $ReviewSummaryCopyWith<$Res>(_self.reviews!, (value) {
    return _then(_self.copyWith(reviews: value));
  });
}/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerStatsCopyWith<$Res> get players {
  
  return $PlayerStatsCopyWith<$Res>(_self.players, (value) {
    return _then(_self.copyWith(players: value));
  });
}/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamePriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $GamePriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameDetails].
extension GameDetailsPatterns on GameDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameDetails value)  $default,){
final _that = this;
switch (_that) {
case _GameDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameDetails value)?  $default,){
final _that = this;
switch (_that) {
case _GameDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int appId,  String name, @JsonKey(unknownEnumValue: GameType.unknown)  GameType type,  bool isFree,  String? headerImageUrl,  Map<String, String> shortDescription,  List<String> developers,  List<String> publishers,  List<String> genres, @DateOnlyConverter()  DateTime? releaseDate,  ReviewSummary? reviews,  PlayerStats players,  GamePrice? price,  int? topRank,  DateTime? detailsCheckedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameDetails() when $default != null:
return $default(_that.appId,_that.name,_that.type,_that.isFree,_that.headerImageUrl,_that.shortDescription,_that.developers,_that.publishers,_that.genres,_that.releaseDate,_that.reviews,_that.players,_that.price,_that.topRank,_that.detailsCheckedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int appId,  String name, @JsonKey(unknownEnumValue: GameType.unknown)  GameType type,  bool isFree,  String? headerImageUrl,  Map<String, String> shortDescription,  List<String> developers,  List<String> publishers,  List<String> genres, @DateOnlyConverter()  DateTime? releaseDate,  ReviewSummary? reviews,  PlayerStats players,  GamePrice? price,  int? topRank,  DateTime? detailsCheckedAt)  $default,) {final _that = this;
switch (_that) {
case _GameDetails():
return $default(_that.appId,_that.name,_that.type,_that.isFree,_that.headerImageUrl,_that.shortDescription,_that.developers,_that.publishers,_that.genres,_that.releaseDate,_that.reviews,_that.players,_that.price,_that.topRank,_that.detailsCheckedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int appId,  String name, @JsonKey(unknownEnumValue: GameType.unknown)  GameType type,  bool isFree,  String? headerImageUrl,  Map<String, String> shortDescription,  List<String> developers,  List<String> publishers,  List<String> genres, @DateOnlyConverter()  DateTime? releaseDate,  ReviewSummary? reviews,  PlayerStats players,  GamePrice? price,  int? topRank,  DateTime? detailsCheckedAt)?  $default,) {final _that = this;
switch (_that) {
case _GameDetails() when $default != null:
return $default(_that.appId,_that.name,_that.type,_that.isFree,_that.headerImageUrl,_that.shortDescription,_that.developers,_that.publishers,_that.genres,_that.releaseDate,_that.reviews,_that.players,_that.price,_that.topRank,_that.detailsCheckedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameDetails extends GameDetails {
  const _GameDetails({required this.appId, required this.name, @JsonKey(unknownEnumValue: GameType.unknown) this.type = GameType.unknown, this.isFree = false, this.headerImageUrl,  Map<String, String> shortDescription = const <String, String>{},  List<String> developers = const <String>[],  List<String> publishers = const <String>[],  List<String> genres = const <String>[], @DateOnlyConverter() this.releaseDate, this.reviews, this.players = const PlayerStats(), this.price, this.topRank, this.detailsCheckedAt}): _shortDescription = shortDescription,_developers = developers,_publishers = publishers,_genres = genres,super._();
  factory _GameDetails.fromJson(Map<String, dynamic> json) => _$GameDetailsFromJson(json);

@override final  int appId;
@override final  String name;
@override@JsonKey(unknownEnumValue: GameType.unknown) final  GameType type;
@override@JsonKey() final  bool isFree;
@override final  String? headerImageUrl;
/// Краткое описание по языкам: `{"ru": "...", "en": "..."}`.
 final  Map<String, String> _shortDescription;
/// Краткое описание по языкам: `{"ru": "...", "en": "..."}`.
@override@JsonKey() Map<String, String> get shortDescription {
  if (_shortDescription is EqualUnmodifiableMapView) return _shortDescription;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_shortDescription);
}

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

@override@DateOnlyConverter() final  DateTime? releaseDate;
@override final  ReviewSummary? reviews;
@override@JsonKey() final  PlayerStats players;
/// Цена в регионе запроса; null — цена ещё не загружалась.
@override final  GamePrice? price;
@override final  int? topRank;
/// Когда worker последний раз обновлял описание.
@override final  DateTime? detailsCheckedAt;

/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameDetailsCopyWith<_GameDetails> get copyWith => __$GameDetailsCopyWithImpl<_GameDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameDetails&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.headerImageUrl, headerImageUrl) || other.headerImageUrl == headerImageUrl)&&const DeepCollectionEquality().equals(other.shortDescription, _shortDescription)&&const DeepCollectionEquality().equals(other.developers, _developers)&&const DeepCollectionEquality().equals(other.publishers, _publishers)&&const DeepCollectionEquality().equals(other.genres, _genres)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.players, players) || other.players == players)&&(identical(other.price, price) || other.price == price)&&(identical(other.topRank, topRank) || other.topRank == topRank)&&(identical(other.detailsCheckedAt, detailsCheckedAt) || other.detailsCheckedAt == detailsCheckedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,appId,name,type,isFree,headerImageUrl,const DeepCollectionEquality().hash(_shortDescription),const DeepCollectionEquality().hash(_developers),const DeepCollectionEquality().hash(_publishers),const DeepCollectionEquality().hash(_genres),releaseDate,reviews,players,price,topRank,detailsCheckedAt);
}

@override
String toString() {
    return 'GameDetails(appId: $appId, name: $name, type: $type, isFree: $isFree, headerImageUrl: $headerImageUrl, shortDescription: $shortDescription, developers: $developers, publishers: $publishers, genres: $genres, releaseDate: $releaseDate, reviews: $reviews, players: $players, price: $price, topRank: $topRank, detailsCheckedAt: $detailsCheckedAt)';
}


}

/// @nodoc
abstract mixin class _$GameDetailsCopyWith<$Res> implements $GameDetailsCopyWith<$Res> {
  factory _$GameDetailsCopyWith(_GameDetails value, $Res Function(_GameDetails) _then) = __$GameDetailsCopyWithImpl;
@override @useResult
$Res call({
 int appId, String name,@JsonKey(unknownEnumValue: GameType.unknown) GameType type, bool isFree, String? headerImageUrl, Map<String, String> shortDescription, List<String> developers, List<String> publishers, List<String> genres,@DateOnlyConverter() DateTime? releaseDate, ReviewSummary? reviews, PlayerStats players, GamePrice? price, int? topRank, DateTime? detailsCheckedAt
});


@override $ReviewSummaryCopyWith<$Res>? get reviews;@override $PlayerStatsCopyWith<$Res> get players;@override $GamePriceCopyWith<$Res>? get price;

}
/// @nodoc
class __$GameDetailsCopyWithImpl<$Res>
    implements _$GameDetailsCopyWith<$Res> {
  __$GameDetailsCopyWithImpl(this._self, this._then);

  final _GameDetails _self;
  final $Res Function(_GameDetails) _then;

/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appId = null,Object? name = null,Object? type = null,Object? isFree = null,Object? headerImageUrl = freezed,Object? shortDescription = null,Object? developers = null,Object? publishers = null,Object? genres = null,Object? releaseDate = freezed,Object? reviews = freezed,Object? players = null,Object? price = freezed,Object? topRank = freezed,Object? detailsCheckedAt = freezed,}) {
  return _then(_GameDetails(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GameType,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,headerImageUrl: freezed == headerImageUrl ? _self.headerImageUrl : headerImageUrl // ignore: cast_nullable_to_non_nullable
as String?,shortDescription: null == shortDescription ? _self._shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as Map<String, String>,developers: null == developers ? _self._developers : developers // ignore: cast_nullable_to_non_nullable
as List<String>,publishers: null == publishers ? _self._publishers : publishers // ignore: cast_nullable_to_non_nullable
as List<String>,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reviews: freezed == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as ReviewSummary?,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as PlayerStats,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as GamePrice?,topRank: freezed == topRank ? _self.topRank : topRank // ignore: cast_nullable_to_non_nullable
as int?,detailsCheckedAt: freezed == detailsCheckedAt ? _self.detailsCheckedAt : detailsCheckedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewSummaryCopyWith<$Res>? get reviews {
    if (_self.reviews == null) {
    return null;
  }

  return $ReviewSummaryCopyWith<$Res>(_self.reviews!, (value) {
    return _then(_self.copyWith(reviews: value));
  });
}/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerStatsCopyWith<$Res> get players {
  
  return $PlayerStatsCopyWith<$Res>(_self.players, (value) {
    return _then(_self.copyWith(players: value));
  });
}/// Create a copy of GameDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamePriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $GamePriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}

// dart format on
