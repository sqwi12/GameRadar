-- migrate:up
-- Каталог игр. Список приложений Steam синхронизирует worker (только app_id и name),
-- остальные поля заполняются, когда игру начинают отслеживать или она попадает в топ.
CREATE TABLE games (
  app_id               integer      PRIMARY KEY CHECK (app_id > 0),
  name                 text         NOT NULL,
  type                 text,                         -- game, dlc, demo, ... (из appdetails)
  is_free              boolean      NOT NULL DEFAULT false,
  header_image_url     text,
  -- Краткое описание по языкам: {"ru": "...", "en": "..."}.
  short_description    jsonb        NOT NULL DEFAULT '{}'::jsonb,
  developers           text[]       NOT NULL DEFAULT '{}',
  publishers           text[]       NOT NULL DEFAULT '{}',
  genres               text[]       NOT NULL DEFAULT '{}',
  release_date         date,

  -- Отзывы (обновляются раз в день).
  reviews_positive     integer      CHECK (reviews_positive >= 0),
  reviews_total        integer      CHECK (reviews_total >= 0),

  -- Кэш онлайна. Источник истины — player_counts; пики пересчитывает worker
  -- функцией refresh_player_peaks(), чтобы экраны не агрегировали миллионы строк.
  current_players      integer      CHECK (current_players >= 0),
  peak_24h             integer      CHECK (peak_24h >= 0),
  peak_7d              integer      CHECK (peak_7d >= 0),
  peak_30d             integer      CHECK (peak_30d >= 0),
  -- Место в топ-1000 по онлайну, NULL — игра вне топа.
  top_rank             smallint     CHECK (top_rank BETWEEN 1 AND 1000),

  -- Число записей в watchlist, поддерживается триггером (см. миграцию watchlist).
  -- Используется для приоритета в очереди worker.
  watchers_count       integer      NOT NULL DEFAULT 0 CHECK (watchers_count >= 0),

  -- Когда worker последний раз обновлял данные (NULL — ни разу).
  details_checked_at   timestamptz,                  -- описание, раз в неделю
  reviews_checked_at   timestamptz,                  -- отзывы, раз в день
  players_checked_at   timestamptz,                  -- онлайн: 15–30 мин (топ) / 1–3 ч

  created_at           timestamptz  NOT NULL DEFAULT now(),
  updated_at           timestamptz  NOT NULL DEFAULT now(),

  CHECK (reviews_positive IS NULL OR reviews_total IS NULL OR reviews_positive <= reviews_total)
);

CREATE TRIGGER games_set_updated_at
  BEFORE UPDATE ON games
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Поиск по названию.
CREATE INDEX games_name_trgm_idx ON games USING gin (name gin_trgm_ops);
-- Экран «Топ по онлайну».
CREATE INDEX games_top_rank_idx ON games (top_rank) WHERE top_rank IS NOT NULL;
-- Выбор игр для обновления: сначала с большим числом подписчиков.
CREATE INDEX games_watched_idx ON games (watchers_count DESC) WHERE watchers_count > 0;

-- migrate:down
DROP TABLE IF EXISTS games;
