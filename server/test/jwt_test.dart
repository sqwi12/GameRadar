import 'dart:convert';

import 'package:gameradar_server/gameradar_server.dart';
import 'package:test/test.dart';

void main() {
  var now = DateTime.utc(2026, 10, 11, 12);
  final jwt = JwtService(
    secret: 'test-secret-test-secret-test-secret!',
    ttl: const Duration(days: 7),
    now: () => now,
  );

  setUp(() => now = DateTime.utc(2026, 10, 11, 12));

  test('выпуск и проверка токена', () {
    final issued = jwt.issue('user-1');
    expect(issued.expiresAt, DateTime.utc(2026, 10, 18, 12));
    expect(jwt.verify(issued.token), 'user-1');
  });

  test('истёкший токен отклоняется', () {
    final token = jwt.issue('user-1').token;
    now = now.add(const Duration(days: 7));
    expect(jwt.verify(token), isNull);
  });

  test('подделка полезной нагрузки отклоняется', () {
    final parts = jwt.issue('user-1').token.split('.');
    final forged = base64Url
        .encode(utf8.encode('{"sub":"admin","exp":9999999999}'))
        .replaceAll('=', '');
    expect(jwt.verify('${parts[0]}.$forged.${parts[2]}'), isNull);
  });

  test('токен с другим секретом отклоняется', () {
    final other = JwtService(
      secret: 'another-secret-another-secret-12345',
      ttl: const Duration(days: 7),
      now: () => now,
    );
    expect(jwt.verify(other.issue('user-1').token), isNull);
  });

  test('alg: none и мусор отклоняются', () {
    final none = base64Url
        .encode(utf8.encode('{"alg":"none"}'))
        .replaceAll('=', '');
    final payload = jwt.issue('user-1').token.split('.')[1];
    for (final bad in ['', 'a.b', 'a.b.c', '$none.$payload.', '...']) {
      expect(jwt.verify(bad), isNull, reason: bad);
    }
  });

  test('хеш ID устройства: SHA-256 в hex, детерминированный', () {
    final hash = hashDeviceId('0b8a1c9e-5f2d-4a7b-9c3e-1d2f3a4b5c6d');
    expect(hash, matches(RegExp(r'^[0-9a-f]{64}$')));
    expect(hashDeviceId('0b8a1c9e-5f2d-4a7b-9c3e-1d2f3a4b5c6d'), hash);
    expect(hashDeviceId('другое-устройство-12345'), isNot(hash));
  });

  test('ServerConfig: короткий JWT_SECRET не принимается', () {
    expect(
      () => ServerConfig.fromEnvironment({
        'DATABASE_URL': 'postgres://x',
        'JWT_SECRET': 'short',
      }),
      throwsStateError,
    );
  });
}
