import 'package:json_annotation/json_annotation.dart';

/// Дата без времени: в JSON `YYYY-MM-DD`, в Dart — полночь UTC.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) {
    final parsed = DateTime.parse(json);
    return DateTime.utc(parsed.year, parsed.month, parsed.day);
  }

  @override
  String toJson(DateTime object) =>
      '${object.year.toString().padLeft(4, '0')}-'
      '${object.month.toString().padLeft(2, '0')}-'
      '${object.day.toString().padLeft(2, '0')}';
}
