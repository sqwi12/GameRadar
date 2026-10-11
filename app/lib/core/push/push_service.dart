import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../network/api_call.dart';
import 'push_platform.dart';

/// Состояние push-уведомлений для экрана настроек.
enum PushStatus {
  /// Ещё не запускались.
  starting,

  /// В этой сборке нет конфигурации Firebase.
  unavailable,

  /// Пользователь ещё не отвечал на запрос разрешения.
  notAsked,

  /// Разрешение отклонено — включить можно только в настройках системы.
  denied,

  /// Устройство зарегистрировано на сервере, уведомления придут.
  ready,
}

/// Push-уведомления (правило 11): разрешение, FCM-токен на нашем сервере
/// (PUT /devices), показ уведомлений при открытом приложении и переход
/// к игре по нажатию.
class PushService extends ChangeNotifier {
  PushService({
    required this._platform,
    required this._api,
    required this._openGame,
  });

  final PushPlatform _platform;
  final Dio _api;
  final void Function(int appId) _openGame;
  final _subs = <StreamSubscription<Object?>>[];

  PushStatus _status = PushStatus.starting;
  PushStatus get status => _status;

  void _set(PushStatus s) {
    _status = s;
    notifyListeners();
  }

  /// Запуск при старте приложения. Разрешение здесь не спрашивается:
  /// только регистрирует устройство, если оно уже выдано.
  Future<void> start() async {
    if (!await _platform.initialize(onOpen: _openGame)) {
      _set(PushStatus.unavailable);
      return;
    }
    _subs
      ..add(_platform.tokenRefresh.listen((t) => unawaited(_register(t))))
      ..add(
        _platform.foregroundMessages.listen(
          (m) => unawaited(_platform.showLocal(m)),
        ),
      );
    await _syncWithPermission(await _platform.permission());
  }

  /// Запрос разрешения — в момент, когда оно нужно пользователю
  /// (добавил игру с порогом или включил уведомления в настройках).
  Future<PushStatus> requestPermission() async {
    if (_status == PushStatus.unavailable || _status == PushStatus.starting) {
      return _status;
    }
    if (_status == PushStatus.ready) return _status;
    await _syncWithPermission(await _platform.requestPermission());
    return _status;
  }

  Future<void> _syncWithPermission(PushPermission permission) async {
    switch (permission) {
      case PushPermission.granted:
        final token = await _platform.token();
        if (token != null) await _register(token);
        _set(token == null ? PushStatus.notAsked : PushStatus.ready);
      case PushPermission.denied:
        _set(PushStatus.denied);
      case PushPermission.notDetermined:
        _set(PushStatus.notAsked);
    }
  }

  /// Регистрация токена на сервере. Без сети не страшно: при следующем
  /// запуске токен будет отправлен снова (PUT идемпотентен).
  Future<void> _register(String token) async {
    try {
      await apiCall(
        () => _api.put<Object?>(
          '/devices',
          data: DeviceRegisterRequest(
            fcmToken: token,
            platform: DevicePlatform.values.byName(_platform.platformName),
          ).toJson(),
        ),
      );
    } on Object catch (e) {
      debugPrint('Не удалось зарегистрировать устройство: $e');
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    super.dispose();
  }
}
