// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'GameRadar';

  @override
  String get tabTop => 'Топ';

  @override
  String get tabDiscounts => 'Скидки';

  @override
  String get tabSearch => 'Поиск';

  @override
  String get tabWatchlist => 'Отслеживаю';

  @override
  String get topTitle => 'Топ по онлайну';

  @override
  String get discountsTitle => 'Скидки сейчас';

  @override
  String get searchTitle => 'Поиск игр';

  @override
  String get watchlistTitle => 'Отслеживаемые';

  @override
  String get gameTitle => 'Игра';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get comingSoon => 'Этот экран появится на следующем этапе';

  @override
  String get settingsAppearance => 'Оформление';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get languageSystem => 'Системный';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsRegion => 'Регион цен';

  @override
  String get regionKazakhstan => 'Казахстан, ₸';

  @override
  String get settingsAccount => 'Аккаунт';

  @override
  String get accountAnonymous => 'Анонимный аккаунт';

  @override
  String get accountConnected => 'Подключено к серверу';

  @override
  String get accountConnecting => 'Подключение…';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String aboutVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get aboutDataSource =>
      'Цены и онлайн собирает наш сервер из публичных данных Steam';

  @override
  String get aboutDisclaimer =>
      'Не связано с Valve Corporation. Steam — товарный знак Valve Corporation.';

  @override
  String get retry => 'Повторить';

  @override
  String get errorNetwork => 'Нет связи с сервером. Проверьте интернет.';

  @override
  String get errorServer => 'Сервер временно недоступен. Попробуйте позже.';

  @override
  String get errorNotFound => 'Ничего не найдено';

  @override
  String get errorUnauthorized => 'Не удалось войти. Попробуйте ещё раз.';

  @override
  String get errorValidation => 'Неверные данные запроса';

  @override
  String get errorUnknown => 'Что-то пошло не так';

  @override
  String get updatedJustNow => 'Обновлено только что';

  @override
  String updatedMinutesAgo(int minutes) {
    return 'Обновлено $minutes мин назад';
  }

  @override
  String updatedAt(String time) {
    return 'Обновлено $time';
  }

  @override
  String get refreshTooOften => 'Обновлять можно не чаще раза в минуту';

  @override
  String get showingCachedData => 'Показаны сохранённые данные';
}
