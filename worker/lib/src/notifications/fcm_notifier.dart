import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../db/devices_repository.dart';
import 'notifier.dart';
import 'push_texts.dart';

/// Отправка уведомлений через FCM HTTP v1 (правило 11).
///
/// Авторизация — сервисный аккаунт Firebase (JSON-ключ из секретов worker'а);
/// токен доступа получает и обновляет googleapis_auth. Уведомление уходит на
/// все устройства пользователя; токены, которые FCM считает недействительными,
/// удаляются из БД.
final class FcmNotifier implements Notifier {
  FcmNotifier({
    required this.projectId,
    required http.Client authorizedClient,
    required this._devices,
  }) : _client = authorizedClient;

  /// Создаёт отправитель по файлу ключа сервисного аккаунта.
  static Future<FcmNotifier> fromServiceAccountFile({
    required String projectId,
    required String path,
    required DeviceTokens devices,
  }) async {
    final credentials = ServiceAccountCredentials.fromJson(
      jsonDecode(await File(path).readAsString()),
    );
    final client = await clientViaServiceAccount(credentials, const [
      'https://www.googleapis.com/auth/firebase.messaging',
    ]);
    return FcmNotifier(
      projectId: projectId,
      authorizedClient: client,
      devices: devices,
    );
  }

  static final _log = Logger('FCM');

  /// Канал уведомлений на Android (создаётся приложением).
  static const androidChannelId = 'price_alerts';

  final String projectId;
  final http.Client _client;
  final DeviceTokens _devices;

  Uri get _endpoint =>
      Uri.https('fcm.googleapis.com', '/v1/projects/$projectId/messages:send');

  @override
  Future<bool> sendPriceAlert(PriceAlert alert) async {
    final tokens = await _devices.tokensOf(alert.userId);
    if (tokens.isEmpty) {
      _log.fine('У пользователя ${alert.userId} нет устройств');
      return false;
    }
    final text = priceAlertText(alert);
    var delivered = false;
    for (final token in tokens) {
      final result = await _send(token, message(token, alert, text));
      switch (result) {
        case _SendResult.ok:
          delivered = true;
        case _SendResult.invalidToken:
          await _devices.deleteToken(token);
          _log.info(
            'Удалён недействительный FCM-токен пользователя ${alert.userId}',
          );
        case _SendResult.failed:
          break;
      }
    }
    return delivered;
  }

  /// Сообщение FCM: системное уведомление + данные для перехода к игре.
  /// Повторные уведомления об одной игре заменяют прежнее (tag / thread-id).
  static Map<String, Object?> message(
    String token,
    PriceAlert alert,
    ({String title, String body}) text,
  ) => {
    'message': {
      'token': token,
      'notification': {'title': text.title, 'body': text.body},
      'data': {'type': 'price_alert', 'app_id': '${alert.appId}'},
      'android': {
        'priority': 'high',
        'notification': {
          'channel_id': androidChannelId,
          'tag': 'price-${alert.appId}',
        },
      },
      'apns': {
        'payload': {
          'aps': {'sound': 'default', 'thread-id': 'price-${alert.appId}'},
        },
      },
    },
  };

  Future<_SendResult> _send(String token, Map<String, Object?> body) async {
    final http.Response response;
    try {
      response = await _client.post(
        _endpoint,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(body),
      );
    } on Object catch (e) {
      _log.warning('FCM недоступен: $e');
      return _SendResult.failed;
    }
    if (response.statusCode == 200) return _SendResult.ok;
    if (isInvalidTokenResponse(response.statusCode, response.body)) {
      return _SendResult.invalidToken;
    }
    // 429, 5xx, ошибки авторизации: уведомление не помечается отправленным
    // и уйдёт при следующей проверке цены.
    _log.warning('FCM ответил ${response.statusCode}: ${response.body}');
    return _SendResult.failed;
  }

  /// Токен больше не действует: приложение удалено, токен обновился
  /// или принадлежит другому проекту Firebase.
  static bool isInvalidTokenResponse(int status, String body) {
    if (status != 404 && status != 400 && status != 403) return false;
    try {
      final error =
          (jsonDecode(body) as Map<String, Object?>)['error']
              as Map<String, Object?>?;
      final details = (error?['details'] as List?) ?? const [];
      final codes = {
        for (final d in details.whereType<Map<String, Object?>>())
          d['errorCode'],
      };
      if (codes.contains('UNREGISTERED') ||
          codes.contains('SENDER_ID_MISMATCH')) {
        return true;
      }
      // 400 INVALID_ARGUMENT про сам токен (а не про сообщение).
      return status == 400 &&
          codes.contains('INVALID_ARGUMENT') &&
          '${error?['message']}'.toLowerCase().contains('registration token');
    } on Object {
      return false;
    }
  }
}

enum _SendResult { ok, invalidToken, failed }
