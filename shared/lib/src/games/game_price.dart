import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_price.freezed.dart';
part 'game_price.g.dart';

/// Текущая цена игры в регионе. Суммы — в минимальных единицах валюты
/// (см. `minorUnitsPerMajor`).
@freezed
abstract class GamePrice with _$GamePrice {
  const GamePrice._();

  const factory GamePrice({
    required String region,

    /// false — в регионе нет цены: игра бесплатна или не продаётся.
    required bool isAvailable,

    /// ISO 4217, например `KZT`.
    String? currency,
    int? initialPrice,
    int? finalPrice,
    @Default(0) int discountPct,

    /// Когда worker последний раз проверял цену.
    required DateTime checkedAt,

    /// Когда цена последний раз менялась.
    required DateTime changedAt,
  }) = _GamePrice;

  factory GamePrice.fromJson(Map<String, Object?> json) =>
      _$GamePriceFromJson(json);

  bool get isDiscounted => isAvailable && discountPct > 0;
}
