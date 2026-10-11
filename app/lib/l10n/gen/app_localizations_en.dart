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

  @override
  String get steamSection => 'Steam';

  @override
  String get steamImportTitle => 'Wishlist import';

  @override
  String get steamSectionFooter =>
      'Games from your Steam wishlist are added to your watchlist automatically and refreshed once a day. No Steam sign-in is needed, but your profile and wishlist must be visible to everyone.';

  @override
  String get steamNotLinked => 'Not connected — tap to set up';

  @override
  String get steamPending => 'Importing… usually under a minute';

  @override
  String get steamPrivate => 'Steam doesn\'t show the profile or wishlist';

  @override
  String get steamNotFound => 'Profile not found';

  @override
  String steamImported(String name, int imported, int total) {
    return '$name · $imported of $total imported';
  }

  @override
  String get steamSheetIntro =>
      'Paste a link to your Steam profile or its custom URL name. Games from your wishlist will appear in your watchlist.';

  @override
  String get steamProfileLabel => 'Profile link or custom URL';

  @override
  String get steamProfilePlaceholder => 'steamcommunity.com/id/…';

  @override
  String get steamProfileInvalid =>
      'Expected a link like steamcommunity.com/id/… or …/profiles/…, or a custom URL name';

  @override
  String get steamImportDiscountLabel => 'Notify about discounts from';

  @override
  String get steamImportDiscountHint =>
      'Threshold for imported games. You can change it for any game manually — it then stops syncing from Steam.';

  @override
  String get steamImportButton => 'Import';

  @override
  String get steamResyncButton => 'Sync now';

  @override
  String get steamImportStarted => 'Import started';

  @override
  String get steamUnlink => 'Disconnect profile';

  @override
  String get steamUnlinkHint =>
      'Imported games will be removed from your watchlist. Games you added or edited manually stay.';

  @override
  String get steamUnlinkConfirm => 'Disconnect';

  @override
  String get steamUnlinked => 'Profile disconnected';

  @override
  String get steamPendingHint =>
      'Loading your wishlist. You can leave settings — the games will show up in your watchlist.';

  @override
  String get steamPrivateHint =>
      'Steam hides your wishlist from others. In Steam: Profile → Edit Profile → Privacy Settings — set “My profile” and “Game details” to Public. To check, open your wishlist in a browser while signed out of Steam. Changes apply with a delay — tap “Sync now” in a few minutes.';

  @override
  String get steamNotFoundHint =>
      'Check the link: open your profile in Steam and copy the page address.';

  @override
  String get steamOkHint =>
      'The list refreshes daily: new games are added, games removed from your wishlist are removed.';

  @override
  String get wishlistBadge => 'From your Steam wishlist';

  @override
  String get watchWishlistHint =>
      'Imported from your Steam wishlist. After you save thresholds it stops syncing from there.';

  @override
  String get steamEmptyHint =>
      'Your wishlist is public but empty. Add games in Steam — they\'ll appear here on the next sync.';

  @override
  String get period24h => '24 h';

  @override
  String get period7d => '7 d';

  @override
  String get period30d => '30 d';

  @override
  String get chartHoldHint =>
      'Press and slide along the chart to see every reading';

  @override
  String get priceHistoryTitle => 'Price history';

  @override
  String get priceNowLabel => 'Now';

  @override
  String get priceBestLabel => 'Best price';

  @override
  String priceBestWithDiscount(String discount) {
    return 'Best, $discount';
  }

  @override
  String get priceRegularLabel => 'Regular';

  @override
  String get priceHistoryEmpty => 'History appears after the first price check';

  @override
  String priceTrackedSince(String date) {
    return 'Tracking since $date';
  }

  @override
  String priceBestOn(String date) {
    return 'best on $date';
  }

  @override
  String get metricPlayers => 'Players';

  @override
  String get metricPrice => 'Price';

  @override
  String get periodAll => 'All';

  @override
  String get playersPeakPeriod => 'Period peak';

  @override
  String get playersAverage => 'Average';

  @override
  String playersReadings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings',
      one: '$count reading',
    );
    return '$_temp0 in this period';
  }

  @override
  String playersDailyPeaks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return 'Daily peak · $_temp0';
  }

  @override
  String allTimeLowSource(String date) {
    return 'All-time low on $date · IsThereAnyDeal';
  }

  @override
  String get allTimeLowShort => 'all-time low';

  @override
  String allTimeLowLabel(String discount) {
    return 'All-time low, $discount';
  }

  @override
  String get priceNowAtLow => 'Now — all-time low';

  @override
  String get recordLowAlertsTitle => 'Record low prices';

  @override
  String get recordLowAlertsSubtitle =>
      'When a watched game is cheaper than ever on Steam';

  @override
  String get regionsTitle => 'Prices in other regions';

  @override
  String get regionsIntro =>
      'The same game on Steam in other countries, converted to tenge at the National Bank of Kazakhstan rate.';

  @override
  String get regionsEmpty =>
      'Prices for other regions are still loading — check back in a few minutes.';

  @override
  String get regionsFootnote =>
      'You can only buy in your Steam account\'s region. Rates update daily; amounts are approximate.';

  @override
  String get regionsSame => 'same';

  @override
  String get regionsHome => 'your region';

  @override
  String get regionKz => 'Kazakhstan';

  @override
  String get regionUs => 'United States';

  @override
  String get regionDe => 'Germany (euro)';

  @override
  String get regionTr => 'Turkey';

  @override
  String get regionAr => 'Argentina';

  @override
  String get regionRu => 'Russia';

  @override
  String get regionIn => 'India';

  @override
  String get saleSpring => 'Steam Spring Sale';

  @override
  String get saleSummer => 'Steam Summer Sale';

  @override
  String get saleAutumn => 'Steam Autumn Sale';

  @override
  String get saleWinter => 'Steam Winter Sale';

  @override
  String saleActive(String name, String date) {
    return '$name is on now — until $date';
  }

  @override
  String saleTomorrow(String name) {
    return '$name starts tomorrow';
  }

  @override
  String saleIn(String name, int days, String dates) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return '$name in $_temp0 · $dates';
  }

  @override
  String get filterFree => 'Free';

  @override
  String get genreTitle => 'Genre';

  @override
  String get genreAny => 'All genres';

  @override
  String get genreAction => 'Action';

  @override
  String get genreAdventure => 'Adventure';

  @override
  String get genreRpg => 'RPG';

  @override
  String get genreStrategy => 'Strategy';

  @override
  String get genreSimulation => 'Simulation';

  @override
  String get genreIndie => 'Indie';

  @override
  String get genreCasual => 'Casual';

  @override
  String get genreSports => 'Sports';

  @override
  String get genreRacing => 'Racing';

  @override
  String get genreMmo => 'MMO';

  @override
  String get genreEarlyAccess => 'Early Access';
}
