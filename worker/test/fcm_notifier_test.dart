import 'dart:convert';

import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

/// Устройства в памяти.
class FakeDevices implements DeviceTokens {
  FakeDevices(this.tokens);

  final List<String> tokens;
  final deleted = <String>[];

  @override
  Future<List<String>> tokensOf(String userId) async => tokens;

  @override
  Future<void> deleteToken(String token) async => deleted.add(token);
}

PriceAlert alert({
  String locale = 'ru',
  int discount = 50,
  int? initial = 1799900,
}) => (
  userId: 'user-1',
  appId: 1091500,
  gameName: 'Cyberpunk 2077',
  locale: locale,
  finalPrice: 899900,
  initialPrice: initial,
  discountPct: discount,
  currency: 'KZT',
  recordLow: null,
  trackedDays: null,
);

String fcmError(
  int code,
  String status,
  String errorCode, [
  String message = '',
]) => jsonEncode({
  'error': {
    'code': code,
    'status': status,
    'message': message,
    'details': [
      {
        '@type': 'type.googleapis.com/google.firebase.fcm.v1.FcmError',
        'errorCode': errorCode,
      },
    ],
  },
});

void main() {
  group('тексты', () {
    test('скидка по-русски', () {
      final t = priceAlertText(alert());
      expect(t.title, 'Cyberpunk 2077 — скидка 50%');
      expect(t.body, '8 999 ₸ вместо 17 999 ₸');
    });

    test('скидка по-английски', () {
      final t = priceAlertText(alert(locale: 'en'));
      expect(t.title, 'Cyberpunk 2077: 50% off');
      expect(t.body, 'Now 8 999 ₸, was 17 999 ₸');
    });

    test('порог цены без скидки', () {
      expect(
        priceAlertText(alert(discount: 0)).title,
        'Cyberpunk 2077 — цена достигла цели',
      );
      expect(priceAlertText(alert(discount: 0)).body, 'Сейчас 8 999 ₸');
    });

    test('formatMoney: тысячи, копейки, неизвестная валюта', () {
      expect(formatMoney(100, 'KZT'), '1 ₸');
      expect(formatMoney(123456789, 'KZT'), '1 234 567,89 ₸');
      expect(formatMoney(1999, 'USD'), '19,99 \$');
      expect(formatMoney(500, 'XYZ'), '5 XYZ');
    });
  });

  test('сообщение FCM: уведомление, данные для перехода, канал и замена', () {
    final m =
        FcmNotifier.message('tok', alert(), priceAlertText(alert()))['message']!
            as Map<String, Object?>;
    expect(m['token'], 'tok');
    expect(m['data'], {'type': 'price_alert', 'app_id': '1091500'});
    final android = (m['android']! as Map)['notification'] as Map;
    expect(android['channel_id'], FcmNotifier.androidChannelId);
    expect(android['tag'], 'price-1091500');
  });

  group('отправка', () {
    late List<http.Request> sent;

    FcmNotifier notifier(
      FakeDevices devices,
      http.Response Function(String token) respond,
    ) {
      sent = [];
      return FcmNotifier(
        projectId: 'gameradar-test',
        devices: devices,
        authorizedClient: MockClient((request) async {
          sent.add(request);
          final token =
              ((jsonDecode(request.body) as Map)['message'] as Map)['token']
                  as String;
          return respond(token);
        }),
      );
    }

    test('на все устройства пользователя; адрес проекта', () async {
      final devices = FakeDevices(['a', 'b']);
      final ok = await notifier(
        devices,
        (_) => http.Response('{}', 200),
      ).sendPriceAlert(alert());
      expect(ok, isTrue);
      expect(sent, hasLength(2));
      expect(
        sent.first.url.toString(),
        'https://fcm.googleapis.com/v1/projects/gameradar-test/messages:send',
      );
    });

    test('недействительный токен удаляется, остальные доставляются', () async {
      final devices = FakeDevices(['dead', 'alive']);
      final ok = await notifier(
        devices,
        (t) => t == 'dead'
            ? http.Response(fcmError(404, 'NOT_FOUND', 'UNREGISTERED'), 404)
            : http.Response('{}', 200),
      ).sendPriceAlert(alert());
      expect(ok, isTrue);
      expect(devices.deleted, ['dead']);
    });

    test(
      'временная ошибка FCM: токен не удаляется, уведомление не помечается',
      () async {
        final devices = FakeDevices(['a']);
        final ok = await notifier(
          devices,
          (_) =>
              http.Response(fcmError(503, 'UNAVAILABLE', 'UNAVAILABLE'), 503),
        ).sendPriceAlert(alert());
        expect(ok, isFalse);
        expect(devices.deleted, isEmpty);
      },
    );

    test('нет устройств — без запросов', () async {
      final ok = await notifier(
        FakeDevices([]),
        (_) => http.Response('{}', 200),
      ).sendPriceAlert(alert());
      expect(ok, isFalse);
      expect(sent, isEmpty);
    });
  });

  test('isInvalidTokenResponse', () {
    expect(
      FcmNotifier.isInvalidTokenResponse(
        404,
        fcmError(404, 'NOT_FOUND', 'UNREGISTERED'),
      ),
      isTrue,
    );
    expect(
      FcmNotifier.isInvalidTokenResponse(
        403,
        fcmError(403, 'PERMISSION_DENIED', 'SENDER_ID_MISMATCH'),
      ),
      isTrue,
    );
    expect(
      FcmNotifier.isInvalidTokenResponse(
        400,
        fcmError(
          400,
          'INVALID_ARGUMENT',
          'INVALID_ARGUMENT',
          'The registration token is not a valid FCM registration token',
        ),
      ),
      isTrue,
    );
    // Ошибка в самом сообщении — токен не виноват.
    expect(
      FcmNotifier.isInvalidTokenResponse(
        400,
        fcmError(
          400,
          'INVALID_ARGUMENT',
          'INVALID_ARGUMENT',
          'Invalid JSON payload',
        ),
      ),
      isFalse,
    );
    expect(FcmNotifier.isInvalidTokenResponse(500, '{}'), isFalse);
    expect(FcmNotifier.isInvalidTokenResponse(404, 'не JSON'), isFalse);
  });

  test('тексты: рекордно низкая цена', () {
    PriceAlert record(String locale, RecordLowKind kind, int? days) => (
      userId: 'user-1',
      appId: 1091500,
      gameName: 'Cyberpunk 2077',
      locale: locale,
      finalPrice: 899900,
      initialPrice: 1799900,
      discountPct: 70,
      currency: 'KZT',
      recordLow: kind,
      trackedDays: days,
    );
    expect(priceAlertText(record('ru', RecordLowKind.allTime, null)), (
      title: 'Cyberpunk 2077 — рекордно низкая цена',
      body: '${formatMoney(899900, 'KZT')} (−70%): дешевле в Steam не было',
    ));
    expect(
      priceAlertText(record('en', RecordLowKind.tracked, 45)).body,
      '${formatMoney(899900, 'KZT')} (70% off): cheapest in 45 days',
    );
  });
}
