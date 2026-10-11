// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) =>
    _UserSettings(
      locale:
          $enumDecodeNullable(_$AppLocaleEnumMap, json['locale']) ??
          AppLocale.ru,
      region: json['region'] as String? ?? Regions.defaultRegion,
      timezone: json['timezone'] as String? ?? UserSettings.defaultTimezone,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      notifyRecordLow: json['notify_record_low'] as bool? ?? true,
      quietHours: json['quiet_hours'] == null
          ? null
          : QuietHours.fromJson(json['quiet_hours'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserSettingsToJson(_UserSettings instance) =>
    <String, dynamic>{
      'locale': _$AppLocaleEnumMap[instance.locale]!,
      'region': instance.region,
      'timezone': instance.timezone,
      'notifications_enabled': instance.notificationsEnabled,
      'notify_record_low': instance.notifyRecordLow,
      'quiet_hours': ?instance.quietHours?.toJson(),
    };

const _$AppLocaleEnumMap = {AppLocale.ru: 'ru', AppLocale.en: 'en'};

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  settings: UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'settings': instance.settings.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
    };
