// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewSummary _$ReviewSummaryFromJson(Map<String, dynamic> json) =>
    _ReviewSummary(
      positive: (json['positive'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ReviewSummaryToJson(_ReviewSummary instance) =>
    <String, dynamic>{'positive': instance.positive, 'total': instance.total};
