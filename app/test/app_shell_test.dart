import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/app.dart';
import 'package:gameradar_app/core/network/app_exception.dart';
import 'package:gameradar_app/core/providers.dart';
import 'package:gameradar_app/core/storage/preferences_store.dart';
import 'package:gameradar_app/features/settings/presentation/settings_providers.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  // Без drift: нативный SQLite внутри виджет-тестов изредка роняет
  // flutter_tester. Кэш и БД проверяются отдельными тестами.
  late MemoryPreferencesStore preferencesStore;

  setUp(() => preferencesStore = MemoryPreferencesStore());

  Future<void> pumpApp(
    WidgetTester tester, {
    Map<String, String> preferences = const {'locale': 'ru'},
    Future<UserProfile> Function()? profile,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(preferencesStore),
          initialPreferencesProvider.overrideWithValue(preferences),
          currentProfileProvider.overrideWith(
            (ref) =>
                (profile ?? () => Future.error(const NetworkException()))(),
          ),
        ],
        child: const GameRadarApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('вкладки переключаются, у каждой свой экран', (tester) async {
    await pumpApp(tester);
    expect(find.text('Топ по онлайну'), findsOneWidget);

    await tester.tap(find.text('Скидки'));
    await tester.pumpAndSettle();
    expect(find.text('Скидки сейчас'), findsOneWidget);

    await tester.tap(find.text('Отслеживаю'));
    await tester.pumpAndSettle();
    expect(find.text('Отслеживаемые'), findsOneWidget);
  });

  testWidgets('настройки: пометка о Valve и статус аккаунта', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Настройки'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.textContaining('Valve Corporation'),
      200,
    );
    expect(
      find.text(
        'Не связано с Valve Corporation. Steam — товарный знак Valve Corporation.',
      ),
      findsOneWidget,
    );
    // Сервер недоступен — статус показывает ошибку и кнопку повтора.
    await tester.scrollUntilVisible(find.text('Анонимный аккаунт'), -200);
    expect(
      find.text('Нет связи с сервером. Проверьте интернет.'),
      findsOneWidget,
    );
    expect(find.byTooltip('Повторить'), findsOneWidget);
  });

  testWidgets('смена темы применяется и сохраняется', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Настройки'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Тёмная'));
    await tester.pumpAndSettle();
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(preferencesStore.values['theme_mode'], 'dark');
  });

  testWidgets('смена языка на английский', (tester) async {
    await pumpApp(
      tester,
      profile: () async => UserProfile(
        id: 'u',
        settings: const UserSettings(),
        createdAt: DateTime.utc(2026),
      ),
    );
    await tester.tap(find.byTooltip('Настройки'));
    await tester.pumpAndSettle();
    expect(find.text('Подключено к серверу'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(preferencesStore.values['locale'], 'en');
  });

  testWidgets('сохранённые тема и язык применяются сразу при запуске', (
    tester,
  ) async {
    await pumpApp(
      tester,
      preferences: const {'theme_mode': 'dark', 'locale': 'en'},
    );
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(find.text('Most played'), findsOneWidget);
  });
}
