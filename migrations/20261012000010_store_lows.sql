-- migrate:up

-- Исторический минимум цены в Steam по данным IsThereAnyDeal: их история
-- цен идёт с 2013 года, а Steam такой истории не отдаёт. Обновляет worker
-- раз в сутки для топа, отслеживаемых и недавно открытых игр.
CREATE TABLE game_store_lows (
  app_id         integer      NOT NULL REFERENCES games (app_id) ON DELETE CASCADE,
  region         char(2)      NOT NULL CHECK (region ~ '^[a-z]{2}$'),
  -- ID игры в IsThereAnyDeal; NULL — ITAD эту игру не знает.
  itad_id        uuid,
  currency       char(3)      CHECK (currency ~ '^[A-Z]{3}$'),
  low_price      bigint       CHECK (low_price >= 0),
  regular_price  bigint       CHECK (regular_price >= 0),
  cut            smallint     CHECK (cut BETWEEN 0 AND 100),
  low_at         timestamptz,
  checked_at     timestamptz  NOT NULL DEFAULT now(),
  PRIMARY KEY (app_id, region),
  CHECK (low_price IS NULL OR (currency IS NOT NULL AND regular_price IS NOT NULL
                               AND cut IS NOT NULL AND low_at IS NOT NULL))
);

-- migrate:down

DROP TABLE game_store_lows;
