-- migrate:up
-- Текущие цены по регионам. Все суммы — в минимальных единицах валюты
-- (как в price_overview Steam: 249900 для KZT = 2 499,00 ₸).
CREATE TABLE game_prices (
  app_id          integer      NOT NULL REFERENCES games (app_id) ON DELETE CASCADE,
  region          char(2)      NOT NULL DEFAULT 'kz' CHECK (region ~ '^[a-z]{2}$'),
  -- false — в регионе нет price_overview (игра бесплатна или не продаётся).
  is_available    boolean      NOT NULL DEFAULT true,
  currency        char(3)      CHECK (currency ~ '^[A-Z]{3}$'),
  initial_price   bigint       CHECK (initial_price >= 0),
  final_price     bigint       CHECK (final_price >= 0),
  discount_pct    smallint     NOT NULL DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100),
  checked_at      timestamptz  NOT NULL DEFAULT now(),   -- последний запрос к Steam
  changed_at      timestamptz  NOT NULL DEFAULT now(),   -- последнее изменение цены
  PRIMARY KEY (app_id, region),
  CHECK (NOT is_available OR (currency IS NOT NULL AND initial_price IS NOT NULL AND final_price IS NOT NULL))
);

-- Экран «Скидки сейчас».
CREATE INDEX game_prices_discounts_idx
  ON game_prices (region, discount_pct DESC, final_price)
  WHERE discount_pct > 0;
-- Выбор цен, которые пора обновить.
CREATE INDEX game_prices_checked_at_idx ON game_prices (region, checked_at);

-- История цен: пишутся ТОЛЬКО изменения. Это гарантируют триггеры ниже,
-- поэтому worker просто делает upsert в game_prices на каждой проверке.
CREATE TABLE price_history (
  id              bigint       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  app_id          integer      NOT NULL,
  region          char(2)      NOT NULL,
  is_available    boolean      NOT NULL,
  currency        char(3),
  initial_price   bigint,
  final_price     bigint,
  discount_pct    smallint     NOT NULL,
  recorded_at     timestamptz  NOT NULL DEFAULT now(),
  FOREIGN KEY (app_id, region) REFERENCES game_prices (app_id, region) ON DELETE CASCADE
);

CREATE INDEX price_history_lookup_idx ON price_history (app_id, region, recorded_at DESC);

-- Обновляет changed_at, только если изменилась сама цена (а не только checked_at).
CREATE FUNCTION game_prices_touch_changed_at() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF (NEW.is_available, NEW.currency, NEW.initial_price, NEW.final_price, NEW.discount_pct)
     IS DISTINCT FROM
     (OLD.is_available, OLD.currency, OLD.initial_price, OLD.final_price, OLD.discount_pct) THEN
    NEW.changed_at := now();
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER game_prices_changed_at
  BEFORE UPDATE ON game_prices
  FOR EACH ROW EXECUTE FUNCTION game_prices_touch_changed_at();

CREATE FUNCTION game_prices_write_history() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO price_history
    (app_id, region, is_available, currency, initial_price, final_price, discount_pct, recorded_at)
  VALUES
    (NEW.app_id, NEW.region, NEW.is_available, NEW.currency,
     NEW.initial_price, NEW.final_price, NEW.discount_pct, NEW.changed_at);
  RETURN NULL;
END;
$$;

-- Первая цена всегда попадает в историю.
CREATE TRIGGER game_prices_history_insert
  AFTER INSERT ON game_prices
  FOR EACH ROW EXECUTE FUNCTION game_prices_write_history();

-- Последующие — только при фактическом изменении.
CREATE TRIGGER game_prices_history_update
  AFTER UPDATE ON game_prices
  FOR EACH ROW
  WHEN ((NEW.is_available, NEW.currency, NEW.initial_price, NEW.final_price, NEW.discount_pct)
        IS DISTINCT FROM
        (OLD.is_available, OLD.currency, OLD.initial_price, OLD.final_price, OLD.discount_pct))
  EXECUTE FUNCTION game_prices_write_history();

-- migrate:down
DROP TABLE IF EXISTS price_history;
DROP TABLE IF EXISTS game_prices;
DROP FUNCTION IF EXISTS game_prices_write_history();
DROP FUNCTION IF EXISTS game_prices_touch_changed_at();
