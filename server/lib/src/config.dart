import 'package:gameradar_shared/dotenv.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

/// Настройки сервера из переменных окружения (или `.env` при запуске без Docker).
/// Ключ Steam серверу не нужен: в Steam ходит только worker.
final class ServerConfig {
  const ServerConfig({
    required this.databaseUrl,
    required this.jwtSecret,
    this.defaultRegion = Regions.defaultRegion,
    this.tokenTtl = const Duration(days: 7),
    this.maxWatchlistSize = 200,
  });

  factory ServerConfig.fromEnvironment([Map<String, String>? env]) {
    final e = env ?? loadEnvironment();
    String required(String name) {
      final value = e[name];
      if (value == null || value.isEmpty) {
        throw StateError('Не задана переменная окружения $name');
      }
      return value;
    }

    final secret = required('JWT_SECRET');
    if (secret.length < 32) {
      throw StateError('JWT_SECRET должен быть не короче 32 символов');
    }
    final region = e['DEFAULT_REGION'] ?? Regions.defaultRegion;
    if (!Regions.isValid(region)) {
      throw StateError('DEFAULT_REGION: ожидался код из двух строчных букв');
    }
    return ServerConfig(
      databaseUrl: required('DATABASE_URL'),
      jwtSecret: secret,
      defaultRegion: region,
    );
  }

  final String databaseUrl;

  /// Секрет подписи JWT. Не логируется.
  final String jwtSecret;
  final String defaultRegion;

  /// Срок жизни токена. По истечении приложение заново входит по ID устройства.
  final Duration tokenTtl;

  /// Максимум игр в списке отслеживания одного пользователя: защита
  /// лимита запросов к Steam от одного аккаунта.
  final int maxWatchlistSize;
}
