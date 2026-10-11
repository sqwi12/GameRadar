import 'package:freezed_annotation/freezed_annotation.dart';

part 'steam_models.freezed.dart';

// Модели ответов Steam. Используются только worker'ом: приложение
// никогда не обращается к Steam и эту библиотеку не импортирует.
// JSON-сериализации нет: ответы Steam разбираются вручную в steam_parsers.dart,
// потому что их формат нерегулярен (например, `data: []` вместо объекта).

/// Ответ Steam не соответствует ожидаемому формату.
/// Считается временной ошибкой: задача будет повторена.
final class SteamFormatException implements Exception {
  SteamFormatException(this.message);

  final String message;

  @override
  String toString() => 'SteamFormatException: $message';
}

/// Цена игры из `appdetails?filters=price_overview`.
@freezed
abstract class SteamPriceOverview with _$SteamPriceOverview {
  const SteamPriceOverview._();

  const factory SteamPriceOverview({
    required int appId,

    /// false — Steam не знает игру или она не продаётся в регионе.
    required bool success,

    /// null — цены нет (бесплатная игра, ещё не вышла и т.п.).
    String? currency,
    int? initialPrice,
    int? finalPrice,
    @Default(0) int discountPct,
  }) = _SteamPriceOverview;

  /// Есть ли у игры цена в регионе.
  bool get hasPrice => success && currency != null && finalPrice != null;
}

/// Полные данные игры из `appdetails` (без фильтра).
@freezed
abstract class SteamAppDetails with _$SteamAppDetails {
  const factory SteamAppDetails({
    required int appId,
    required String name,
    required String type,
    @Default(false) bool isFree,
    String? shortDescription,
    String? headerImageUrl,
    @Default(<String>[]) List<String> developers,
    @Default(<String>[]) List<String> publishers,
    @Default(<String>[]) List<String> genres,

    /// null — дата не указана, не распознана или игра ещё не вышла.
    DateTime? releaseDate,
    @Default(false) bool comingSoon,
  }) = _SteamAppDetails;
}

/// Сводка отзывов из `appreviews`.
@freezed
abstract class SteamReviewSummary with _$SteamReviewSummary {
  const factory SteamReviewSummary({
    required int totalPositive,
    required int totalReviews,
  }) = _SteamReviewSummary;
}

/// Элемент списка приложений из `IStoreService/GetAppList`.
@freezed
abstract class SteamAppListEntry with _$SteamAppListEntry {
  const factory SteamAppListEntry({required int appId, required String name}) =
      _SteamAppListEntry;
}

/// Страница списка приложений.
@freezed
abstract class SteamAppListPage with _$SteamAppListPage {
  const factory SteamAppListPage({
    required List<SteamAppListEntry> apps,
    required bool haveMoreResults,

    /// Передаётся в следующий запрос как `last_appid`.
    int? lastAppId,
  }) = _SteamAppListPage;
}

/// Профиль Steam из `GetPlayerSummaries`.
@freezed
abstract class SteamPlayerSummary with _$SteamPlayerSummary {
  const factory SteamPlayerSummary({
    required String steamId,
    String? personaName,

    /// Профиль открыт (иначе список желаемого не прочитать).
    required bool isPublic,
  }) = _SteamPlayerSummary;
}

/// Строка чарта `ISteamChartsService/GetGamesByConcurrentPlayers` (топ-100).
@freezed
abstract class SteamChartEntry with _$SteamChartEntry {
  const factory SteamChartEntry({
    required int rank,
    required int appId,
    required int concurrentInGame,
    int? peakInGame,
  }) = _SteamChartEntry;
}
