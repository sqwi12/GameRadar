import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/core/push/push_platform.dart';
import 'package:gameradar_app/core/push/push_service.dart';

import 'support/fakes.dart';

class FakePlatform implements PushPlatform {
  FakePlatform({
    this.available = true,
    this.current = PushPermission.notDetermined,
  });

  final bool available;
  PushPermission current;
  PushPermission onRequest = PushPermission.granted;
  String? currentToken = 'token-1';
  final refresh = StreamController<String>.broadcast();
  final messages = StreamController<PushMessage>.broadcast();
  final shown = <PushMessage>[];
  void Function(int appId)? onOpen;
  int requests = 0;

  @override
  Future<bool> initialize({required void Function(int appId) onOpen}) async {
    this.onOpen = onOpen;
    return available;
  }

  @override
  Future<PushPermission> permission() async => current;

  @override
  Future<PushPermission> requestPermission() async {
    requests++;
    return current = onRequest;
  }

  @override
  Future<String?> token() async =>
      current == PushPermission.granted ? currentToken : null;

  @override
  Stream<String> get tokenRefresh => refresh.stream;

  @override
  Stream<PushMessage> get foregroundMessages => messages.stream;

  @override
  Future<void> showLocal(PushMessage message) async => shown.add(message);

  @override
  String get platformName => 'android';
}

void main() {
  late FakeAdapter api;
  late List<int> opened;

  PushService service(FakePlatform platform) {
    opened = [];
    api = FakeAdapter((_) async => jsonBody(null, 204));
    return PushService(
      platform: platform,
      api: Dio(BaseOptions(baseUrl: 'http://api.test'))
        ..httpClientAdapter = api,
      openGame: opened.add,
    );
  }

  List<Object?> registered() => [
    for (final r in api.requests)
      if (r.method == 'PUT' && r.path == '/devices') r.data,
  ];

  test(
    'нет конфигурации Firebase — статус «не настроены», без запросов',
    () async {
      final s = service(FakePlatform(available: false));
      await s.start();
      expect(s.status, PushStatus.unavailable);
      expect(await s.requestPermission(), PushStatus.unavailable);
      expect(api.requests, isEmpty);
    },
  );

  test('разрешение уже есть — токен регистрируется при запуске', () async {
    final s = service(FakePlatform(current: PushPermission.granted));
    await s.start();
    expect(s.status, PushStatus.ready);
    expect(registered(), [
      {'fcm_token': 'token-1', 'platform': 'android'},
    ]);
  });

  test('разрешение не спрашивается при запуске, только по запросу', () async {
    final platform = FakePlatform();
    final s = service(platform);
    await s.start();
    expect(s.status, PushStatus.notAsked);
    expect(platform.requests, 0);
    expect(registered(), isEmpty);

    expect(await s.requestPermission(), PushStatus.ready);
    expect(platform.requests, 1);
    expect(registered(), hasLength(1));

    // Повторный запрос при выданном разрешении ничего не делает.
    await s.requestPermission();
    expect(platform.requests, 1);
  });

  test('отказ — статус «запрещены»', () async {
    final platform = FakePlatform()..onRequest = PushPermission.denied;
    final s = service(platform);
    await s.start();
    expect(await s.requestPermission(), PushStatus.denied);
    expect(registered(), isEmpty);
  });

  test('обновлённый токен отправляется на сервер', () async {
    final platform = FakePlatform(current: PushPermission.granted);
    final s = service(platform);
    await s.start();
    platform.refresh.add('token-2');
    await pumpEventQueue();
    expect(registered().last, {'fcm_token': 'token-2', 'platform': 'android'});
  });

  test('уведомление при открытом приложении показывается локально, нажатие открывает игру', () async {
    final platform = FakePlatform(current: PushPermission.granted);
    final s = service(platform);
    await s.start();
    platform.messages.add((title: 'Скидка', body: '−50%', appId: 730));
    await pumpEventQueue();
    expect(platform.shown.single.appId, 730);

    platform.onOpen!(730);
    expect(opened, [730]);
  });

  test('сервер недоступен — без падения, статус по разрешению', () async {
    final platform = FakePlatform(current: PushPermission.granted);
    opened = [];
    final failing = PushService(
      platform: platform,
      api: Dio(BaseOptions(baseUrl: 'http://api.test'))
        ..httpClientAdapter = FakeAdapter(
          (o) async => throw DioException.connectionError(
            requestOptions: o,
            reason: 'offline',
          ),
        ),
      openGame: opened.add,
    );
    await failing.start();
    expect(failing.status, PushStatus.ready);
  });

  test('appIdFrom: данные FCM — строки', () {
    expect(appIdFrom({'app_id': '730'}), 730);
    expect(appIdFrom({'type': 'x'}), isNull);
    expect(appIdFrom({'app_id': 'abc'}), isNull);
  });
}
