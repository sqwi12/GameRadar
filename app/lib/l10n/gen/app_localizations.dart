import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// Название приложения
  ///
  /// In ru, this message translates to:
  /// **'GameRadar'**
  String get appTitle;

  /// Вкладка «Топ по онлайну»
  ///
  /// In ru, this message translates to:
  /// **'Топ'**
  String get tabTop;

  /// No description provided for @tabDiscounts.
  ///
  /// In ru, this message translates to:
  /// **'Скидки'**
  String get tabDiscounts;

  /// No description provided for @tabSearch.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get tabSearch;

  /// No description provided for @tabWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'Отслеживаю'**
  String get tabWatchlist;

  /// No description provided for @topTitle.
  ///
  /// In ru, this message translates to:
  /// **'Топ по онлайну'**
  String get topTitle;

  /// No description provided for @discountsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Скидки сейчас'**
  String get discountsTitle;

  /// No description provided for @searchTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поиск игр'**
  String get searchTitle;

  /// No description provided for @watchlistTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отслеживаемые'**
  String get watchlistTitle;

  /// No description provided for @gameTitle.
  ///
  /// In ru, this message translates to:
  /// **'Игра'**
  String get gameTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @comingSoon.
  ///
  /// In ru, this message translates to:
  /// **'Этот экран появится на следующем этапе'**
  String get comingSoon;

  /// No description provided for @settingsAppearance.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системный'**
  String get languageSystem;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsRegion.
  ///
  /// In ru, this message translates to:
  /// **'Регион цен'**
  String get settingsRegion;

  /// No description provided for @regionKazakhstan.
  ///
  /// In ru, this message translates to:
  /// **'Казахстан, ₸'**
  String get regionKazakhstan;

  /// No description provided for @settingsAccount.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт'**
  String get settingsAccount;

  /// No description provided for @accountAnonymous.
  ///
  /// In ru, this message translates to:
  /// **'Анонимный аккаунт'**
  String get accountAnonymous;

  /// No description provided for @accountConnected.
  ///
  /// In ru, this message translates to:
  /// **'Подключено к серверу'**
  String get accountConnected;

  /// No description provided for @accountConnecting.
  ///
  /// In ru, this message translates to:
  /// **'Подключение…'**
  String get accountConnecting;

  /// No description provided for @settingsAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get settingsAbout;

  /// No description provided for @aboutVersion.
  ///
  /// In ru, this message translates to:
  /// **'Версия {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDataSource.
  ///
  /// In ru, this message translates to:
  /// **'Цены и онлайн собирает наш сервер из публичных данных Steam'**
  String get aboutDataSource;

  /// Обязательная пометка в настройках
  ///
  /// In ru, this message translates to:
  /// **'Не связано с Valve Corporation. Steam — товарный знак Valve Corporation.'**
  String get aboutDisclaimer;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @errorNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Нет связи с сервером. Проверьте интернет.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In ru, this message translates to:
  /// **'Сервер временно недоступен. Попробуйте позже.'**
  String get errorServer;

  /// No description provided for @errorNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get errorNotFound;

  /// No description provided for @errorUnauthorized.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось войти. Попробуйте ещё раз.'**
  String get errorUnauthorized;

  /// No description provided for @errorValidation.
  ///
  /// In ru, this message translates to:
  /// **'Неверные данные запроса'**
  String get errorValidation;

  /// No description provided for @errorUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так'**
  String get errorUnknown;

  /// No description provided for @updatedJustNow.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено только что'**
  String get updatedJustNow;

  /// No description provided for @updatedMinutesAgo.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено {minutes} мин назад'**
  String updatedMinutesAgo(int minutes);

  /// No description provided for @updatedAt.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено {time}'**
  String updatedAt(String time);

  /// No description provided for @refreshTooOften.
  ///
  /// In ru, this message translates to:
  /// **'Обновлять можно не чаще раза в минуту'**
  String get refreshTooOften;

  /// No description provided for @showingCachedData.
  ///
  /// In ru, this message translates to:
  /// **'Показаны сохранённые данные'**
  String get showingCachedData;

  /// No description provided for @back.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get back;

  /// No description provided for @aboutDataSourceTitle.
  ///
  /// In ru, this message translates to:
  /// **'Источник данных'**
  String get aboutDataSourceTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
