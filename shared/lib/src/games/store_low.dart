import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_low.freezed.dart';
part 'store_low.g.dart';

/// Самая низкая цена игры в Steam за всю историю (по данным IsThereAnyDeal,
/// история цен с 2013 года). Суммы — в минимальных единицах валюты.
@freezed
abstract class StoreLow with _$StoreLow {
  const factory StoreLow({
    required int price,
    required int regularPrice,

    /// Скидка в тот момент, %.
    required int cut,
    required String currency,

    /// Когда цена была такой.
    required DateTime at,
  }) = _StoreLow;

  factory StoreLow.fromJson(Map<String, Object?> json) =>
      _$StoreLowFromJson(json);
}
