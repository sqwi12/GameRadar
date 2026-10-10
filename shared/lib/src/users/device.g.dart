// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceRegisterRequest _$DeviceRegisterRequestFromJson(
  Map<String, dynamic> json,
) => _DeviceRegisterRequest(
  fcmToken: json['fcm_token'] as String,
  platform: $enumDecode(_$DevicePlatformEnumMap, json['platform']),
);

Map<String, dynamic> _$DeviceRegisterRequestToJson(
  _DeviceRegisterRequest instance,
) => <String, dynamic>{
  'fcm_token': instance.fcmToken,
  'platform': _$DevicePlatformEnumMap[instance.platform]!,
};

const _$DevicePlatformEnumMap = {
  DevicePlatform.android: 'android',
  DevicePlatform.ios: 'ios',
};
