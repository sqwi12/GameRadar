import 'package:gameradar_shared/gameradar_shared.dart';

// JSON-кодеки моделей для кэша (CachedResource хранит JSON из shared toJson).

Paginated<GameSummary> decodeGamePage(Object? json) => Paginated.fromJson(
  json! as Map<String, Object?>,
  (item) => GameSummary.fromJson(item! as Map<String, Object?>),
);

Object? encodeGamePage(Paginated<GameSummary> page) =>
    page.toJson((g) => g.toJson());
