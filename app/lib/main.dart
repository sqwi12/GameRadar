import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Локальные настройки читаем до первого кадра, чтобы тема и язык
  // сразу были правильными.
  final db = AppDatabase();
  final preferences = await db.readPreferences();

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

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const GameRadarApp(),
    ),
  );
}
