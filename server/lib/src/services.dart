import 'package:postgres/postgres.dart';

import 'auth/jwt.dart';
import 'config.dart';
import 'db/devices_repository.dart';
import 'db/games_queries.dart';
import 'db/users_repository.dart';
import 'db/watchlist_repository.dart';

/// Зависимости обработчиков. Создаётся один раз при старте сервера
/// и передаётся в маршруты через middleware.
final class Services {
  Services({required this.config, required Pool<void> db, JwtService? jwt})
    : _db = db,
      jwt = jwt ?? JwtService(secret: config.jwtSecret, ttl: config.tokenTtl),
      users = UsersRepository(db),
      games = GamesQueries(db),
      watchlist = WatchlistRepository(db),
      devices = DevicesRepository(db);

  factory Services.fromConfig(ServerConfig config) =>
      Services(config: config, db: Pool<void>.withUrl(config.databaseUrl));

  final ServerConfig config;
  final Pool<void> _db;
  final JwtService jwt;
  final UsersRepository users;
  final GamesQueries games;
  final WatchlistRepository watchlist;
  final DevicesRepository devices;

  Future<void> close() => _db.close();
}

/// Зависимости процесса сервера. Задаются в main.dart (init) при старте.
late Services appServices;

/// Пользователь, прошедший проверку токена.
final class AuthUser {
  const AuthUser(this.id);

  final String id;
}
