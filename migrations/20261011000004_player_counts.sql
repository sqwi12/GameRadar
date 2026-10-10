-- migrate:up
-- Точки онлайна из ISteamUserStats/GetNumberOfCurrentPlayers/v1.
-- Свежие точки хранятся как есть (каждые 15 мин – 3 ч), точки старше 30 дней
-- сжимаются функцией compact_player_counts() до максимума за час.
CREATE TABLE player_counts (
  app_id       integer      NOT NULL REFERENCES games (app_id) ON DELETE CASCADE,
  recorded_at  timestamptz  NOT NULL,
  players      integer      NOT NULL CHECK (players >= 0),
  PRIMARY KEY (app_id, recorded_at)
);

-- Сжатие: все точки старше older_than, кроме выровненных по началу часа,
-- сворачиваются в одну точку на час (recorded_at = начало часа, players = максимум).
-- Идемпотентна: повторный запуск ничего не меняет. Возвращает число удалённых сырых точек.
-- Worker вызывает её раз в сутки.
CREATE FUNCTION compact_player_counts(older_than interval DEFAULT interval '30 days')
RETURNS bigint
LANGUAGE plpgsql AS $$
DECLARE
  cutoff  timestamptz := now() - older_than;
  removed bigint;
BEGIN
  WITH removed_rows AS (
    DELETE FROM player_counts
    WHERE recorded_at < cutoff
      AND recorded_at <> date_trunc('hour', recorded_at)
    RETURNING app_id, date_trunc('hour', recorded_at) AS hour, players
  ), hourly AS (
    INSERT INTO player_counts (app_id, recorded_at, players)
    SELECT app_id, hour, max(players) FROM removed_rows GROUP BY app_id, hour
    ON CONFLICT (app_id, recorded_at)
      DO UPDATE SET players = GREATEST(player_counts.players, EXCLUDED.players)
  )
  SELECT count(*) INTO removed FROM removed_rows;
  RETURN removed;
END;
$$;

-- Пересчёт кэша пиков в games по данным player_counts.
-- Вызывается worker'ом после записи пачки онлайна.
CREATE FUNCTION refresh_player_peaks(app_ids integer[])
RETURNS void
LANGUAGE sql AS $$
  UPDATE games g
  SET peak_24h = p.peak_24h,
      peak_7d  = p.peak_7d,
      peak_30d = p.peak_30d
  FROM (
    SELECT app_id,
           max(players) FILTER (WHERE recorded_at >= now() - interval '24 hours') AS peak_24h,
           max(players) FILTER (WHERE recorded_at >= now() - interval '7 days')   AS peak_7d,
           max(players)                                                           AS peak_30d
    FROM player_counts
    WHERE app_id = ANY (app_ids)
      AND recorded_at >= now() - interval '30 days'
    GROUP BY app_id
  ) p
  WHERE g.app_id = p.app_id;
$$;

-- migrate:down
DROP FUNCTION IF EXISTS refresh_player_peaks(integer[]);
DROP FUNCTION IF EXISTS compact_player_counts(interval);
DROP TABLE IF EXISTS player_counts;
