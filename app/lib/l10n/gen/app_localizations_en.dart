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
}
