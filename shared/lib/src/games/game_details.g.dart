// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameDetails _$GameDetailsFromJson(Map<String, dynamic> json) => _GameDetails(
  appId: (json['app_id'] as num).toInt(),
  name: json['name'] as String,
  type:
      $enumDecodeNullable(
        _$GameTypeEnumMap,
        json['type'],
        unknownValue: GameType.unknown,
      ) ??
      GameType.unknown,
  isFree: json['is_free'] as bool? ?? false,
  headerImageUrl: json['header_image_url'] as String?,
  shortDescription:
      (json['short_description'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  developers:
      (json['developers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  publishers:
      (json['publishers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  releaseDate: _$JsonConverterFromJson<String, DateTime>(
    json['release_date'],
    const DateOnlyConverter().fromJson,
  ),
  reviews: json['reviews'] == null
      ? null
      : ReviewSummary.fromJson(json['reviews'] as Map<String, dynamic>),
  players: json['players'] == null
      ? const PlayerStats()
      : PlayerStats.fromJson(json['players'] as Map<String, dynamic>),
  price: json['price'] == null
      ? null
      : GamePrice.fromJson(json['price'] as Map<String, dynamic>),
  topRank: (json['top_rank'] as num?)?.toInt(),
  detailsCheckedAt: json['details_checked_at'] == null
      ? null
      : DateTime.parse(json['details_checked_at'] as String),
);

Map<String, dynamic> _$GameDetailsToJson(_GameDetails instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'name': instance.name,
      'type': _$GameTypeEnumMap[instance.type]!,
      'is_free': instance.isFree,
      'header_image_url': ?instance.headerImageUrl,
      'short_description': instance.shortDescription,
      'developers': instance.developers,
      'publishers': instance.publishers,
      'genres': instance.genres,
      'release_date': ?_$JsonConverterToJson<String, DateTime>(
        instance.releaseDate,
        const DateOnlyConverter().toJson,
      ),
      'reviews': ?instance.reviews?.toJson(),
      'players': instance.players.toJson(),
      'price': ?instance.price?.toJson(),
      'top_rank': ?instance.topRank,
      'details_checked_at': ?instance.detailsCheckedAt?.toIso8601String(),
    };

const _$GameTypeEnumMap = {
  GameType.game: 'game',
  GameType.dlc: 'dlc',
  GameType.demo: 'demo',
  GameType.music: 'music',
  GameType.video: 'video',
  GameType.mod: 'mod',
  GameType.unknown: 'unknown',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
