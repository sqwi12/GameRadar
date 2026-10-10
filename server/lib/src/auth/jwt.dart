import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Минимальная реализация JWT (HS256) для анонимных пользователей.
/// В токене только id пользователя (`sub`) и сроки (`iat`, `exp`).
final class JwtService {
  JwtService({
    required String secret,
    required this.ttl,
    DateTime Function()? now,
  }) : _hmac = Hmac(sha256, utf8.encode(secret)),
       _now = now ?? (() => DateTime.now().toUtc());

  final Hmac _hmac;
  final Duration ttl;
  final DateTime Function() _now;

  static final _header = _encodeJson({'alg': 'HS256', 'typ': 'JWT'});

  /// Выпускает токен для пользователя [userId].
  ({String token, DateTime expiresAt}) issue(String userId) {
    final issuedAt = _now();
    // Срок округляем до секунд: в токене он хранится в секундах.
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      (issuedAt.add(ttl).millisecondsSinceEpoch ~/ 1000) * 1000,
      isUtc: true,
    );
    final payload = _encodeJson({
      'sub': userId,
      'iat': issuedAt.millisecondsSinceEpoch ~/ 1000,
      'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
    });
    final signingInput = '$_header.$payload';
    return (
      token: '$signingInput.${_sign(signingInput)}',
      expiresAt: expiresAt,
    );
  }

  /// Возвращает id пользователя или null, если токен поддельный,
  /// испорчен или истёк.
  String? verify(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final expected = _sign('${parts[0]}.${parts[1]}');
    if (!_constantTimeEquals(expected, parts[2])) return null;
    try {
      final header = _decodeJson(parts[0]);
      if (header['alg'] != 'HS256') return null;
      final payload = _decodeJson(parts[1]);
      final sub = payload['sub'];
      final exp = payload['exp'];
      if (sub is! String || exp is! int) return null;
      if (_now().millisecondsSinceEpoch ~/ 1000 >= exp) return null;
      return sub;
    } on FormatException {
      return null;
    }
  }

  String _sign(String input) =>
      _base64Url(_hmac.convert(utf8.encode(input)).bytes);

  static String _encodeJson(Map<String, Object?> json) =>
      _base64Url(utf8.encode(jsonEncode(json)));

  static Map<String, Object?> _decodeJson(String part) {
    final decoded = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(part))),
    );
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('ожидался JSON-объект');
    }
    return decoded;
  }

  static String _base64Url(List<int> bytes) =>
      base64Url.encode(bytes).replaceAll('=', '');

  /// Сравнение без раннего выхода, чтобы время ответа не выдавало подпись.
  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}

/// SHA-256 от ID устройства (hex). В БД хранится только он.
String hashDeviceId(String deviceId) =>
    sha256.convert(utf8.encode(deviceId)).toString();
