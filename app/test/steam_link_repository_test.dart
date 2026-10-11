import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/core/network/app_exception.dart';
import 'package:gameradar_app/features/settings/data/steam_link_repository.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import 'support/fakes.dart';

void main() {
  SteamLinkRepository repository(FakeAdapter adapter) => SteamLinkRepository(
    Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter,
  );

  test('404 — профиль не привязан, а не ошибка', () async {
    final adapter = FakeAdapter(
      (_) async => jsonBody({'code': 'not_found', 'message': 'нет'}, 404),
    );
    expect(await repository(adapter).fetch(), isNull);
    // Повторная отвязка тоже не ошибка.
    await repository(adapter).unlink();
  });

  test('привязка: запрос и статус ответа', () async {
    final adapter = FakeAdapter(
      (options) async => jsonBody({
        'profile_input': 'tester',
        'status': 'private_profile',
        'import_min_discount_pct': 50,
      }),
    );
    final link = await repository(
      adapter,
    ).save(const SteamLinkRequest(profile: 'tester', importMinDiscountPct: 50));
    expect(link.status, SteamLinkStatus.privateProfile);
    final request = adapter.requests.single;
    expect((request.method, request.path), ('PUT', '/me/steam'));
    expect(request.data, {'profile': 'tester', 'import_min_discount_pct': 50});
  });

  test('другие ошибки сервера пробрасываются', () async {
    final adapter = FakeAdapter(
      (_) async => jsonBody({'code': 'internal_error', 'message': 'x'}, 500),
    );
    expect(
      repository(adapter).fetch(),
      throwsA(isA<ApiFailure>().having((e) => e.statusCode, 'status', 500)),
    );
  });
}
