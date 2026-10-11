// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameSummary _$GameSummaryFromJson(Map<String, dynamic> json) => _GameSummary(
  appId: (json['app_id'] as num).toInt(),
  name: json['name'] as String,
  headerImageUrl: json['header_image_url'] as String?,
  isFree: json['is_free'] as bool? ?? false,
  price: json['price'] == null
      ? null
      : GamePrice.fromJson(json['price'] as Map<String, dynamic>),
  currentPlayers: (json['current_players'] as num?)?.toInt(),
  peak24h: (json['peak_24h'] as num?)?.toInt(),
  topRank: (json['top_rank'] as num?)?.toInt(),
);

Map<String, dynamic> _$GameSummaryToJson(_GameSummary instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'name': instance.name,
      'header_image_url': ?instance.headerImageUrl,
      'is_free': instance.isFree,
      'price': ?instance.price?.toJson(),
      'current_players': ?instance.currentPlayers,
      'peak_24h': ?instance.peak24h,
      'top_rank': ?instance.topRank,
    };
