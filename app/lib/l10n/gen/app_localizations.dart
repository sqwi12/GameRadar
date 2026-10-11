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

  /// No description provided for @discountBadge.
  ///
  /// In ru, this message translates to:
  /// **'−{percent}%'**
  String discountBadge(int percent);

  /// No description provided for @priceFree.
  ///
  /// In ru, this message translates to:
  /// **'Бесплатно'**
  String get priceFree;

  /// No description provided for @priceUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Нет в продаже в регионе'**
  String get priceUnavailable;

  /// No description provided for @priceUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Цена загружается…'**
  String get priceUnknown;

  /// No description provided for @topSortCurrent.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас'**
  String get topSortCurrent;

  /// No description provided for @topSortPeak.
  ///
  /// In ru, this message translates to:
  /// **'Пик за 24 ч'**
  String get topSortPeak;

  /// No description provided for @filterDiscounted.
  ///
  /// In ru, this message translates to:
  /// **'Со скидкой'**
  String get filterDiscounted;

  /// No description provided for @topEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Топ ещё собирается: сервер замеряет онлайн игр'**
  String get topEmpty;

  /// No description provided for @sortDiscount.
  ///
  /// In ru, this message translates to:
  /// **'Скидка'**
  String get sortDiscount;

  /// No description provided for @sortPrice.
  ///
  /// In ru, this message translates to:
  /// **'Цена'**
  String get sortPrice;

  /// No description provided for @sortPlayers.
  ///
  /// In ru, this message translates to:
  /// **'Онлайн'**
  String get sortPlayers;

  /// No description provided for @minDiscountChip.
  ///
  /// In ru, this message translates to:
  /// **'от {percent}%'**
  String minDiscountChip(int percent);

  /// No description provided for @maxPriceChip.
  ///
  /// In ru, this message translates to:
  /// **'до {price}'**
  String maxPriceChip(String price);

  /// No description provided for @discountsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Скидок по этим фильтрам нет'**
  String get discountsEmpty;

  /// No description provided for @searchPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Название игры'**
  String get searchPlaceholder;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Найдите игру, чтобы следить за её ценой и онлайном'**
  String get searchHint;

  /// No description provided for @searchTooShort.
  ///
  /// In ru, this message translates to:
  /// **'Введите хотя бы 2 символа'**
  String get searchTooShort;

  /// No description provided for @searchNoResults.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено по запросу «{query}»'**
  String searchNoResults(String query);

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @playersNow.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас играют'**
  String get playersNow;

  /// No description provided for @peak24h.
  ///
  /// In ru, this message translates to:
  /// **'Пик за 24 ч'**
  String get peak24h;

  /// No description provided for @peak7d.
  ///
  /// In ru, this message translates to:
  /// **'Пик за 7 дней'**
  String get peak7d;

  /// No description provided for @players7d.
  ///
  /// In ru, this message translates to:
  /// **'Онлайн за 7 дней'**
  String get players7d;

  /// No description provided for @chartNoData.
  ///
  /// In ru, this message translates to:
  /// **'Пока мало замеров для графика'**
  String get chartNoData;

  /// No description provided for @gameDataPending.
  ///
  /// In ru, this message translates to:
  /// **'Собираем данные об игре — обновите экран через минуту'**
  String get gameDataPending;

  /// No description provided for @reviewsSummary.
  ///
  /// In ru, this message translates to:
  /// **'{percent}% положительных · {total}'**
  String reviewsSummary(int percent, String total);

  /// No description provided for @releaseDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата выхода'**
  String get releaseDate;

  /// No description provided for @developer.
  ///
  /// In ru, this message translates to:
  /// **'Разработчик'**
  String get developer;

  /// No description provided for @genres.
  ///
  /// In ru, this message translates to:
  /// **'Жанры'**
  String get genres;

  /// No description provided for @topRank.
  ///
  /// In ru, this message translates to:
  /// **'#{rank} по онлайну'**
  String topRank(int rank);

  /// No description provided for @watchAdd.
  ///
  /// In ru, this message translates to:
  /// **'Отслеживать цену'**
  String get watchAdd;

  /// No description provided for @watchEdit.
  ///
  /// In ru, this message translates to:
  /// **'Отслеживается'**
  String get watchEdit;

  /// No description provided for @watchSheetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Уведомить, когда…'**
  String get watchSheetTitle;

  /// No description provided for @watchCurrentPrice.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас: {price}'**
  String watchCurrentPrice(String price);

  /// No description provided for @targetPriceLabel.
  ///
  /// In ru, this message translates to:
  /// **'Цена станет не выше'**
  String get targetPriceLabel;

  /// No description provided for @targetPricePlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Любая'**
  String get targetPricePlaceholder;

  /// No description provided for @minDiscountLabel.
  ///
  /// In ru, this message translates to:
  /// **'Скидка станет не меньше'**
  String get minDiscountLabel;

  /// No description provided for @minDiscountOff.
  ///
  /// In ru, this message translates to:
  /// **'не важна'**
  String get minDiscountOff;

  /// No description provided for @watchNoThresholds.
  ///
  /// In ru, this message translates to:
  /// **'Без условий игра просто будет в списке, без уведомлений'**
  String get watchNoThresholds;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @removeFromWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'Перестать отслеживать'**
  String get removeFromWatchlist;

  /// No description provided for @watchSaved.
  ///
  /// In ru, this message translates to:
  /// **'Игра в отслеживаемых'**
  String get watchSaved;

  /// No description provided for @watchRemoved.
  ///
  /// In ru, this message translates to:
  /// **'Больше не отслеживается'**
  String get watchRemoved;

  /// No description provided for @watchLimit.
  ///
  /// In ru, this message translates to:
  /// **'В списке уже максимум игр'**
  String get watchLimit;

  /// No description provided for @watchlistEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Здесь появятся игры, за ценой которых вы следите. Найдите игру через поиск.'**
  String get watchlistEmpty;

  /// No description provided for @targetReached.
  ///
  /// In ru, this message translates to:
  /// **'Цель достигнута'**
  String get targetReached;

  /// No description provided for @thresholdPrice.
  ///
  /// In ru, this message translates to:
  /// **'цена ≤ {price}'**
  String thresholdPrice(String price);

  /// No description provided for @thresholdDiscount.
  ///
  /// In ru, this message translates to:
  /// **'скидка ≥ {percent}%'**
  String thresholdDiscount(int percent);

  /// No description provided for @noThresholds.
  ///
  /// In ru, this message translates to:
  /// **'без уведомлений'**
  String get noThresholds;

  /// No description provided for @loadingMore.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка…'**
  String get loadingMore;

  /// No description provided for @settingsNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get settingsNotifications;

  /// No description provided for @pushStatusTitle.
  ///
  /// In ru, this message translates to:
  /// **'Push-уведомления'**
  String get pushStatusTitle;

  /// No description provided for @pushReady.
  ///
  /// In ru, this message translates to:
  /// **'Включены на этом устройстве'**
  String get pushReady;

  /// No description provided for @pushNotAsked.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите, чтобы разрешить'**
  String get pushNotAsked;

  /// No description provided for @pushDenied.
  ///
  /// In ru, this message translates to:
  /// **'Запрещены в настройках системы'**
  String get pushDenied;

  /// No description provided for @pushUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Не настроены в этой сборке'**
  String get pushUnavailable;

  /// No description provided for @pushStarting.
  ///
  /// In ru, this message translates to:
  /// **'Проверка…'**
  String get pushStarting;

  /// No description provided for @priceAlertsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Уведомлять о ценах'**
  String get priceAlertsTitle;

  /// No description provided for @priceAlertsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Когда цена или скидка достигнет порога'**
  String get priceAlertsSubtitle;

  /// No description provided for @quietHoursTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тихие часы'**
  String get quietHoursTitle;

  /// No description provided for @quietHoursOff.
  ///
  /// In ru, this message translates to:
  /// **'Выключены'**
  String get quietHoursOff;

  /// No description provided for @quietHoursRange.
  ///
  /// In ru, this message translates to:
  /// **'{start}–{end}'**
  String quietHoursRange(String start, String end);

  /// No description provided for @quietHoursHint.
  ///
  /// In ru, this message translates to:
  /// **'В это время уведомления не приходят — они будут доставлены после'**
  String get quietHoursHint;

  /// No description provided for @quietHoursEnable.
  ///
  /// In ru, this message translates to:
  /// **'Не беспокоить ночью'**
  String get quietHoursEnable;

  /// No description provided for @quietHoursFrom.
  ///
  /// In ru, this message translates to:
  /// **'С'**
  String get quietHoursFrom;

  /// No description provided for @quietHoursTo.
  ///
  /// In ru, this message translates to:
  /// **'До'**
  String get quietHoursTo;

  /// No description provided for @settingsSaveFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить настройки'**
  String get settingsSaveFailed;

  /// No description provided for @steamSection.
  ///
  /// In ru, this message translates to:
  /// **'Steam'**
  String get steamSection;

  /// No description provided for @steamImportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Импорт списка желаемого'**
  String get steamImportTitle;

  /// No description provided for @steamSectionFooter.
  ///
  /// In ru, this message translates to:
  /// **'Игры из списка желаемого Steam сами попадают в отслеживаемые и обновляются раз в сутки. Вход в Steam не нужен, но профиль и список желаемого должны быть видны всем.'**
  String get steamSectionFooter;

  /// No description provided for @steamNotLinked.
  ///
  /// In ru, this message translates to:
  /// **'Не подключён — нажмите, чтобы подключить'**
  String get steamNotLinked;

  /// No description provided for @steamPending.
  ///
  /// In ru, this message translates to:
  /// **'Импорт… обычно меньше минуты'**
  String get steamPending;

  /// No description provided for @steamPrivate.
  ///
  /// In ru, this message translates to:
  /// **'Steam не показывает профиль или список желаемого'**
  String get steamPrivate;

  /// No description provided for @steamNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Профиль не найден'**
  String get steamNotFound;

  /// No description provided for @steamImported.
  ///
  /// In ru, this message translates to:
  /// **'{name} · импортировано {imported} из {total}'**
  String steamImported(String name, int imported, int total);

  /// No description provided for @steamSheetIntro.
  ///
  /// In ru, this message translates to:
  /// **'Вставьте ссылку на свой профиль Steam или его короткое имя. Игры из списка желаемого появятся в отслеживаемых.'**
  String get steamSheetIntro;

  /// No description provided for @steamProfileLabel.
  ///
  /// In ru, this message translates to:
  /// **'Ссылка на профиль или ник'**
  String get steamProfileLabel;

  /// No description provided for @steamProfilePlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'steamcommunity.com/id/…'**
  String get steamProfilePlaceholder;

  /// No description provided for @steamProfileInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Нужна ссылка вида steamcommunity.com/id/… или …/profiles/…, либо короткое имя профиля'**
  String get steamProfileInvalid;

  /// No description provided for @steamImportDiscountLabel.
  ///
  /// In ru, this message translates to:
  /// **'Уведомлять о скидке от'**
  String get steamImportDiscountLabel;

  /// No description provided for @steamImportDiscountHint.
  ///
  /// In ru, this message translates to:
  /// **'Порог для импортированных игр. У любой игры его можно поменять вручную — тогда она перестанет обновляться из Steam.'**
  String get steamImportDiscountHint;

  /// No description provided for @steamImportButton.
  ///
  /// In ru, this message translates to:
  /// **'Импортировать'**
  String get steamImportButton;

  /// No description provided for @steamResyncButton.
  ///
  /// In ru, this message translates to:
  /// **'Синхронизировать сейчас'**
  String get steamResyncButton;

  /// No description provided for @steamImportStarted.
  ///
  /// In ru, this message translates to:
  /// **'Импорт начался'**
  String get steamImportStarted;

  /// No description provided for @steamUnlink.
  ///
  /// In ru, this message translates to:
  /// **'Отвязать профиль'**
  String get steamUnlink;

  /// No description provided for @steamUnlinkHint.
  ///
  /// In ru, this message translates to:
  /// **'Импортированные игры будут убраны из отслеживаемых. Игры, добавленные или изменённые вручную, останутся.'**
  String get steamUnlinkHint;

  /// No description provided for @steamUnlinkConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Отвязать'**
  String get steamUnlinkConfirm;

  /// No description provided for @steamUnlinked.
  ///
  /// In ru, this message translates to:
  /// **'Профиль отвязан'**
  String get steamUnlinked;

  /// No description provided for @steamPendingHint.
  ///
  /// In ru, this message translates to:
  /// **'Список желаемого загружается. Можно закрыть настройки — игры появятся в отслеживаемых сами.'**
  String get steamPendingHint;

  /// No description provided for @steamPrivateHint.
  ///
  /// In ru, this message translates to:
  /// **'Steam скрывает ваш список желаемого от посторонних. В Steam: Профиль → Редактировать профиль → Приватность — сделайте «Мой профиль» и «Сведения об играх» открытыми. Проверить можно так: откройте свой список желаемого в браузере, не входя в Steam. Изменения применяются не сразу — через несколько минут нажмите «Синхронизировать сейчас».'**
  String get steamPrivateHint;

  /// No description provided for @steamNotFoundHint.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте ссылку: откройте свой профиль в Steam и скопируйте адрес страницы.'**
  String get steamNotFoundHint;

  /// No description provided for @steamOkHint.
  ///
  /// In ru, this message translates to:
  /// **'Список обновляется раз в сутки: новые игры добавляются, убранные из списка желаемого — убираются.'**
  String get steamOkHint;

  /// No description provided for @wishlistBadge.
  ///
  /// In ru, this message translates to:
  /// **'Из списка желаемого Steam'**
  String get wishlistBadge;

  /// No description provided for @watchWishlistHint.
  ///
  /// In ru, this message translates to:
  /// **'Игра импортирована из списка желаемого Steam. После сохранения порогов она перестанет обновляться оттуда.'**
  String get watchWishlistHint;

  /// No description provided for @steamEmptyHint.
  ///
  /// In ru, this message translates to:
  /// **'Список желаемого открыт, но пуст. Добавьте игры в Steam — они появятся здесь при следующей синхронизации.'**
  String get steamEmptyHint;

  /// No description provided for @period24h.
  ///
  /// In ru, this message translates to:
  /// **'24 ч'**
  String get period24h;

  /// No description provided for @period7d.
  ///
  /// In ru, this message translates to:
  /// **'7 дн'**
  String get period7d;

  /// No description provided for @period30d.
  ///
  /// In ru, this message translates to:
  /// **'30 дн'**
  String get period30d;

  /// No description provided for @chartHoldHint.
  ///
  /// In ru, this message translates to:
  /// **'Зажмите график и ведите пальцем, чтобы увидеть каждый замер'**
  String get chartHoldHint;

  /// No description provided for @priceHistoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'История цены'**
  String get priceHistoryTitle;

  /// No description provided for @priceNowLabel.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас'**
  String get priceNowLabel;

  /// No description provided for @priceBestLabel.
  ///
  /// In ru, this message translates to:
  /// **'Лучшая цена'**
  String get priceBestLabel;

  /// No description provided for @priceBestWithDiscount.
  ///
  /// In ru, this message translates to:
  /// **'Лучшая, {discount}'**
  String priceBestWithDiscount(String discount);

  /// No description provided for @priceRegularLabel.
  ///
  /// In ru, this message translates to:
  /// **'Без скидки'**
  String get priceRegularLabel;

  /// No description provided for @priceHistoryEmpty.
  ///
  /// In ru, this message translates to:
  /// **'История появится после первой проверки цены'**
  String get priceHistoryEmpty;

  /// No description provided for @priceTrackedSince.
  ///
  /// In ru, this message translates to:
  /// **'Отслеживаем с {date}'**
  String priceTrackedSince(String date);

  /// No description provided for @priceBestOn.
  ///
  /// In ru, this message translates to:
  /// **'лучшая — {date}'**
  String priceBestOn(String date);

  /// No description provided for @metricPlayers.
  ///
  /// In ru, this message translates to:
  /// **'Онлайн'**
  String get metricPlayers;

  /// No description provided for @metricPrice.
  ///
  /// In ru, this message translates to:
  /// **'Цена'**
  String get metricPrice;

  /// No description provided for @periodAll.
  ///
  /// In ru, this message translates to:
  /// **'Всё'**
  String get periodAll;

  /// No description provided for @playersPeakPeriod.
  ///
  /// In ru, this message translates to:
  /// **'Пик за период'**
  String get playersPeakPeriod;

  /// No description provided for @playersAverage.
  ///
  /// In ru, this message translates to:
  /// **'В среднем'**
  String get playersAverage;

  /// No description provided for @playersReadings.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} замер} few{{count} замера} other{{count} замеров}} за период'**
  String playersReadings(int count);

  /// No description provided for @playersDailyPeaks.
  ///
  /// In ru, this message translates to:
  /// **'Максимум за сутки · {count, plural, one{{count} день} few{{count} дня} other{{count} дней}}'**
  String playersDailyPeaks(int count);

  /// No description provided for @allTimeLowSource.
  ///
  /// In ru, this message translates to:
  /// **'Минимум за всё время — {date} · IsThereAnyDeal'**
  String allTimeLowSource(String date);

  /// No description provided for @allTimeLowShort.
  ///
  /// In ru, this message translates to:
  /// **'минимум'**
  String get allTimeLowShort;

  /// No description provided for @allTimeLowLabel.
  ///
  /// In ru, this message translates to:
  /// **'Мин. всё время, {discount}'**
  String allTimeLowLabel(String discount);

  /// No description provided for @priceNowAtLow.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас — минимум'**
  String get priceNowAtLow;

  /// No description provided for @recordLowAlertsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Рекордно низкие цены'**
  String get recordLowAlertsTitle;

  /// No description provided for @recordLowAlertsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Когда отслеживаемая игра дешевле, чем когда-либо в Steam'**
  String get recordLowAlertsSubtitle;

  /// No description provided for @regionsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Цены в других регионах'**
  String get regionsTitle;

  /// No description provided for @regionsIntro.
  ///
  /// In ru, this message translates to:
  /// **'Та же игра в Steam других стран — в тенге по курсу Нацбанка Казахстана.'**
  String get regionsIntro;

  /// No description provided for @regionsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Цены других регионов ещё загружаются — загляните через несколько минут.'**
  String get regionsEmpty;

  /// No description provided for @regionsFootnote.
  ///
  /// In ru, this message translates to:
  /// **'Купить можно только в регионе своего аккаунта Steam. Курс НБК обновляется раз в сутки, суммы приблизительные.'**
  String get regionsFootnote;

  /// No description provided for @regionsSame.
  ///
  /// In ru, this message translates to:
  /// **'так же'**
  String get regionsSame;

  /// No description provided for @regionsHome.
  ///
  /// In ru, this message translates to:
  /// **'ваш регион'**
  String get regionsHome;

  /// No description provided for @regionKz.
  ///
  /// In ru, this message translates to:
  /// **'Казахстан'**
  String get regionKz;

  /// No description provided for @regionUs.
  ///
  /// In ru, this message translates to:
  /// **'США'**
  String get regionUs;

  /// No description provided for @regionDe.
  ///
  /// In ru, this message translates to:
  /// **'Германия (евро)'**
  String get regionDe;

  /// No description provided for @regionTr.
  ///
  /// In ru, this message translates to:
  /// **'Турция'**
  String get regionTr;

  /// No description provided for @regionAr.
  ///
  /// In ru, this message translates to:
  /// **'Аргентина'**
  String get regionAr;

  /// No description provided for @regionRu.
  ///
  /// In ru, this message translates to:
  /// **'Россия'**
  String get regionRu;

  /// No description provided for @regionIn.
  ///
  /// In ru, this message translates to:
  /// **'Индия'**
  String get regionIn;

  /// No description provided for @saleSpring.
  ///
  /// In ru, this message translates to:
  /// **'Весенняя распродажа Steam'**
  String get saleSpring;

  /// No description provided for @saleSummer.
  ///
  /// In ru, this message translates to:
  /// **'Летняя распродажа Steam'**
  String get saleSummer;

  /// No description provided for @saleAutumn.
  ///
  /// In ru, this message translates to:
  /// **'Осенняя распродажа Steam'**
  String get saleAutumn;

  /// No description provided for @saleWinter.
  ///
  /// In ru, this message translates to:
  /// **'Зимняя распродажа Steam'**
  String get saleWinter;

  /// No description provided for @saleActive.
  ///
  /// In ru, this message translates to:
  /// **'{name} идёт сейчас — до {date}'**
  String saleActive(String name, String date);

  /// No description provided for @saleTomorrow.
  ///
  /// In ru, this message translates to:
  /// **'{name} начинается завтра'**
  String saleTomorrow(String name);

  /// No description provided for @saleIn.
  ///
  /// In ru, this message translates to:
  /// **'{name} через {days, plural, one{{days} день} few{{days} дня} other{{days} дней}} · {dates}'**
  String saleIn(String name, int days, String dates);
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
