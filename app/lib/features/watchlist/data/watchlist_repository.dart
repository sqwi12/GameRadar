import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../../../core/network/api_call.dart';

/// Список отслеживания: /watchlist.
class WatchlistRepository {
  WatchlistRepository(this._dio);

  final Dio _dio;

  Future<List<WatchlistItem>> list() => apiCall(() async {
    final response = await _dio.get<List<Object?>>('/watchlist');
    return [
      for (final item in response.data!)
        WatchlistItem.fromJson(item! as Map<String, Object?>),
    ];
  });

  /// Добавить игру или изменить пороги.
  Future<WatchlistItem> upsert(int appId, WatchlistUpsertRequest request) =>
      apiCall(() async {
        final response = await _dio.put<Object?>(
          '/watchlist/$appId',
          data: request.toJson(),
        );
        return WatchlistItem.fromJson(asJsonMap(response.data));
      });

  Future<void> remove(int appId) =>
      apiCall(() => _dio.delete<Object?>('/watchlist/$appId'));
}
