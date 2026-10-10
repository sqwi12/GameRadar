// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GamePrice _$GamePriceFromJson(Map<String, dynamic> json) => _GamePrice(
  region: json['region'] as String,
  isAvailable: json['is_available'] as bool,
  currency: json['currency'] as String?,
  initialPrice: (json['initial_price'] as num?)?.toInt(),
  finalPrice: (json['final_price'] as num?)?.toInt(),
  discountPct: (json['discount_pct'] as num?)?.toInt() ?? 0,
  checkedAt: DateTime.parse(json['checked_at'] as String),
  changedAt: DateTime.parse(json['changed_at'] as String),
);

Map<String, dynamic> _$GamePriceToJson(_GamePrice instance) =>
    <String, dynamic>{
      'region': instance.region,
      'is_available': instance.isAvailable,
      'currency': ?instance.currency,
      'initial_price': ?instance.initialPrice,
      'final_price': ?instance.finalPrice,
      'discount_pct': instance.discountPct,
      'checked_at': instance.checkedAt.toIso8601String(),
      'changed_at': instance.changedAt.toIso8601String(),
    };
