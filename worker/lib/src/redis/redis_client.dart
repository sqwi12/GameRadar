import 'dart:async';

import 'package:logging/logging.dart';
import 'package:redis/redis.dart';

/// Тонкая обёртка над пакетом redis: подключение по URL,
/// переподключение после обрыва и вызов Lua-скриптов.
final class RedisClient {
  RedisClient._(this._uri);

  /// `redis://[:password@]host[:port][/db]`
  static Future<RedisClient> connect(String url) async {
    final client = RedisClient._(Uri.parse(url));
    await client._ensureConnected();
    return client;
  }

  static final _log = Logger('Redis');

  final Uri _uri;
  RedisConnection? _connection;
  Command? _command;
  Future<Command>? _connecting;

  Future<Command> _ensureConnected() {
    if (_command case final command?) return Future.value(command);
    return _connecting ??= _open().whenComplete(() => _connecting = null);
  }

  Future<Command> _open() async {
    final connection = RedisConnection();
    final command = await connection.connect(
      _uri.host.isEmpty ? 'localhost' : _uri.host,
      _uri.hasPort ? _uri.port : 6379,
    );
    final password = _uri.userInfo.contains(':')
        ? Uri.decodeComponent(_uri.userInfo.split(':').last)
        : null;
    if (password != null && password.isNotEmpty) {
      await command.send_object(['AUTH', password]);
    }
    final db = _uri.pathSegments.isEmpty
        ? null
        : int.tryParse(_uri.pathSegments.first);
    if (db != null && db != 0) await command.send_object(['SELECT', '$db']);
    _connection = connection;
    _command = command;
    _log.info(
      'Подключено к Redis ${_uri.host}:${_uri.hasPort ? _uri.port : 6379}',
    );
    return command;
  }

  /// Выполняет команду. После сетевой ошибки соединение сбрасывается,
  /// и следующая команда подключится заново; сама ошибка пробрасывается.
  Future<Object?> command(List<Object> args) async {
    final command = await _ensureConnected();
    try {
      return await command.send_object(args.map((a) => a.toString()).toList());
    } on RedisError {
      rethrow; // Ошибка самой команды: соединение исправно.
    } catch (_) {
      await _reset();
      rethrow;
    }
  }

  /// `EVAL script numkeys keys... args...`
  Future<Object?> eval(String script, List<String> keys, List<Object> args) =>
      command(['EVAL', script, keys.length, ...keys, ...args]);

  Future<void> _reset() async {
    final connection = _connection;
    _connection = null;
    _command = null;
    try {
      await connection?.close();
    } catch (_) {}
  }

  Future<void> close() => _reset();
}

/// Ответ Redis как целое число.
int redisInt(Object? value) => switch (value) {
  final int v => v,
  final String v => int.parse(v),
  _ => throw StateError('Ожидалось целое из Redis, получено $value'),
};
