-- migrate:up

-- Время последнего запуска периодических работ worker'а (синхронизация
-- списка игр, чарт, сжатие…), когда worker работает без Redis: на хостинге
-- без постоянного диска отметки должны переживать перезапуск.
CREATE TABLE worker_markers (
  name      text         PRIMARY KEY,
  last_run  timestamptz  NOT NULL
);

-- Точки онлайна старше older_than сворачиваются до максимума за сутки (UTC).
-- Часовые точки нужны графику «30 дн», для «Всё» хватает суточных:
-- так история не раздувает базу (бесплатные базы — около 500 МБ).
CREATE FUNCTION compact_player_counts_daily(older_than interval DEFAULT interval '60 days')
RETURNS bigint
LANGUAGE plpgsql AS $$
DECLARE
  cutoff  timestamptz := date_trunc('day', now() - older_than, 'UTC');
  removed bigint;
BEGIN
  WITH removed_rows AS (
    DELETE FROM player_counts
    WHERE recorded_at < cutoff
      AND recorded_at <> date_trunc('day', recorded_at, 'UTC')
    RETURNING app_id, date_trunc('day', recorded_at, 'UTC') AS day, players
  ), daily AS (
    INSERT INTO player_counts (app_id, recorded_at, players)
    SELECT app_id, day, max(players) FROM removed_rows GROUP BY app_id, day
    ON CONFLICT (app_id, recorded_at)
      DO UPDATE SET players = GREATEST(player_counts.players, EXCLUDED.players)
  )
  SELECT count(*) INTO removed FROM removed_rows;
  RETURN removed;
END;
$$;

-- migrate:down
DROP FUNCTION IF EXISTS compact_player_counts_daily(interval);
DROP TABLE IF EXISTS worker_markers;
