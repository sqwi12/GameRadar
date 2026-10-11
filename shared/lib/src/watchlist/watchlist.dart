import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/api_error.dart';
import '../common/validation.dart';
import '../games/game_price.dart';
import '../games/game_summary.dart';

part 'watchlist.freezed.dart';
part 'watchlist.g.dart';

/// Выполнены ли пороги отслеживания для цены [price].
///
/// Достаточно любого условия: цена не выше [targetPrice] или скидка
/// не меньше [minDiscountPct]. Если оба порога null — уведомлений нет.
/// Дедупликацию по last_notified_price и тихие часы учитывает worker.
bool thresholdsMet({
  required GamePrice? price,
  required int? targetPrice,
  required int? minDiscountPct,
}) {
  if (price == null || !price.isAvailable) return false;
  final finalPrice = price.finalPrice;
  if (targetPrice != null && finalPrice != null && finalPrice <= targetPrice) {
    return true;
  }
  return minDiscountPct != null && price.discountPct >= minDiscountPct;
}

/// Ограничения списка отслеживания.
abstract final class WatchlistLimits {
  /// Максимум игр у пользователя (вместе с импортом из Steam): защита
  /// лимита запросов к Steam от одного аккаунта.
  static const maxItems = 200;
}

/// Откуда игра в списке отслеживания.
@JsonEnum()
enum WatchSource {
  /// Добавлена вручную (или пороги менялись вручную).
  manual,

  /// Импортирована из списка желаемого Steam и синхронизируется с ним.
  wishlist,
}

/// PUT /watchlist/{appId} — добавить игру или изменить пороги.
@freezed
abstract class WatchlistUpsertRequest with _$WatchlistUpsertRequest {
  const WatchlistUpsertRequest._();

  const factory WatchlistUpsertRequest({
    /// Уведомить, когда цена станет не выше этой (минимальные единицы валюты).
    int? targetPrice,

    /// Уведомить, когда скидка станет не меньше этой, %.
    int? minDiscountPct,
  }) = _WatchlistUpsertRequest;

  factory WatchlistUpsertRequest.fromJson(Map<String, Object?> json) =>
      _$WatchlistUpsertRequestFromJson(json);

  List<FieldError> validate() {
    final v = Validator()
      ..range('target_price', targetPrice, min: 0)
      ..range('min_discount_pct', minDiscountPct, min: 1, max: 100);
    return v.errors;
  }
}

/// Игра в списке отслеживания пользователя.
@freezed
abstract class WatchlistItem with _$WatchlistItem {
  const WatchlistItem._();

  const factory WatchlistItem({
    required GameSummary game,
    required String region,
    int? targetPrice,
    int? minDiscountPct,

    /// Цена, о которой уже отправлено уведомление.
    int? lastNotifiedPrice,
    DateTime? lastNotifiedAt,
    required DateTime createdAt,
    @Default(WatchSource.manual) WatchSource source,
  }) = _WatchlistItem;

  factory WatchlistItem.fromJson(Map<String, Object?> json) =>
      _$WatchlistItemFromJson(json);

  /// Заданы ли пороги для уведомлений.
  bool get hasThresholds => targetPrice != null || minDiscountPct != null;

  /// Выполнены ли пороги для текущей цены (для бейджа «Цель достигнута»).
  bool get isTargetReached => thresholdsMet(
    price: game.price,
    targetPrice: targetPrice,
    minDiscountPct: minDiscountPct,
  );
}
