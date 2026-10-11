import 'package:gameradar_shared/gameradar_shared.dart';

import 'package:gameradar_shared/dotenv.dart';

/// Частоты обновления данных (правило 6). Нижняя граница — когда задачу
/// можно ставить в очередь, верхняя — желаемый крайний срок: очередь
/// выбирает задачи по ближайшему сроку, поэтому при нехватке лимита
/// запросов интервалы плавно растягиваются от нижней границы к верхней.
final class RefreshWindow {
  const RefreshWindow(this.min, this.max);

  final Duration min;
  final Duration max;
}

final class Schedule {
  const Schedule({
    this.prices = const RefreshWindow(Duration(hours: 2), Duration(hours: 6)),
    this.pricesDuringSale = const RefreshWindow(
      Duration(minutes: 45),
      Duration(hours: 1),
    ),
    // 30 минут, а не 15: при лимите 1 запрос в 1,5 с (2400 в час) онлайн
    // топ-1000 раз в 15 минут потребовал бы 4000 запросов в час.
    this.topPlayers = const RefreshWindow(
      Duration(minutes: 25),
      Duration(minutes: 30),
    ),
    this.otherPlayers = const RefreshWindow(
      Duration(hours: 1),
      Duration(hours: 3),
    ),
    this.reviews = const RefreshWindow(
      Duration(hours: 20),
      Duration(hours: 24),
    ),
    this.details = const RefreshWindow(Duration(days: 6), Duration(days: 7)),
    this.appList = const Duration(hours: 24),
    this.topChart = const Duration(minutes: 30),
    this.compaction = const Duration(hours: 24),
  });

  final RefreshWindow prices;
  final RefreshWindow pricesDuringSale;
  final RefreshWindow topPlayers;
  final RefreshWindow otherPlayers;
  final RefreshWindow reviews;
  final RefreshWindow details;
  final Duration appList;
  final Duration topChart;
  final Duration compaction;
}

/// Настройки worker из переменных окружения.
final class WorkerConfig {
  const WorkerConfig({
    required this.databaseUrl,
    required this.redisUrl,
    required this.steamApiKey,
    this.region = Regions.defaultRegion,
    this.saleMode = false,
    this.requestInterval = const Duration(milliseconds: 1500),
    this.topSize = 1000,
    this.schedule = const Schedule(),
    this.fcmProjectId,
    this.fcmServiceAccountFile,
    this.itadApiKey,
  });

  factory WorkerConfig.fromEnvironment([Map<String, String>? env]) {
    final e = env ?? loadEnvironment();
    String required(String name) {
      final value = e[name];
      if (value == null || value.isEmpty) {
        throw StateError('Не задана переменная окружения $name');
      }
      return value;
    }

    final region = e['DEFAULT_REGION'] ?? Regions.defaultRegion;
    if (!Regions.isValid(region)) {
      throw StateError('DEFAULT_REGION: ожидался код из двух строчных букв');
    }
    return WorkerConfig(
      databaseUrl: required('DATABASE_URL'),
      redisUrl: required('REDIS_URL'),
      steamApiKey: required('STEAM_API_KEY'),
      region: region,
      saleMode: e['SALE_MODE'] == 'true',
      fcmProjectId: _nonEmpty(e['FCM_PROJECT_ID']),
      fcmServiceAccountFile: _nonEmpty(e['FCM_SERVICE_ACCOUNT_FILE']),
      itadApiKey: _nonEmpty(e['ITAD_API_KEY']),
    );
  }

  final String databaseUrl;
  final String redisUrl;

  /// Ключ Steam Web API. Только из окружения, никогда не логируется.
  final String steamApiKey;

  /// Регион цен (параметр `cc`).
  final String region;

  /// Распродажа: цены обновляются раз в час.
  final bool saleMode;

  /// Минимальный интервал между запросами к одному хосту Steam.
  final Duration requestInterval;
  final int topSize;
  final Schedule schedule;

  /// Проект Firebase и путь к JSON-ключу сервисного аккаунта.
  /// Без них уведомления только пишутся в журнал (LoggingNotifier).
  final String? fcmProjectId;
  final String? fcmServiceAccountFile;

  /// Ключ IsThereAnyDeal API для исторических минимумов цен. Без него
  /// минимумы не загружаются. Только из окружения, не логируется.
  final String? itadApiKey;

  bool get fcmConfigured =>
      fcmProjectId != null && fcmServiceAccountFile != null;

  static String? _nonEmpty(String? v) =>
      v == null || v.trim().isEmpty ? null : v.trim();

  RefreshWindow get priceWindow =>
      saleMode ? schedule.pricesDuringSale : schedule.prices;
}
