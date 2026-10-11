/// Настройки сборки. Задаются через `--dart-define`, например:
/// `flutter run --dart-define=API_BASE_URL=https://api.example.com`.
abstract final class AppConfig {
  /// Адрес нашего API. По умолчанию — сервер на компьютере разработчика,
  /// как его видит эмулятор Android (10.0.2.2 = localhost хоста).
  /// Приложение обращается только к нему и никогда к Steam напрямую.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '0.1.1',
  );

  /// Pull-to-refresh не чаще этого интервала (правило 10).
  static const manualRefreshInterval = Duration(minutes: 1);
}
