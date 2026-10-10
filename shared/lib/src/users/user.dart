import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/api_error.dart';
import '../common/quiet_hours.dart';
import '../common/region.dart';
import '../common/validation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Язык интерфейса и уведомлений.
@JsonEnum()
enum AppLocale { ru, en }

/// Настройки пользователя. Обновляются целиком (PUT /me/settings),
/// чтобы тихие часы можно было и задать, и снять.
@freezed
abstract class UserSettings with _$UserSettings {
  const UserSettings._();

  const factory UserSettings({
    @Default(AppLocale.ru) AppLocale locale,
    @Default(Regions.defaultRegion) String region,

    /// Часовой пояс IANA, например `Asia/Almaty`.
    @Default(UserSettings.defaultTimezone) String timezone,
    @Default(true) bool notificationsEnabled,

    /// null — тихих часов нет.
    QuietHours? quietHours,
  }) = _UserSettings;

  static const defaultTimezone = 'Asia/Almaty';

  factory UserSettings.fromJson(Map<String, Object?> json) =>
      _$UserSettingsFromJson(json);

  static final _timezonePattern = RegExp(r'^[A-Za-z_]+(/[A-Za-z0-9_+\-]+)*$');

  /// Проверяет формат полей. Существование часового пояса проверяет сервер.
  List<FieldError> validate() {
    final v = Validator();
    if (!Regions.isValid(region)) v.add('region', FieldErrorCode.invalidFormat);
    if (timezone.length > 64 || !_timezonePattern.hasMatch(timezone)) {
      v.add('timezone', FieldErrorCode.invalidFormat);
    }
    return v.errors;
  }
}

/// Анонимный пользователь.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required UserSettings settings,
    required DateTime createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, Object?> json) =>
      _$UserProfileFromJson(json);
}
