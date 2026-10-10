// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Paginated<T> _$PaginatedFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _Paginated<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  offset: (json['offset'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginatedToJson<T>(
  _Paginated<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'offset': instance.offset,
  'limit': instance.limit,
  'total': ?instance.total,
};
