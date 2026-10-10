import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/api_error.dart';
import '../common/validation.dart';

part 'device.freezed.dart';
part 'device.g.dart';

@JsonEnum()
enum DevicePlatform { android, ios }

/// PUT /devices — регистрация или обновление FCM-токена.
@freezed
abstract class DeviceRegisterRequest with _$DeviceRegisterRequest {
  const DeviceRegisterRequest._();

  const factory DeviceRegisterRequest({
    required String fcmToken,
    required DevicePlatform platform,
  }) = _DeviceRegisterRequest;

  factory DeviceRegisterRequest.fromJson(Map<String, Object?> json) =>
      _$DeviceRegisterRequestFromJson(json);

  static const maxTokenLength = 4096;

  List<FieldError> validate() {
    final v = Validator();
    if (fcmToken.trim().isEmpty) {
      v.add('fcm_token', FieldErrorCode.required);
    } else if (fcmToken.length > maxTokenLength) {
      v.add('fcm_token', FieldErrorCode.tooLong);
    }
    return v.errors;
  }
}
