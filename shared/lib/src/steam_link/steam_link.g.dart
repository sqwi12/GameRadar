// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steam_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SteamLink _$SteamLinkFromJson(Map<String, dynamic> json) => _SteamLink(
  profileInput: json['profile_input'] as String,
  status: $enumDecode(_$SteamLinkStatusEnumMap, json['status']),
  steamId: json['steam_id'] as String?,
  personaName: json['persona_name'] as String?,
  wishlistCount: (json['wishlist_count'] as num?)?.toInt(),
  importedCount: (json['imported_count'] as num?)?.toInt(),
  importMinDiscountPct: (json['import_min_discount_pct'] as num).toInt(),
  syncedAt: json['synced_at'] == null
      ? null
      : DateTime.parse(json['synced_at'] as String),
);

Map<String, dynamic> _$SteamLinkToJson(_SteamLink instance) =>
    <String, dynamic>{
      'profile_input': instance.profileInput,
      'status': _$SteamLinkStatusEnumMap[instance.status]!,
      'steam_id': ?instance.steamId,
      'persona_name': ?instance.personaName,
      'wishlist_count': ?instance.wishlistCount,
      'imported_count': ?instance.importedCount,
      'import_min_discount_pct': instance.importMinDiscountPct,
      'synced_at': ?instance.syncedAt?.toIso8601String(),
    };

const _$SteamLinkStatusEnumMap = {
  SteamLinkStatus.pending: 'pending',
  SteamLinkStatus.ok: 'ok',
  SteamLinkStatus.privateProfile: 'private_profile',
  SteamLinkStatus.notFound: 'not_found',
};

_SteamLinkRequest _$SteamLinkRequestFromJson(Map<String, dynamic> json) =>
    _SteamLinkRequest(
      profile: json['profile'] as String,
      importMinDiscountPct:
          (json['import_min_discount_pct'] as num?)?.toInt() ??
          SteamLinkRequest.defaultMinDiscount,
    );

Map<String, dynamic> _$SteamLinkRequestToJson(_SteamLinkRequest instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'import_min_discount_pct': instance.importMinDiscountPct,
    };
