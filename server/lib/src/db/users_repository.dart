import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:postgres/postgres.dart';

/// Анонимные пользователи и их настройки.
final class UsersRepository {
  UsersRepository(this._db);

  final Pool<void> _db;

  static const _columns = '''
    id::text, locale, region::text, timezone, notifications_enabled,
    to_char(quiet_hours_start, 'HH24:MI'), to_char(quiet_hours_end, 'HH24:MI'),
    created_at, notify_record_low''';

  static UserProfile _read(ResultRow r) {
    final start = r[5] as String?;
    final end = r[6] as String?;
    return UserProfile(
      id: r[0]! as String,
      settings: UserSettings(
        locale: AppLocale.values.byName(r[1]! as String),
        region: (r[2]! as String).trim(),
        timezone: r[3]! as String,
        notificationsEnabled: r[4]! as bool,
        notifyRecordLow: r[8]! as bool,
        quietHours: start != null && end != null
            ? QuietHours(
                start: ClockTime.parse(start),
                end: ClockTime.parse(end),
              )
            : null,
      ),
      createdAt: r[7]! as DateTime,
    );
  }

  static Map<String, Object?> _settingsParams(UserSettings s) => {
    'locale': s.locale.name,
    'region': s.region,
    'timezone': s.timezone,
    'notifications': s.notificationsEnabled,
    'record_low': s.notifyRecordLow,
    'quiet_start': s.quietHours?.start.toString(),
    'quiet_end': s.quietHours?.end.toString(),
  };

  /// Вход по хешу ID устройства: создаёт пользователя с [initial]
  /// настройками или возвращает существующего (его настройки не меняются).
  Future<UserProfile> signIn(String deviceIdHash, UserSettings initial) async {
    final rows = await _db.execute(
      Sql.named('''
        INSERT INTO users (device_id_hash, locale, region, timezone, notifications_enabled,
                           notify_record_low, quiet_hours_start, quiet_hours_end)
        VALUES (@hash:text, @locale:text, @region:text, @timezone:text, @notifications:boolean,
                @record_low:boolean,
                CAST(@quiet_start:text AS time), CAST(@quiet_end:text AS time))
        ON CONFLICT (device_id_hash) DO UPDATE SET last_seen_at = now()
        RETURNING $_columns
      '''),
      parameters: {'hash': deviceIdHash, ..._settingsParams(initial)},
    );
    return _read(rows.first);
  }

  Future<UserProfile?> find(String userId) async {
    final rows = await _db.execute(
      Sql.named(
        'SELECT $_columns FROM users WHERE id = CAST(@id:text AS uuid)',
      ),
      parameters: {'id': userId},
    );
    return rows.isEmpty ? null : _read(rows.first);
  }

  /// Полностью заменяет настройки. null — пользователя нет.
  Future<UserProfile?> updateSettings(
    String userId,
    UserSettings settings,
  ) async {
    final rows = await _db.execute(
      Sql.named('''
        UPDATE users SET
          locale = @locale:text,
          region = @region:text,
          timezone = @timezone:text,
          notifications_enabled = @notifications:boolean,
          notify_record_low = @record_low:boolean,
          quiet_hours_start = CAST(@quiet_start:text AS time),
          quiet_hours_end = CAST(@quiet_end:text AS time)
        WHERE id = CAST(@id:text AS uuid)
        RETURNING $_columns
      '''),
      parameters: {'id': userId, ..._settingsParams(settings)},
    );
    return rows.isEmpty ? null : _read(rows.first);
  }

  /// Знает ли PostgreSQL такой часовой пояс IANA.
  Future<bool> timezoneExists(String name) async {
    final rows = await _db.execute(
      Sql.named(
        'SELECT EXISTS (SELECT 1 FROM pg_timezone_names WHERE name = @tz:text)',
      ),
      parameters: {'tz': name},
    );
    return rows.first[0]! as bool;
  }
}
