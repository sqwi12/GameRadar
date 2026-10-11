import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:timezone/timezone.dart' as tz;

/// Состояние одной подписки в момент проверки цены.
typedef WatchState = ({
  int? targetPrice,
  int? minDiscountPct,
  int? lastNotifiedPrice,
  bool notificationsEnabled,
  QuietHours? quietHours,
  String timezone,
});

/// Что делать с подпиской после проверки цены.
sealed class NotificationDecision {
  const NotificationDecision();
}

/// Отправить уведомление о цене [price] и запомнить её в last_notified_price.
final class NotifyNow extends NotificationDecision {
  const NotifyNow(this.price);

  final int price;

  @override
  bool operator ==(Object other) => other is NotifyNow && other.price == price;

  @override
  int get hashCode => price.hashCode;

  @override
  String toString() => 'NotifyNow($price)';
}

/// Условие выполнено, но сейчас тихие часы: проверить снова в [until] (UTC).
final class DeferUntil extends NotificationDecision {
  const DeferUntil(this.until);

  final DateTime until;

  @override
  bool operator ==(Object other) => other is DeferUntil && other.until == until;

  @override
  int get hashCode => until.hashCode;

  @override
  String toString() => 'DeferUntil($until)';
}

/// Условие перестало выполняться: сбросить last_notified_price,
/// чтобы о следующем снижении цены снова уведомить.
final class ResetNotified extends NotificationDecision {
  const ResetNotified();

  @override
  bool operator ==(Object other) => other is ResetNotified;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'ResetNotified';
}

/// Ничего не делать.
final class SkipNotification extends NotificationDecision {
  const SkipNotification(this.reason);

  final SkipReason reason;

  @override
  bool operator ==(Object other) =>
      other is SkipNotification && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  @override
  String toString() => 'SkipNotification(${reason.name})';
}

enum SkipReason {
  /// Пороги не выполнены (или не заданы).
  thresholdsNotMet,

  /// Об этой или более низкой цене уже уведомляли.
  alreadyNotified,

  /// Пользователь выключил уведомления.
  disabled,
}

/// Правило 11: уведомлять, когда цена не выше target_price или скидка
/// не меньше min_discount_pct; не повторять уведомление о той же цене;
/// учитывать тихие часы пользователя.
///
/// Повторное уведомление уходит, только если цена опустилась ниже
/// last_notified_price. Рост цены при выполненном условии (например,
/// скидка 75% сменилась на 60% при пороге 50%) нового уведомления не даёт.
NotificationDecision decideNotification({
  required WatchState watch,
  required GamePrice? price,
  required DateTime nowUtc,
}) {
  final met = thresholdsMet(
    price: price,
    targetPrice: watch.targetPrice,
    minDiscountPct: watch.minDiscountPct,
  );
  if (!met) {
    return watch.lastNotifiedPrice != null
        ? const ResetNotified()
        : const SkipNotification(SkipReason.thresholdsNotMet);
  }

  final finalPrice = price!.finalPrice!;
  final last = watch.lastNotifiedPrice;
  if (last != null && finalPrice >= last) {
    return const SkipNotification(SkipReason.alreadyNotified);
  }
  if (!watch.notificationsEnabled) {
    return const SkipNotification(SkipReason.disabled);
  }

  final quiet = watch.quietHours;
  if (quiet != null) {
    final location = resolveLocation(watch.timezone);
    final local = tz.TZDateTime.from(nowUtc, location);
    if (quiet.contains(ClockTime(local.hour, local.minute))) {
      return DeferUntil(quietHoursEnd(quiet, local));
    }
  }
  return NotifyNow(finalPrice);
}

/// Откуда известно, что цена рекордная.
enum RecordLowKind {
  /// Не выше минимума за всю историю Steam (IsThereAnyDeal).
  allTime,

  /// Ниже нашего минимума за время отслеживания (без данных ITAD).
  tracked,
}

/// Цена и известные минимумы для проверки «рекордно низкая ли цена».
typedef RecordLowInput = ({
  int finalPrice,
  int discountPct,
  String currency,

  /// Минимум за всю историю (ITAD) и его валюта.
  int? allTimeLow,
  String? allTimeLowCurrency,

  /// Наш минимум до текущего изменения цены и начало отслеживания.
  int? trackedLow,
  DateTime? trackedSince,
});

/// Своей истории должно быть не меньше, иначе любое первое снижение
/// оказалось бы «рекордом».
const minTrackedHistory = Duration(days: 30);

/// Рекордно ли низкая цена. Только со скидкой: у игры, которая никогда
/// не дешевела, обычная цена совпадает с минимумом, но это не новость.
/// - есть минимум ITAD в той же валюте — цена не выше него;
/// - иначе — ниже нашего минимума, если отслеживаем дольше 30 дней.
/// null — не рекорд.
({RecordLowKind kind, int? trackedDays})? recordLowOf(
  RecordLowInput input, {
  required DateTime nowUtc,
}) {
  if (input.discountPct <= 0) return null;
  final allTime = input.allTimeLow;
  if (allTime != null && input.allTimeLowCurrency == input.currency) {
    return input.finalPrice <= allTime
        ? (kind: RecordLowKind.allTime, trackedDays: null)
        : null;
  }
  final tracked = input.trackedLow;
  final since = input.trackedSince;
  if (tracked == null || since == null) return null;
  final age = nowUtc.difference(since);
  if (age < minTrackedHistory || input.finalPrice >= tracked) return null;
  return (kind: RecordLowKind.tracked, trackedDays: age.inDays);
}

/// Идут ли сейчас тихие часы пользователя.
bool inQuietHours(QuietHours? quiet, String timezone, DateTime nowUtc) {
  if (quiet == null) return false;
  final local = tz.TZDateTime.from(nowUtc, resolveLocation(timezone));
  return quiet.contains(ClockTime(local.hour, local.minute));
}

/// Ближайший конец тихих часов после локального момента [local], в UTC.
DateTime quietHoursEnd(QuietHours quiet, tz.TZDateTime local) {
  var end = tz.TZDateTime(
    local.location,
    local.year,
    local.month,
    local.day,
    quiet.end.hour,
    quiet.end.minute,
  );
  if (!end.isAfter(local)) {
    // Конструктор нормализует 32-е число и переход на летнее время сам.
    end = tz.TZDateTime(
      local.location,
      local.year,
      local.month,
      local.day + 1,
      quiet.end.hour,
      quiet.end.minute,
    );
  }
  return DateTime.fromMillisecondsSinceEpoch(
    end.millisecondsSinceEpoch,
    isUtc: true,
  );
}

/// Часовой пояс пользователя; неизвестный — пояс по умолчанию.
tz.Location resolveLocation(String name) {
  try {
    return tz.getLocation(name);
  } on tz.LocationNotFoundException {
    return tz.getLocation(UserSettings.defaultTimezone);
  }
}
