import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../../../core/network/api_call.dart';

/// Экран игры: GET /games/{appId}, история онлайна и история цены.
class GameRepository {
  GameRepository(this._dio);

  final Dio _dio;

  /// Открытие экрана заодно сообщает серверу, что игру смотрят:
  /// worker сутки будет обновлять её цену и онлайн.
  Future<GameDetails> details(int appId, String region) => apiCall(() async {
    final response = await _dio.get<Object?>(
      '/games/$appId',
      queryParameters: {'region': region},
    );
    return GameDetails.fromJson(asJsonMap(response.data));
  });

  Future<PlayerHistory> playerHistory(int appId, HistoryPeriod period) =>
      apiCall(() async {
        final response = await _dio.get<Object?>(
          '/games/$appId/players',
          queryParameters: {'period': period.wireName},
        );
        return PlayerHistory.fromJson(asJsonMap(response.data));
      });

  /// Цены в регионах Steam и они же в тенге.
  Future<List<RegionalPrice>> regionalPrices(int appId) => apiCall(() async {
    final response = await _dio.get<Object?>('/games/$appId/regions');
    return [
      for (final e in response.data! as List)
        RegionalPrice.fromJson(e as Map<String, Object?>),
    ];
  });

  /// Изменения цены по возрастанию времени (сервер хранит только изменения).
  Future<List<PriceHistoryEntry>> priceHistory(int appId, String region) =>
      apiCall(() async {
        final response = await _dio.get<Object?>(
          '/games/$appId/prices',
          queryParameters: {'region': region},
        );
        return [
          for (final e in response.data! as List)
            PriceHistoryEntry.fromJson(e as Map<String, Object?>),
        ];
      });
}
