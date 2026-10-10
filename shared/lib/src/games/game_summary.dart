import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_price.dart';

part 'game_summary.freezed.dart';
part 'game_summary.g.dart';

/// Краткая карточка игры для списков: поиск, топ, скидки, отслеживаемые.
@freezed
abstract class GameSummary with _$GameSummary {
  const factory GameSummary({
    required int appId,
    required String name,
    String? headerImageUrl,

    /// Цена в регионе запроса; null — цена ещё не загружалась.
    GamePrice? price,
    int? currentPlayers,
    @JsonKey(name: 'peak_24h') int? peak24h,

    /// Место в топ-1000 по онлайну.
    int? topRank,
  }) = _GameSummary;

  factory GameSummary.fromJson(Map<String, Object?> json) =>
      _$GameSummaryFromJson(json);
}
