import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../../../core/cache/codecs.dart';
import '../../../core/network/api_call.dart';

/// Поиск по 190+ тыс. игр в нашей базе: GET /games/search.
class SearchRepository {
  SearchRepository(this._dio);

  final Dio _dio;

  Future<List<GameSummary>> search(
    SearchQuery query, {
    CancelToken? cancelToken,
  }) => apiCall(() async {
    final response = await _dio.get<Object?>(
      '/games/search',
      queryParameters: query.toQueryParameters(),
      cancelToken: cancelToken,
    );
    return decodeGamePage(response.data).items;
  });
}
