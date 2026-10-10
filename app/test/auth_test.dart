import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/core/network/app_exception.dart';
import 'package:gameradar_app/core/network/auth_interceptor.dart';
import 'package:gameradar_app/core/storage/secure_store.dart';
import 'package:gameradar_app/features/auth/data/session_manager.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

import 'support/fakes.dart';

void main() {
  late MemorySecureStore store;
  late DateTime now;
  late int signIns;
  late FakeAdapter authAdapter;

  SessionManager session() => SessionManager(
    authDio: fakeDio(authAdapter),
    store: store,
    initialSettings: () async => const UserSettings(),
    now: () => now,
  );

  setUp(() {
    store = MemorySecureStore();
    now = DateTime.utc(2026, 10, 11, 12);
    signIns = 0;
    authAdapter = FakeAdapter((options) async {
      signIns++;
      return jsonBody(
        authResponse('token-$signIns', now.add(const Duration(days: 7))),
      );
    });
  });

  group('SessionManager', () {
    test('ID устройства создаётся один раз и отправляется при входе', () async {
      final s = session();
      final id = await s.deviceId();
      expect(id, matches(RegExp(r'^[0-9a-f-]{36}$')));
      expect(await session().deviceId(), id);

      await s.validToken();
      final body = authAdapter.requests.single.data as Map<String, Object?>;
      expect(body['device_id'], id);
      expect(body['initial_settings'], isA<Map<String, Object?>>());
    });

    test(
      'токен сохраняется и переиспользуется, в том числе после перезапуска',
      () async {
        expect(await session().validToken(), 'token-1');
        expect(await session().validToken(), 'token-1');
        expect(signIns, 1);
      },
    );

    test('за сутки до истечения токен обновляется', () async {
      final s = session();
      await s.validToken();
      now = now.add(const Duration(days: 6, hours: 1));
      expect(await s.validToken(), 'token-2');
    });

    test('параллельные запросы токена — один вход', () async {
      final gate = Completer<void>();
      authAdapter = FakeAdapter((_) async {
        await gate.future;
        signIns++;
        return jsonBody(
          authResponse('token-$signIns', now.add(const Duration(days: 7))),
        );
      });
      final s = session();
      final tokens = Future.wait([
        s.validToken(),
        s.validToken(),
        s.validToken(),
      ]);
      gate.complete();
      expect(await tokens, ['token-1', 'token-1', 'token-1']);
      expect(signIns, 1);
    });

    test('нет сети при входе — NetworkException', () async {
      authAdapter = FakeAdapter(
        (o) async => throw DioException.connectionError(
          requestOptions: o,
          reason: 'offline',
        ),
      );
      await expectLater(
        session().validToken(),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('AuthInterceptor', () {
    late FakeAdapter apiAdapter;
    late Dio api;

    setUp(() {
      api = Dio(BaseOptions(baseUrl: 'http://api.test'));
      api.interceptors.add(AuthInterceptor(session: session(), dio: api));
    });

    test('добавляет токен к запросам', () async {
      apiAdapter = FakeAdapter((_) async => jsonBody({'ok': true}));
      api.httpClientAdapter = apiAdapter;
      await api.get<Object?>('/me');
      expect(apiAdapter.authHeaders.single, 'Bearer token-1');
    });

    test('на 401 входит заново и повторяет запрос один раз', () async {
      apiAdapter = FakeAdapter((o) async {
        final auth = o.headers['Authorization'];
        return auth == 'Bearer token-1'
            ? jsonBody({'code': 'unauthorized'}, 401)
            : jsonBody({'ok': true});
      });
      api.httpClientAdapter = apiAdapter;
      final response = await api.get<Map<String, Object?>>('/me');
      expect(response.data, {'ok': true});
      expect(signIns, 2);
      expect(apiAdapter.authHeaders, ['Bearer token-1', 'Bearer token-2']);
    });

    test('повторный 401 не зацикливается', () async {
      apiAdapter = FakeAdapter(
        (_) async => jsonBody({'code': 'unauthorized'}, 401),
      );
      api.httpClientAdapter = apiAdapter;
      await expectLater(api.get<Object?>('/me'), throwsA(isA<DioException>()));
      expect(apiAdapter.requests, hasLength(2));
    });
  });

  group('AppException.from', () {
    final options = RequestOptions(path: '/x');

    test('сеть, таймаут — NetworkException', () {
      expect(
        AppException.from(
          DioException.connectionError(requestOptions: options, reason: 'x'),
        ),
        isA<NetworkException>(),
      );
      expect(
        AppException.from(
          DioException.receiveTimeout(
            timeout: Duration.zero,
            requestOptions: options,
          ),
        ),
        isA<NetworkException>(),
      );
    });

    test('ответ сервера с ApiError', () {
      final error = AppException.from(
        DioException.badResponse(
          statusCode: 409,
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 409,
            data: {'code': 'limit_exceeded'},
          ),
        ),
      );
      expect(error, isA<ApiFailure>());
      expect((error as ApiFailure).code, ApiErrorCode.limitExceeded);
    });

    test('ошибка входа внутри DioException не теряется', () {
      expect(
        AppException.from(
          DioException(
            requestOptions: options,
            error: const NetworkException(),
          ),
        ),
        isA<NetworkException>(),
      );
    });
  });
}
