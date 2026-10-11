import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/date_only.dart';
import 'game_price.dart';
import 'player_stats.dart';
import 'review_summary.dart';
import 'store_low.dart';

part 'game_details.freezed.dart';
part 'game_details.g.dart';

/// Тип приложения в магазине.
@JsonEnum(fieldRename: FieldRename.snake)
enum GameType { game, dlc, demo, music, video, mod, unknown }

/// Полные данные для экрана игры.
@freezed
abstract class GameDetails with _$GameDetails {
  const GameDetails._();

  const factory GameDetails({
    required int appId,
    required String name,
    @JsonKey(unknownEnumValue: GameType.unknown)
    @Default(GameType.unknown)
    GameType type,
    @Default(false) bool isFree,
    String? headerImageUrl,

    /// Краткое описание по языкам: `{"ru": "...", "en": "..."}`.
    @Default(<String, String>{}) Map<String, String> shortDescription,
    @Default(<String>[]) List<String> developers,
    @Default(<String>[]) List<String> publishers,
    @Default(<String>[]) List<String> genres,
    @DateOnlyConverter() DateTime? releaseDate,
    ReviewSummary? reviews,
    @Default(PlayerStats()) PlayerStats players,

    /// Цена в регионе запроса; null — цена ещё не загружалась.
    GamePrice? price,

    /// Исторический минимум в Steam в регионе запроса (IsThereAnyDeal);
    /// null — неизвестен (нет ключа API, игры нет в ITAD или не загружен).
    StoreLow? storeLow,
    int? topRank,

    /// Когда worker последний раз обновлял описание.
    DateTime? detailsCheckedAt,
  }) = _GameDetails;

  factory GameDetails.fromJson(Map<String, Object?> json) =>
      _$GameDetailsFromJson(json);

  /// Описание на нужном языке с откатом на английский, затем на любой доступный.
  String? descriptionFor(String languageCode) =>
      shortDescription[languageCode] ??
      shortDescription['en'] ??
      (shortDescription.isEmpty ? null : shortDescription.values.first);

  /// Страница игры в магазине — открывается во внешнем браузере.
  Uri get storeUrl => Uri.https('store.steampowered.com', '/app/$appId');
}
