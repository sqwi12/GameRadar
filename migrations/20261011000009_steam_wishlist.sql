-- migrate:up
-- Привязка профиля Steam для импорта списка желаемого. Входа через Steam нет:
-- пользователь вводит ссылку на профиль или ник, а worker читает открытый
-- список желаемого через свою очередь запросов (правило 2).
CREATE TABLE steam_links (
  user_id                  uuid         PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE,
  profile_input            text         NOT NULL CHECK (length(profile_input) BETWEEN 1 AND 200),
  steam_id                 text         CHECK (steam_id ~ '^7656119[0-9]{10}$'),
  persona_name             text,
  status                   text         NOT NULL DEFAULT 'pending'
                                        CHECK (status IN ('pending', 'ok', 'private_profile', 'not_found')),
  -- Порог скидки, с которым игры из списка желаемого попадают в отслеживаемые.
  import_min_discount_pct  smallint     NOT NULL DEFAULT 25 CHECK (import_min_discount_pct BETWEEN 1 AND 100),
  wishlist_count           integer      CHECK (wishlist_count >= 0),
  imported_count           integer      CHECK (imported_count >= 0),
  -- Последняя синхронизация (раз в сутки).
  synced_at                timestamptz,
  created_at               timestamptz  NOT NULL DEFAULT now(),
  updated_at               timestamptz  NOT NULL DEFAULT now()
);

CREATE TRIGGER steam_links_set_updated_at
  BEFORE UPDATE ON steam_links
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Откуда игра в списке отслеживания. Импортированные (wishlist) синхронизируются
-- со Steam: исчезла из списка желаемого — уходит и отсюда. Как только
-- пользователь меняет пороги, запись становится ручной (manual) и больше
-- синхронизацией не трогается.
ALTER TABLE watchlist
  ADD COLUMN source text NOT NULL DEFAULT 'manual' CHECK (source IN ('manual', 'wishlist'));

-- migrate:down
ALTER TABLE watchlist DROP COLUMN IF EXISTS source;
DROP TABLE IF EXISTS steam_links;
