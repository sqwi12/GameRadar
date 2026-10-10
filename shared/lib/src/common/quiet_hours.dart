import 'package:freezed_annotation/freezed_annotation.dart';

import 'clock_time.dart';

part 'quiet_hours.freezed.dart';
part 'quiet_hours.g.dart';

/// Тихие часы в локальном времени пользователя: `[start, end)`.
/// Интервал может переходить через полночь, например 23:00–08:00.
/// Если start == end, тихие часы не действуют.
@freezed
abstract class QuietHours with _$QuietHours {
  const QuietHours._();

  const factory QuietHours({
    @ClockTimeConverter() required ClockTime start,
    @ClockTimeConverter() required ClockTime end,
  }) = _QuietHours;

  factory QuietHours.fromJson(Map<String, Object?> json) =>
      _$QuietHoursFromJson(json);

  /// Попадает ли локальное время [time] в тихие часы.
  bool contains(ClockTime time) {
    if (start == end) return false;
    if (start < end) return time >= start && time < end;
    // Через полночь: 23:00–08:00 = [23:00, 24:00) ∪ [00:00, 08:00).
    return time >= start || time < end;
  }
}
