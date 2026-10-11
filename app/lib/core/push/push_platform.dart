import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Push-уведомление о цене, пришедшее в приложение.
typedef PushMessage = ({String? title, String? body, int? appId});

/// Разрешение на уведомления.
enum PushPermission { granted, denied, notDetermined }

/// Доступ к Firebase Messaging и локальным уведомлениям. Вынесен в интерфейс,
/// чтобы логику PushService можно было проверить тестами без устройства.
abstract interface class PushPlatform {
  /// false — Firebase не настроен в этой сборке (нет google-services.json).
  Future<bool> initialize({required void Function(int appId) onOpen});

  Future<PushPermission> permission();

  Future<PushPermission> requestPermission();

  Future<String?> token();

  Stream<String> get tokenRefresh;

  /// Уведомления, пришедшие, пока приложение открыто: система их не показывает.
  Stream<PushMessage> get foregroundMessages;

  Future<void> showLocal(PushMessage message);

  String get platformName;
}

int? appIdFrom(Map<String, Object?> data) =>
    int.tryParse('${data['app_id'] ?? ''}');

/// Реализация на firebase_messaging и flutter_local_notifications.
final class FirebasePushPlatform implements PushPlatform {
  final _local = FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'price_alerts',
    'Цены и скидки',
    description: 'Уведомления о снижении цен на отслеживаемые игры',
    importance: Importance.high,
  );

  @override
  String get platformName => Platform.isIOS ? 'ios' : 'android';

  @override
  Future<bool> initialize({required void Function(int appId) onOpen}) async {
    try {
      await Firebase.initializeApp();
    } on Object {
      return false;
    }

    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final id = int.tryParse(response.payload ?? '');
        if (id != null) onOpen(id);
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Нажатие на системное уведомление (приложение было в фоне или закрыто).
    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      if (appIdFrom(m.data) case final id?) onOpen(id);
    });
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      if (appIdFrom(initial.data) case final id?) {
        // Даём роутеру построить первый экран.
        Timer.run(() => onOpen(id));
      }
    }
    return true;
  }

  static PushPermission _map(AuthorizationStatus s) => switch (s) {
    AuthorizationStatus.authorized ||
    AuthorizationStatus.provisional => PushPermission.granted,
    AuthorizationStatus.denied ||
    AuthorizationStatus.deniedPermanently => PushPermission.denied,
    AuthorizationStatus.notDetermined => PushPermission.notDetermined,
  };

  @override
  Future<PushPermission> permission() async => _map(
    (await FirebaseMessaging.instance.getNotificationSettings())
        .authorizationStatus,
  );

  @override
  Future<PushPermission> requestPermission() async => _map(
    (await FirebaseMessaging.instance.requestPermission()).authorizationStatus,
  );

  @override
  Future<String?> token() => FirebaseMessaging.instance.getToken();

  @override
  Stream<String> get tokenRefresh => FirebaseMessaging.instance.onTokenRefresh;

  @override
  Stream<PushMessage> get foregroundMessages => FirebaseMessaging.onMessage.map(
    (m) => (
      title: m.notification?.title,
      body: m.notification?.body,
      appId: appIdFrom(m.data),
    ),
  );

  @override
  Future<void> showLocal(PushMessage message) => _local.show(
    id: message.appId ?? 0,
    title: message.title,
    body: message.body,
    payload: message.appId?.toString(),
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_notification',
        tag: 'price-${message.appId}',
      ),
      iOS: const DarwinNotificationDetails(threadIdentifier: 'price'),
    ),
  );
}
