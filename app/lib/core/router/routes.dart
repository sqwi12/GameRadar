/// Пути экранов.
abstract final class Routes {
  static const top = '/top';
  static const discounts = '/discounts';
  static const search = '/search';
  static const watchlist = '/watchlist';
  static const settings = '/settings';

  static String game(int appId) => '/game/$appId';
}
