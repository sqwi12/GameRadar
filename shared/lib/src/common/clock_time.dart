import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

/// Время суток без даты и часового пояса (для тихих часов).
/// В JSON — строка `HH:mm`.
@immutable
final class ClockTime implements Comparable<ClockTime> {
  const ClockTime(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  /// Разбирает строку `HH:mm` (также принимает `HH:mm:ss` из PostgreSQL `time`).
  factory ClockTime.parse(String value) {
    final match = _pattern.firstMatch(value);
    if (match == null) {
      throw FormatException('Ожидалось время в формате HH:mm', value);
    }
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour > 23 || minute > 59) {
      throw FormatException('Недопустимое время', value);
    }
    return ClockTime(hour, minute);
  }

  static final _pattern = RegExp(r'^(\d{2}):(\d{2})(?::\d{2})?$');

  final int hour;
  final int minute;

  int get minutesOfDay => hour * 60 + minute;

  @override
  int compareTo(ClockTime other) => minutesOfDay.compareTo(other.minutesOfDay);

  bool operator <(ClockTime other) => minutesOfDay < other.minutesOfDay;
  bool operator <=(ClockTime other) => minutesOfDay <= other.minutesOfDay;
  bool operator >(ClockTime other) => minutesOfDay > other.minutesOfDay;
  bool operator >=(ClockTime other) => minutesOfDay >= other.minutesOfDay;

  @override
  bool operator ==(Object other) =>
      other is ClockTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

class ClockTimeConverter implements JsonConverter<ClockTime, String> {
  const ClockTimeConverter();

  @override
  ClockTime fromJson(String json) => ClockTime.parse(json);

  @override
  String toJson(ClockTime object) => object.toString();
}
