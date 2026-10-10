import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated.freezed.dart';
part 'paginated.g.dart';

/// Страница списка с пагинацией по offset/limit.
@Freezed(genericArgumentFactories: true)
abstract class Paginated<T> with _$Paginated<T> {
  const Paginated._();

  const factory Paginated({
    required List<T> items,
    required int offset,
    required int limit,

    /// Общее число элементов, если сервер его посчитал.
    int? total,
  }) = _Paginated<T>;

  factory Paginated.fromJson(
    Map<String, Object?> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedFromJson(json, fromJsonT);

  /// Есть ли следующая страница.
  bool get hasMore =>
      total != null ? offset + items.length < total! : items.length == limit;
}
