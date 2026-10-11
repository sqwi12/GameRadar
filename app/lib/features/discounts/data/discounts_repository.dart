import 'package:dio/dio.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import '../../../core/cache/codecs.dart';
import '../../../core/network/api_call.dart';

/// «Скидки сейчас»: GET /games/discounts.
class DiscountsRepository {
  DiscountsRepository(this._dio);

  final Dio _dio;

  Future<Paginated<GameSummary>> fetch(DiscountsQuery query) =>
      apiCall(() async {
        final response = await _dio.get<Object?>(
          '/games/discounts',
          queryParameters: query.toQueryParameters(),
        );
        return decodeGamePage(response.data);
      });
}
