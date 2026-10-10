import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/api_error.dart';
import '../common/validation.dart';
import 'user.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

/// POST /auth/anonymous
///
/// [deviceId] — случайный UUID, который приложение генерирует при первом
/// запуске и хранит в защищённом хранилище. Сервер хранит только его SHA-256.
@freezed
abstract class AnonymousAuthRequest with _$AnonymousAuthRequest {
  const AnonymousAuthRequest._();

  const factory AnonymousAuthRequest({
    required String deviceId,

    /// Начальные настройки при первом входе (язык и часовой пояс устройства).
    /// Для уже существующего пользователя игнорируются.
    UserSettings? initialSettings,
  }) = _AnonymousAuthRequest;

  factory AnonymousAuthRequest.fromJson(Map<String, Object?> json) =>
      _$AnonymousAuthRequestFromJson(json);

  static final _deviceIdPattern = RegExp(r'^[A-Za-z0-9_-]{16,128}$');

  List<FieldError> validate() {
    final v = Validator();
    if (!_deviceIdPattern.hasMatch(deviceId)) {
      v.add('device_id', FieldErrorCode.invalidFormat);
    }
    final settingsErrors = initialSettings?.validate() ?? const [];
    for (final e in settingsErrors) {
      v.add('initial_settings.${e.field}', e.code);
    }
    return v.errors;
  }
}

/// Ответ на вход: токен для заголовка `Authorization: Bearer ...`.
@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    required DateTime expiresAt,
    required UserProfile user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, Object?> json) =>
      _$AuthResponseFromJson(json);
}
