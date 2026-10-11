import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_price.dart';

part 'regional_price.freezed.dart';
part 'regional_price.g.dart';

/// Цена игры в одном регионе Steam и она же в тенге по курсу НБК.
@freezed
abstract class RegionalPrice with _$RegionalPrice {
  const factory RegionalPrice({
    required GamePrice price,

    /// Итоговая цена в тенге (минимальные единицы); null — нет курса.
    int? finalPriceKzt,
  }) = _RegionalPrice;

  factory RegionalPrice.fromJson(Map<String, Object?> json) =>
      _$RegionalPriceFromJson(json);
}
