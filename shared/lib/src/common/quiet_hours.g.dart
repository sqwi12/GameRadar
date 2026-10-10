// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiet_hours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuietHours _$QuietHoursFromJson(Map<String, dynamic> json) => _QuietHours(
  start: const ClockTimeConverter().fromJson(json['start'] as String),
  end: const ClockTimeConverter().fromJson(json['end'] as String),
);

Map<String, dynamic> _$QuietHoursToJson(_QuietHours instance) =>
    <String, dynamic>{
      'start': const ClockTimeConverter().toJson(instance.start),
      'end': const ClockTimeConverter().toJson(instance.end),
    };
