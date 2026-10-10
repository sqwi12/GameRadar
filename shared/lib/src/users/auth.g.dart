// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnonymousAuthRequest _$AnonymousAuthRequestFromJson(
  Map<String, dynamic> json,
) => _AnonymousAuthRequest(
  deviceId: json['device_id'] as String,
  initialSettings: json['initial_settings'] == null
      ? null
      : UserSettings.fromJson(json['initial_settings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnonymousAuthRequestToJson(
  _AnonymousAuthRequest instance,
) => <String, dynamic>{
  'device_id': instance.deviceId,
  'initial_settings': ?instance.initialSettings?.toJson(),
};

_AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) =>
    _AuthResponse(
      accessToken: json['access_token'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(_AuthResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_at': instance.expiresAt.toIso8601String(),
      'user': instance.user.toJson(),
    };
