// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldError _$FieldErrorFromJson(Map<String, dynamic> json) =>
    _FieldError(field: json['field'] as String, code: json['code'] as String);

Map<String, dynamic> _$FieldErrorToJson(_FieldError instance) =>
    <String, dynamic>{'field': instance.field, 'code': instance.code};

_ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => _ApiError(
  code: json['code'] as String,
  message: json['message'] as String?,
  fields:
      (json['fields'] as List<dynamic>?)
          ?.map((e) => FieldError.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FieldError>[],
);

Map<String, dynamic> _$ApiErrorToJson(_ApiError instance) => <String, dynamic>{
  'code': instance.code,
  'message': ?instance.message,
  'fields': instance.fields.map((e) => e.toJson()).toList(),
};
