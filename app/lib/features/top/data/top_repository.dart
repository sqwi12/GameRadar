import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../../../core/cache/codecs.dart';
import '../../../core/network/api_call.dart';

/// «Топ по онлайну»: GET /games/top.
class TopRepository {
  TopRepository(this._dio);

  final Dio _dio;

  Future<Paginated<GameSummary>> fetch(TopQuery query) => apiCall(() async {
    final response = await _dio.get<Object?>(
      '/games/top',
      queryParameters: query.toQueryParameters(),
    );
    return decodeGamePage(response.data);
  });
}
