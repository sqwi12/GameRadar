-- migrate:up
-- Отслеживаемые игры. Условия уведомления (достаточно любого):
--   final_price <= target_price  или  discount_pct >= min_discount_pct.
-- Оба порога NULL — игра просто в списке, без уведомлений.
CREATE TABLE watchlist (
  user_id              uuid         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  app_id               integer      NOT NULL REFERENCES games (app_id) ON DELETE CASCADE,
  -- Регион фиксируется при добавлении, чтобы last_notified_price не смешивал валюты.
  region               char(2)      NOT NULL DEFAULT 'kz' CHECK (region ~ '^[a-z]{2}$'),
  target_price         bigint       CHECK (target_price >= 0),
  min_discount_pct     smallint     CHECK (min_discount_pct BETWEEN 1 AND 100),
  -- Цена, о которой уже уведомили. О той же цене повторно не уведомляем;
  -- сбрасывается в NULL, когда условие перестаёт выполняться.
  last_notified_price  bigint       CHECK (last_notified_price >= 0),
  last_notified_at     timestamptz,
  created_at           timestamptz  NOT NULL DEFAULT now(),
  updated_at           timestamptz  NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, app_id)
);

-- Worker после обновления цены ищет подписчиков игры.
CREATE INDEX watchlist_app_region_idx ON watchlist (app_id, region);

CREATE TRIGGER watchlist_set_updated_at
  BEFORE UPDATE ON watchlist
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Поддержка games.watchers_count.
CREATE FUNCTION watchlist_sync_watchers_count() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP IN ('INSERT', 'UPDATE') THEN
    UPDATE games SET watchers_count = watchers_count + 1 WHERE app_id = NEW.app_id;
  END IF;
  IF TG_OP IN ('DELETE', 'UPDATE') THEN
    UPDATE games SET watchers_count = watchers_count - 1 WHERE app_id = OLD.app_id;
  END IF;
  RETURN NULL;
END;
$$;

CREATE TRIGGER watchlist_watchers_count_ins_del
  AFTER INSERT OR DELETE ON watchlist
  FOR EACH ROW EXECUTE FUNCTION watchlist_sync_watchers_count();

CREATE TRIGGER watchlist_watchers_count_upd
  AFTER UPDATE OF app_id ON watchlist
  FOR EACH ROW WHEN (OLD.app_id IS DISTINCT FROM NEW.app_id)
  EXECUTE FUNCTION watchlist_sync_watchers_count();

-- migrate:down
DROP TABLE IF EXISTS watchlist;
DROP FUNCTION IF EXISTS watchlist_sync_watchers_count();
