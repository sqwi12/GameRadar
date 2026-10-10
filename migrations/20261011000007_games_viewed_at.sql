-- migrate:up
-- Когда игру последний раз открывали в приложении (например, из поиска).
-- Сервер ставит отметку при запросе экрана игры, worker в течение суток
-- обновляет такие игры наравне с отслеживаемыми: иначе у игры, которую
-- ещё никто не отслеживает, не было бы ни цены, ни онлайна, и пользователь
-- не смог бы выбрать порог. Сервер к Steam при этом не обращается.
ALTER TABLE games ADD COLUMN viewed_at timestamptz;

CREATE INDEX games_viewed_at_idx ON games (viewed_at) WHERE viewed_at IS NOT NULL;

-- migrate:down
DROP INDEX IF EXISTS games_viewed_at_idx;
ALTER TABLE games DROP COLUMN IF EXISTS viewed_at;
