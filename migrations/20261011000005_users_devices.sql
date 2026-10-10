-- migrate:up
-- Анонимные пользователи. Сервер хранит не сам ID устройства, а его SHA-256 (hex),
-- и выдаёт приложению JWT, подписанный секретом сервера.
CREATE TABLE users (
  id                     uuid         PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id_hash         text         NOT NULL UNIQUE CHECK (device_id_hash ~ '^[0-9a-f]{64}$'),
  locale                 text         NOT NULL DEFAULT 'ru' CHECK (locale IN ('ru', 'en')),
  region                 char(2)      NOT NULL DEFAULT 'kz' CHECK (region ~ '^[a-z]{2}$'),
  -- Часовой пояс IANA для расчёта тихих часов.
  timezone               text         NOT NULL DEFAULT 'Asia/Almaty',
  notifications_enabled  boolean      NOT NULL DEFAULT true,
  -- Тихие часы в локальном времени пользователя. Интервал может переходить
  -- через полночь (23:00–08:00). Оба NULL — тихих часов нет.
  quiet_hours_start      time,
  quiet_hours_end        time,
  created_at             timestamptz  NOT NULL DEFAULT now(),
  updated_at             timestamptz  NOT NULL DEFAULT now(),
  last_seen_at           timestamptz  NOT NULL DEFAULT now(),
  CHECK ((quiet_hours_start IS NULL) = (quiet_hours_end IS NULL))
);

CREATE TRIGGER users_set_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- FCM-токены устройств пользователя.
CREATE TABLE devices (
  id          bigint       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id     uuid         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  -- Токен уникален глобально: при переустановке приложения он переходит к новому пользователю.
  fcm_token   text         NOT NULL UNIQUE,
  platform    text         NOT NULL CHECK (platform IN ('android', 'ios')),
  created_at  timestamptz  NOT NULL DEFAULT now(),
  updated_at  timestamptz  NOT NULL DEFAULT now()
);

CREATE INDEX devices_user_id_idx ON devices (user_id);

CREATE TRIGGER devices_set_updated_at
  BEFORE UPDATE ON devices
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- migrate:down
DROP TABLE IF EXISTS devices;
DROP TABLE IF EXISTS users;
