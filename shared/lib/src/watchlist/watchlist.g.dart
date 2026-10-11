// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchlistUpsertRequest _$WatchlistUpsertRequestFromJson(
  Map<String, dynamic> json,
) => _WatchlistUpsertRequest(
  targetPrice: (json['target_price'] as num?)?.toInt(),
  minDiscountPct: (json['min_discount_pct'] as num?)?.toInt(),
);

Map<String, dynamic> _$WatchlistUpsertRequestToJson(
  _WatchlistUpsertRequest instance,
) => <String, dynamic>{
  'target_price': ?instance.targetPrice,
  'min_discount_pct': ?instance.minDiscountPct,
};

_WatchlistItem _$WatchlistItemFromJson(Map<String, dynamic> json) =>
    _WatchlistItem(
      game: GameSummary.fromJson(json['game'] as Map<String, dynamic>),
      region: json['region'] as String,
      targetPrice: (json['target_price'] as num?)?.toInt(),
      minDiscountPct: (json['min_discount_pct'] as num?)?.toInt(),
      lastNotifiedPrice: (json['last_notified_price'] as num?)?.toInt(),
      lastNotifiedAt: json['last_notified_at'] == null
          ? null
          : DateTime.parse(json['last_notified_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      source:
          $enumDecodeNullable(_$WatchSourceEnumMap, json['source']) ??
          WatchSource.manual,
    );

Map<String, dynamic> _$WatchlistItemToJson(_WatchlistItem instance) =>
    <String, dynamic>{
      'game': instance.game.toJson(),
      'region': instance.region,
      'target_price': ?instance.targetPrice,
      'min_discount_pct': ?instance.minDiscountPct,
      'last_notified_price': ?instance.lastNotifiedPrice,
      'last_notified_at': ?instance.lastNotifiedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'source': _$WatchSourceEnumMap[instance.source]!,
    };

const _$WatchSourceEnumMap = {
  WatchSource.manual: 'manual',
  WatchSource.wishlist: 'wishlist',
};
