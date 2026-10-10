import 'package:freezed_annotation/freezed_annotation.dart';

part 'history.freezed.dart';
part 'history.g.dart';

/// Период для графиков истории.
enum HistoryPeriod {
  @JsonValue('24h')
  day(Duration(hours: 24), '24h'),
  @JsonValue('7d')
  week(Duration(days: 7), '7d'),
  @JsonValue('30d')
  month(Duration(days: 30), '30d');

  const HistoryPeriod(this.duration, this.wireName);

  final Duration duration;

  /// Значение в JSON и query-параметре `period`.
  final String wireName;
}

/// Точка графика онлайна.
@freezed
abstract class PlayerCountPoint with _$PlayerCountPoint {
  const factory PlayerCountPoint({
    required DateTime recordedAt,
    required int players,
  }) = _PlayerCountPoint;

  factory PlayerCountPoint.fromJson(Map<String, Object?> json) =>
      _$PlayerCountPointFromJson(json);
}

/// История онлайна за период, точки по возрастанию времени.
@freezed
abstract class PlayerHistory with _$PlayerHistory {
  const factory PlayerHistory({
    required int appId,
    required HistoryPeriod period,
    required List<PlayerCountPoint> points,
  }) = _PlayerHistory;

  factory PlayerHistory.fromJson(Map<String, Object?> json) =>
      _$PlayerHistoryFromJson(json);
}

/// Запись истории цены: состояние цены начиная с [recordedAt].
@freezed
abstract class PriceHistoryEntry with _$PriceHistoryEntry {
  const factory PriceHistoryEntry({
    required DateTime recordedAt,
    required bool isAvailable,
    String? currency,
    int? initialPrice,
    int? finalPrice,
    @Default(0) int discountPct,
  }) = _PriceHistoryEntry;

  factory PriceHistoryEntry.fromJson(Map<String, Object?> json) =>
      _$PriceHistoryEntryFromJson(json);
}
