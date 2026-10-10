import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_stats.freezed.dart';
part 'player_stats.g.dart';

/// Онлайн игры: текущее значение и пики, посчитанные по нашей истории.
/// null — данных ещё нет (worker не успел опросить игру).
@freezed
abstract class PlayerStats with _$PlayerStats {
  const factory PlayerStats({
    int? current,
    @JsonKey(name: 'peak_24h') int? peak24h,
    @JsonKey(name: 'peak_7d') int? peak7d,
    @JsonKey(name: 'peak_30d') int? peak30d,

    /// Время последнего замера онлайна.
    DateTime? checkedAt,
  }) = _PlayerStats;

  factory PlayerStats.fromJson(Map<String, Object?> json) =>
      _$PlayerStatsFromJson(json);
}
