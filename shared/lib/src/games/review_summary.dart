import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_summary.freezed.dart';
part 'review_summary.g.dart';

/// Сводка отзывов пользователей магазина.
@freezed
abstract class ReviewSummary with _$ReviewSummary {
  const ReviewSummary._();

  const factory ReviewSummary({required int positive, required int total}) =
      _ReviewSummary;

  factory ReviewSummary.fromJson(Map<String, Object?> json) =>
      _$ReviewSummaryFromJson(json);

  /// Доля положительных отзывов в процентах (0–100), null — отзывов нет.
  int? get positivePct => total == 0 ? null : (positive * 100 / total).round();
}
