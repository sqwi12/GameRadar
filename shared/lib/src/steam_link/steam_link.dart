import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/api_error.dart';
import '../common/validation.dart';

part 'steam_link.freezed.dart';
part 'steam_link.g.dart';

/// Профиль Steam, введённый пользователем: числовой SteamID64 или ник
/// (часть адреса steamcommunity.com/id/<ник>).
sealed class SteamProfileRef {
  const SteamProfileRef();

  static final _id64 = RegExp(r'^7656119\d{10}$');
  static final _vanity = RegExp(r'^[A-Za-z0-9_-]{2,32}$');

  /// Понимает: `76561197960287930`, `gabelogannewell`,
  /// `https://steamcommunity.com/profiles/76561197960287930/`,
  /// `steamcommunity.com/id/gabelogannewell/wishlist`. Иначе — null.
  static SteamProfileRef? tryParse(String input) {
    final text = input.trim();
    if (text.isEmpty || text.length > 200) return null;
    if (_id64.hasMatch(text)) return SteamId64(text);

    final withScheme = text.contains('://') ? text : 'https://$text';
    final uri = Uri.tryParse(withScheme);
    if (uri != null &&
        (uri.host == 'steamcommunity.com' ||
            uri.host == 'www.steamcommunity.com')) {
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.length >= 2) {
        if (segments[0] == 'profiles' && _id64.hasMatch(segments[1])) {
          return SteamId64(segments[1]);
        }
        if (segments[0] == 'id' && _vanity.hasMatch(segments[1])) {
          return SteamVanity(segments[1]);
        }
      }
      return null;
    }
    return !text.contains('/') && _vanity.hasMatch(text)
        ? SteamVanity(text)
        : null;
  }
}

final class SteamId64 extends SteamProfileRef {
  const SteamId64(this.value);

  final String value;

  @override
  bool operator ==(Object other) => other is SteamId64 && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'SteamId64($value)';
}

final class SteamVanity extends SteamProfileRef {
  const SteamVanity(this.name);

  final String name;

  @override
  bool operator ==(Object other) =>
      other is SteamVanity && other.name.toLowerCase() == name.toLowerCase();

  @override
  int get hashCode => name.toLowerCase().hashCode;

  @override
  String toString() => 'SteamVanity($name)';
}

/// Состояние импорта списка желаемого.
@JsonEnum(fieldRename: FieldRename.snake)
enum SteamLinkStatus {
  /// Ждёт первой синхронизации (worker возьмёт в течение минуты).
  pending,

  /// Импорт выполнен.
  ok,

  /// Профиль или список желаемого скрыт настройками приватности Steam.
  privateProfile,

  /// Такого профиля нет.
  notFound,
}

/// Привязанный профиль Steam: GET/PUT /me/steam.
@freezed
abstract class SteamLink with _$SteamLink {
  const factory SteamLink({
    /// Что ввёл пользователь (ссылка или ник).
    required String profileInput,
    required SteamLinkStatus status,
    String? steamId,
    String? personaName,

    /// Игр в списке желаемого Steam и сколько из них в отслеживаемых
    /// (меньше, если упёрлись в лимит списка).
    int? wishlistCount,
    int? importedCount,

    /// Порог скидки для импортированных игр.
    required int importMinDiscountPct,
    DateTime? syncedAt,
  }) = _SteamLink;

  factory SteamLink.fromJson(Map<String, Object?> json) =>
      _$SteamLinkFromJson(json);
}

/// PUT /me/steam — привязать профиль и импортировать список желаемого.
@freezed
abstract class SteamLinkRequest with _$SteamLinkRequest {
  const SteamLinkRequest._();

  const factory SteamLinkRequest({
    required String profile,
    @Default(SteamLinkRequest.defaultMinDiscount) int importMinDiscountPct,
  }) = _SteamLinkRequest;

  static const defaultMinDiscount = 25;

  factory SteamLinkRequest.fromJson(Map<String, Object?> json) =>
      _$SteamLinkRequestFromJson(json);

  List<FieldError> validate() {
    final v = Validator();
    if (SteamProfileRef.tryParse(profile) == null) {
      v.add('profile', FieldErrorCode.invalidFormat);
    }
    v.range('import_min_discount_pct', importMinDiscountPct, min: 1, max: 100);
    return v.errors;
  }
}
