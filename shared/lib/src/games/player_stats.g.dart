// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) => _PlayerStats(
  current: (json['current'] as num?)?.toInt(),
  peak24h: (json['peak_24h'] as num?)?.toInt(),
  peak7d: (json['peak_7d'] as num?)?.toInt(),
  peak30d: (json['peak_30d'] as num?)?.toInt(),
  checkedAt: json['checked_at'] == null
      ? null
      : DateTime.parse(json['checked_at'] as String),
);

Map<String, dynamic> _$PlayerStatsToJson(_PlayerStats instance) =>
    <String, dynamic>{
      'current': ?instance.current,
      'peak_24h': ?instance.peak24h,
      'peak_7d': ?instance.peak7d,
      'peak_30d': ?instance.peak30d,
      'checked_at': ?instance.checkedAt?.toIso8601String(),
    };
