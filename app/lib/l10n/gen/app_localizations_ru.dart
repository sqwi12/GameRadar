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

  @override
  String get back => 'Назад';

  @override
  String get aboutDataSourceTitle => 'Источник данных';

  @override
  String discountBadge(int percent) {
    return '−$percent%';
  }

  @override
  String get priceFree => 'Бесплатно';

  @override
  String get priceUnavailable => 'Нет в продаже в регионе';

  @override
  String get priceUnknown => 'Цена загружается…';

  @override
  String get topSortCurrent => 'Сейчас';

  @override
  String get topSortPeak => 'Пик за 24 ч';

  @override
  String get filterDiscounted => 'Со скидкой';

  @override
  String get topEmpty => 'Топ ещё собирается: сервер замеряет онлайн игр';

  @override
  String get sortDiscount => 'Скидка';

  @override
  String get sortPrice => 'Цена';

  @override
  String get sortPlayers => 'Онлайн';

  @override
  String minDiscountChip(int percent) {
    return 'от $percent%';
  }

  @override
  String maxPriceChip(String price) {
    return 'до $price';
  }

  @override
  String get discountsEmpty => 'Скидок по этим фильтрам нет';

  @override
  String get searchPlaceholder => 'Название игры';

  @override
  String get searchHint => 'Найдите игру, чтобы следить за её ценой и онлайном';

  @override
  String get searchTooShort => 'Введите хотя бы 2 символа';

  @override
  String searchNoResults(String query) {
    return 'Ничего не найдено по запросу «$query»';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get playersNow => 'Сейчас играют';

  @override
  String get peak24h => 'Пик за 24 ч';

  @override
  String get peak7d => 'Пик за 7 дней';

  @override
  String get players7d => 'Онлайн за 7 дней';

  @override
  String get chartNoData => 'Пока мало замеров для графика';

  @override
  String get gameDataPending =>
      'Собираем данные об игре — обновите экран через минуту';

  @override
  String reviewsSummary(int percent, String total) {
    return '$percent% положительных · $total';
  }

  @override
  String get releaseDate => 'Дата выхода';

  @override
  String get developer => 'Разработчик';

  @override
  String get genres => 'Жанры';

  @override
  String topRank(int rank) {
    return '#$rank по онлайну';
  }

  @override
  String get watchAdd => 'Отслеживать цену';

  @override
  String get watchEdit => 'Отслеживается';

  @override
  String get watchSheetTitle => 'Уведомить, когда…';

  @override
  String watchCurrentPrice(String price) {
    return 'Сейчас: $price';
  }

  @override
  String get targetPriceLabel => 'Цена станет не выше';

  @override
  String get targetPricePlaceholder => 'Любая';

  @override
  String get minDiscountLabel => 'Скидка станет не меньше';

  @override
  String get minDiscountOff => 'не важна';

  @override
  String get watchNoThresholds =>
      'Без условий игра просто будет в списке, без уведомлений';

  @override
  String get save => 'Сохранить';

  @override
  String get removeFromWatchlist => 'Перестать отслеживать';

  @override
  String get watchSaved => 'Игра в отслеживаемых';

  @override
  String get watchRemoved => 'Больше не отслеживается';

  @override
  String get watchLimit => 'В списке уже максимум игр';

  @override
  String get watchlistEmpty =>
      'Здесь появятся игры, за ценой которых вы следите. Найдите игру через поиск.';

  @override
  String get targetReached => 'Цель достигнута';

  @override
  String thresholdPrice(String price) {
    return 'цена ≤ $price';
  }

  @override
  String thresholdDiscount(int percent) {
    return 'скидка ≥ $percent%';
  }

  @override
  String get noThresholds => 'без уведомлений';

  @override
  String get loadingMore => 'Загрузка…';

  @override
  String get settingsNotifications => 'Уведомления';

  @override
  String get pushStatusTitle => 'Push-уведомления';

  @override
  String get pushReady => 'Включены на этом устройстве';

  @override
  String get pushNotAsked => 'Нажмите, чтобы разрешить';

  @override
  String get pushDenied => 'Запрещены в настройках системы';

  @override
  String get pushUnavailable => 'Не настроены в этой сборке';

  @override
  String get pushStarting => 'Проверка…';

  @override
  String get priceAlertsTitle => 'Уведомлять о ценах';

  @override
  String get priceAlertsSubtitle => 'Когда цена или скидка достигнет порога';

  @override
  String get quietHoursTitle => 'Тихие часы';

  @override
  String get quietHoursOff => 'Выключены';

  @override
  String quietHoursRange(String start, String end) {
    return '$start–$end';
  }

  @override
  String get quietHoursHint =>
      'В это время уведомления не приходят — они будут доставлены после';

  @override
  String get quietHoursEnable => 'Не беспокоить ночью';

  @override
  String get quietHoursFrom => 'С';

  @override
  String get quietHoursTo => 'До';

  @override
  String get settingsSaveFailed => 'Не удалось сохранить настройки';

  @override
  String get steamSection => 'Steam';

  @override
  String get steamImportTitle => 'Импорт списка желаемого';

  @override
  String get steamSectionFooter =>
      'Игры из списка желаемого Steam сами попадают в отслеживаемые и обновляются раз в сутки. Вход в Steam не нужен, но профиль и список желаемого должны быть видны всем.';

  @override
  String get steamNotLinked => 'Не подключён — нажмите, чтобы подключить';

  @override
  String get steamPending => 'Импорт… обычно меньше минуты';

  @override
  String get steamPrivate => 'Steam не показывает профиль или список желаемого';

  @override
  String get steamNotFound => 'Профиль не найден';

  @override
  String steamImported(String name, int imported, int total) {
    return '$name · импортировано $imported из $total';
  }

  @override
  String get steamSheetIntro =>
      'Вставьте ссылку на свой профиль Steam или его короткое имя. Игры из списка желаемого появятся в отслеживаемых.';

  @override
  String get steamProfileLabel => 'Ссылка на профиль или ник';

  @override
  String get steamProfilePlaceholder => 'steamcommunity.com/id/…';

  @override
  String get steamProfileInvalid =>
      'Нужна ссылка вида steamcommunity.com/id/… или …/profiles/…, либо короткое имя профиля';

  @override
  String get steamImportDiscountLabel => 'Уведомлять о скидке от';

  @override
  String get steamImportDiscountHint =>
      'Порог для импортированных игр. У любой игры его можно поменять вручную — тогда она перестанет обновляться из Steam.';

  @override
  String get steamImportButton => 'Импортировать';

  @override
  String get steamResyncButton => 'Синхронизировать сейчас';

  @override
  String get steamImportStarted => 'Импорт начался';

  @override
  String get steamUnlink => 'Отвязать профиль';

  @override
  String get steamUnlinkHint =>
      'Импортированные игры будут убраны из отслеживаемых. Игры, добавленные или изменённые вручную, останутся.';

  @override
  String get steamUnlinkConfirm => 'Отвязать';

  @override
  String get steamUnlinked => 'Профиль отвязан';

  @override
  String get steamPendingHint =>
      'Список желаемого загружается. Можно закрыть настройки — игры появятся в отслеживаемых сами.';

  @override
  String get steamPrivateHint =>
      'Steam скрывает ваш список желаемого от посторонних. В Steam: Профиль → Редактировать профиль → Приватность — сделайте «Мой профиль» и «Сведения об играх» открытыми. Проверить можно так: откройте свой список желаемого в браузере, не входя в Steam. Изменения применяются не сразу — через несколько минут нажмите «Синхронизировать сейчас».';

  @override
  String get steamNotFoundHint =>
      'Проверьте ссылку: откройте свой профиль в Steam и скопируйте адрес страницы.';

  @override
  String get steamOkHint =>
      'Список обновляется раз в сутки: новые игры добавляются, убранные из списка желаемого — убираются.';

  @override
  String get wishlistBadge => 'Из списка желаемого Steam';

  @override
  String get watchWishlistHint =>
      'Игра импортирована из списка желаемого Steam. После сохранения порогов она перестанет обновляться оттуда.';

  @override
  String get steamEmptyHint =>
      'Список желаемого открыт, но пуст. Добавьте игры в Steam — они появятся здесь при следующей синхронизации.';

  @override
  String get period24h => '24 ч';

  @override
  String get period7d => '7 дн';

  @override
  String get period30d => '30 дн';

  @override
  String get chartHoldHint =>
      'Зажмите график и ведите пальцем, чтобы увидеть каждый замер';

  @override
  String get priceHistoryTitle => 'История цены';

  @override
  String get priceNowLabel => 'Сейчас';

  @override
  String get priceBestLabel => 'Лучшая цена';

  @override
  String priceBestWithDiscount(String discount) {
    return 'Лучшая, $discount';
  }

  @override
  String get priceRegularLabel => 'Без скидки';

  @override
  String get priceHistoryEmpty => 'История появится после первой проверки цены';

  @override
  String priceTrackedSince(String date) {
    return 'Отслеживаем с $date';
  }

  @override
  String priceBestOn(String date) {
    return 'лучшая — $date';
  }

  @override
  String get metricPlayers => 'Онлайн';

  @override
  String get metricPrice => 'Цена';

  @override
  String get periodAll => 'Всё';

  @override
  String get playersPeakPeriod => 'Пик за период';

  @override
  String get playersAverage => 'В среднем';

  @override
  String playersReadings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count замеров',
      few: '$count замера',
      one: '$count замер',
    );
    return '$_temp0 за период';
  }

  @override
  String playersDailyPeaks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней',
      few: '$count дня',
      one: '$count день',
    );
    return 'Максимум за сутки · $_temp0';
  }

  @override
  String allTimeLowSource(String date) {
    return 'Минимум за всё время — $date · IsThereAnyDeal';
  }

  @override
  String get bestCutLabel => 'Лучшая скидка';

  @override
  String bestCutSource(String date) {
    return 'Лучшая скидка в Steam — $date · IsThereAnyDeal';
  }

  @override
  String get allTimeLowShort => 'минимум';

  @override
  String allTimeLowLabel(String discount) {
    return 'Мин. всё время, $discount';
  }

  @override
  String get priceNowAtLow => 'Сейчас — минимум';

  @override
  String get recordLowAlertsTitle => 'Рекордно низкие цены';

  @override
  String get recordLowAlertsSubtitle =>
      'Когда отслеживаемая игра дешевле, чем когда-либо в Steam';

  @override
  String get regionsTitle => 'Цены в других регионах';

  @override
  String get regionsIntro =>
      'Та же игра в Steam других стран — в тенге по курсу Нацбанка Казахстана.';

  @override
  String get regionsEmpty =>
      'Цены других регионов ещё загружаются — загляните через несколько минут.';

  @override
  String get regionsFootnote =>
      'Купить можно только в регионе своего аккаунта Steam. Курс НБК обновляется раз в сутки, суммы приблизительные.';

  @override
  String get regionsSame => 'так же';

  @override
  String get regionsHome => 'ваш регион';

  @override
  String get regionKz => 'Казахстан';

  @override
  String get regionUs => 'США';

  @override
  String get regionDe => 'Германия (евро)';

  @override
  String get regionTr => 'Турция';

  @override
  String get regionAr => 'Аргентина';

  @override
  String get regionRu => 'Россия';

  @override
  String get regionIn => 'Индия';

  @override
  String get saleSpring => 'Весенняя распродажа Steam';

  @override
  String get saleSummer => 'Летняя распродажа Steam';

  @override
  String get saleAutumn => 'Осенняя распродажа Steam';

  @override
  String get saleWinter => 'Зимняя распродажа Steam';

  @override
  String saleActive(String name, String date) {
    return '$name идёт сейчас — до $date';
  }

  @override
  String saleTomorrow(String name) {
    return '$name начинается завтра';
  }

  @override
  String saleIn(String name, int days, String dates) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return '$name через $_temp0 · $dates';
  }

  @override
  String get filterFree => 'Бесплатные';

  @override
  String get genreTitle => 'Жанр';

  @override
  String get genreAny => 'Все жанры';

  @override
  String get genreAction => 'Экшен';

  @override
  String get genreAdventure => 'Приключения';

  @override
  String get genreRpg => 'Ролевые';

  @override
  String get genreStrategy => 'Стратегии';

  @override
  String get genreSimulation => 'Симуляторы';

  @override
  String get genreIndie => 'Инди';

  @override
  String get genreCasual => 'Казуальные';

  @override
  String get genreSports => 'Спорт';

  @override
  String get genreRacing => 'Гонки';

  @override
  String get genreMmo => 'ММО';

  @override
  String get genreEarlyAccess => 'Ранний доступ';

  @override
  String get share => 'Поделиться';

  @override
  String get shareVia => 'Нашёл в GameRadar';

  @override
  String get widgetTitle => 'GameRadar · Отслеживаю';

  @override
  String get widgetEmpty =>
      'Добавьте игры в «Отслеживаю» — здесь появятся цены и скидки';
}
