// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerCountPoint _$PlayerCountPointFromJson(Map<String, dynamic> json) =>
    _PlayerCountPoint(
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      players: (json['players'] as num).toInt(),
    );

Map<String, dynamic> _$PlayerCountPointToJson(_PlayerCountPoint instance) =>
    <String, dynamic>{
      'recorded_at': instance.recordedAt.toIso8601String(),
      'players': instance.players,
    };

_PlayerHistory _$PlayerHistoryFromJson(Map<String, dynamic> json) =>
    _PlayerHistory(
      appId: (json['app_id'] as num).toInt(),
      period: $enumDecode(_$HistoryPeriodEnumMap, json['period']),
      points: (json['points'] as List<dynamic>)
          .map((e) => PlayerCountPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlayerHistoryToJson(_PlayerHistory instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'period': _$HistoryPeriodEnumMap[instance.period]!,
      'points': instance.points.map((e) => e.toJson()).toList(),
    };

const _$HistoryPeriodEnumMap = {
  HistoryPeriod.day: '24h',
  HistoryPeriod.week: '7d',
  HistoryPeriod.month: '30d',
};

_PriceHistoryEntry _$PriceHistoryEntryFromJson(Map<String, dynamic> json) =>
    _PriceHistoryEntry(
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      isAvailable: json['is_available'] as bool,
      currency: json['currency'] as String?,
      initialPrice: (json['initial_price'] as num?)?.toInt(),
      finalPrice: (json['final_price'] as num?)?.toInt(),
      discountPct: (json['discount_pct'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PriceHistoryEntryToJson(_PriceHistoryEntry instance) =>
    <String, dynamic>{
      'recorded_at': instance.recordedAt.toIso8601String(),
      'is_available': instance.isAvailable,
      'currency': ?instance.currency,
      'initial_price': ?instance.initialPrice,
      'final_price': ?instance.finalPrice,
      'discount_pct': instance.discountPct,
    };
