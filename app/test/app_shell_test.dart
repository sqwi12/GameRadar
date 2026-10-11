import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/app.dart';
import 'package:gameradar_app/core/network/app_exception.dart';
import 'package:gameradar_app/core/providers.dart';
import 'package:gameradar_app/core/storage/preferences_store.dart';
import 'package:gameradar_app/features/settings/presentation/settings_providers.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

void main() {
  // Без drift: нативный SQLite внутри виджет-тестов изредка роняет
  // flutter_tester. Кэш и БД проверяются отдельными тестами.
  late MemoryPreferencesStore preferencesStore;

  setUp(() => preferencesStore = MemoryPreferencesStore());

  // Стеклянные виджеты анимируются пружинами и могут не «успокоиться»
  // полностью, поэтому вместо pumpAndSettle — фиксированные кадры
  // (переходы между экранами занимают около 0,5 с).
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

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
    await settle(tester);
  }

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byIcon(CupertinoIcons.gear_alt).first);
    await settle(tester);
  }

  Brightness? appBrightness(WidgetTester tester) =>
      tester.widget<CupertinoApp>(find.byType(CupertinoApp)).theme?.brightness;

  testWidgets('вкладки переключаются, у каждой свой экран', (tester) async {
    await pumpApp(tester);
    expect(find.text('Топ по онлайну'), findsOneWidget);

    await tester.tap(find.text('Скидки').first);
    await settle(tester);
    expect(find.text('Скидки сейчас'), findsOneWidget);

    await tester.tap(find.text('Отслеживаю').first);
    await settle(tester);
    expect(find.text('Отслеживаемые'), findsOneWidget);
  });

  testWidgets('настройки: пометка о Valve и статус аккаунта', (tester) async {
    await pumpApp(tester);
    await openSettings(tester);

    // Сервер недоступен — статус показывает ошибку и действие «Повторить».
    await tester.scrollUntilVisible(find.text('Анонимный аккаунт'), 100);
    expect(
      find.text('Нет связи с сервером. Проверьте интернет.'),
      findsOneWidget,
    );
    expect(find.byIcon(CupertinoIcons.arrow_clockwise), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('Valve Corporation'),
      100,
    );
    expect(
      find.text(
        'Не связано с Valve Corporation. Steam — товарный знак Valve Corporation.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('смена темы применяется и сохраняется', (tester) async {
    await pumpApp(tester);
    expect(
      appBrightness(tester),
      isNull,
      reason: 'по умолчанию — как в системе',
    );
    await openSettings(tester);

    await tester.tap(find.text('Тёмная').first);
    await settle(tester);
    expect(appBrightness(tester), Brightness.dark);
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
    await openSettings(tester);
    expect(find.text('Подключено к серверу'), findsOneWidget);

    await tester.tap(find.text('English').first);
    await settle(tester);
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
    expect(appBrightness(tester), Brightness.dark);
    expect(find.text('Most played'), findsOneWidget);
  });
}
