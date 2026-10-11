// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GameRadar';

  @override
  String get tabTop => 'Top';

  @override
  String get tabDiscounts => 'Deals';

  @override
  String get tabSearch => 'Search';

  @override
  String get tabWatchlist => 'Watchlist';

  @override
  String get topTitle => 'Most played';

  @override
  String get discountsTitle => 'Deals now';

  @override
  String get searchTitle => 'Search games';

  @override
  String get watchlistTitle => 'Watchlist';

  @override
  String get gameTitle => 'Game';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get comingSoon => 'This screen is coming in the next stage';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsRegion => 'Price region';

  @override
  String get regionKazakhstan => 'Kazakhstan, ₸';

  @override
  String get settingsAccount => 'Account';

  @override
  String get accountAnonymous => 'Anonymous account';

  @override
  String get accountConnected => 'Connected to the server';

  @override
  String get accountConnecting => 'Connecting…';

  @override
  String get settingsAbout => 'About';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDataSource =>
      'Prices and player counts are collected by our server from public Steam data';

  @override
  String get aboutDisclaimer =>
      'Not affiliated with Valve Corporation. Steam is a trademark of Valve Corporation.';

  @override
  String get retry => 'Retry';

  @override
  String get errorNetwork => 'Can\'t reach the server. Check your connection.';

  @override
  String get errorServer =>
      'The server is temporarily unavailable. Try again later.';

  @override
  String get errorNotFound => 'Nothing found';

  @override
  String get errorUnauthorized => 'Couldn\'t sign in. Please try again.';

  @override
  String get errorValidation => 'Invalid request';

  @override
  String get errorUnknown => 'Something went wrong';

  @override
  String get updatedJustNow => 'Updated just now';

  @override
  String updatedMinutesAgo(int minutes) {
    return 'Updated $minutes min ago';
  }

  @override
  String updatedAt(String time) {
    return 'Updated $time';
  }

  @override
  String get refreshTooOften => 'You can refresh at most once a minute';

  @override
  String get showingCachedData => 'Showing saved data';

  @override
  String get back => 'Back';

  @override
  String get aboutDataSourceTitle => 'Data source';

  @override
  String discountBadge(int percent) {
    return '−$percent%';
  }

  @override
  String get priceFree => 'Free';

  @override
  String get priceUnavailable => 'Not sold in your region';

  @override
  String get priceUnknown => 'Loading price…';

  @override
  String get topSortCurrent => 'Now';

  @override
  String get topSortPeak => '24h peak';

  @override
  String get filterDiscounted => 'On sale';

  @override
  String get topEmpty =>
      'The chart is still being built: the server is measuring player counts';

  @override
  String get sortDiscount => 'Discount';

  @override
  String get sortPrice => 'Price';

  @override
  String get sortPlayers => 'Players';

  @override
  String minDiscountChip(int percent) {
    return '$percent%+';
  }

  @override
  String maxPriceChip(String price) {
    return 'under $price';
  }

  @override
  String get discountsEmpty => 'No deals match these filters';

  @override
  String get searchPlaceholder => 'Game title';

  @override
  String get searchHint => 'Find a game to track its price and player count';

  @override
  String get searchTooShort => 'Type at least 2 characters';

  @override
  String searchNoResults(String query) {
    return 'Nothing found for “$query”';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get playersNow => 'Playing now';

  @override
  String get peak24h => '24h peak';

  @override
  String get peak7d => '7-day peak';

  @override
  String get players7d => 'Players over 7 days';

  @override
  String get chartNoData => 'Not enough data for a chart yet';

  @override
  String get gameDataPending =>
      'Collecting data about this game — refresh in a minute';

  @override
  String reviewsSummary(int percent, String total) {
    return '$percent% positive · $total';
  }

  @override
  String get releaseDate => 'Release date';

  @override
  String get developer => 'Developer';

  @override
  String get genres => 'Genres';

  @override
  String topRank(int rank) {
    return '#$rank by players';
  }

  @override
  String get watchAdd => 'Track price';

  @override
  String get watchEdit => 'Tracking';

  @override
  String get watchSheetTitle => 'Notify me when…';

  @override
  String watchCurrentPrice(String price) {
    return 'Now: $price';
  }

  @override
  String get targetPriceLabel => 'Price drops to';

  @override
  String get targetPricePlaceholder => 'Any';

  @override
  String get minDiscountLabel => 'Discount reaches';

  @override
  String get minDiscountOff => 'any';

  @override
  String get watchNoThresholds =>
      'Without conditions the game is just listed, no notifications';

  @override
  String get save => 'Save';

  @override
  String get removeFromWatchlist => 'Stop tracking';

  @override
  String get watchSaved => 'Game is being tracked';

  @override
  String get watchRemoved => 'No longer tracked';

  @override
  String get watchLimit => 'Your watchlist is full';

  @override
  String get watchlistEmpty =>
      'Games you track will appear here. Find one via search.';

  @override
  String get targetReached => 'Target reached';

  @override
  String thresholdPrice(String price) {
    return 'price ≤ $price';
  }

  @override
  String thresholdDiscount(int percent) {
    return 'discount ≥ $percent%';
  }

  @override
  String get noThresholds => 'no notifications';

  @override
  String get loadingMore => 'Loading…';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get pushStatusTitle => 'Push notifications';

  @override
  String get pushReady => 'Enabled on this device';

  @override
  String get pushNotAsked => 'Tap to allow';

  @override
  String get pushDenied => 'Blocked in system settings';

  @override
  String get pushUnavailable => 'Not configured in this build';

  @override
  String get pushStarting => 'Checking…';

  @override
  String get priceAlertsTitle => 'Price alerts';

  @override
  String get priceAlertsSubtitle => 'When a price or discount hits your target';

  @override
  String get quietHoursTitle => 'Quiet hours';

  @override
  String get quietHoursOff => 'Off';

  @override
  String quietHoursRange(String start, String end) {
    return '$start–$end';
  }

  @override
  String get quietHoursHint =>
      'No notifications during this time — they arrive afterwards';

  @override
  String get quietHoursEnable => 'Don’t disturb at night';

  @override
  String get quietHoursFrom => 'From';

  @override
  String get quietHoursTo => 'To';

  @override
  String get settingsSaveFailed => 'Couldn’t save settings';
}
