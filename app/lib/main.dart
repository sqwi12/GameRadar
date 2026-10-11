import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/providers.dart';
import 'core/push/push_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Шейдеры Liquid Glass загружаются заранее (только чтение с диска, без
  // работы GPU), чтобы стекло не «мигало» на первом кадре.
  final glass = LiquidGlassWidgets.initialize(enablePerformanceMonitor: false);

  // Локальные настройки читаем до первого кадра, чтобы тема и язык
  // сразу были правильными.
  final db = AppDatabase();
  final preferences = await db.readPreferences();
  await glass;

  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      initialPreferencesProvider.overrideWithValue(preferences),
    ],
  );

  // Анонимный вход заранее, в фоне: к открытию первого экрана токен скорее
  // всего уже будет. Ошибка не мешает запуску — запросы повторят вход сами.
  unawaited(
    container
        .read(sessionManagerProvider)
        .validToken()
        .then((_) {}, onError: (_) {}),
  );

  // Push-уведомления: регистрация устройства, если разрешение уже выдано.
  // Без конфигурации Firebase приложение работает, просто без push.
  unawaited(container.read(pushServiceProvider).start());

  runApp(
    LiquidGlassWidgets.wrap(
      // Качество стекла подстраивается под производительность устройства.
      adaptiveQuality: true,
      child: UncontrolledProviderScope(
        container: container,
        child: const GameRadarApp(),
      ),
    ),
  );
}
