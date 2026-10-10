-- migrate:up
-- Расширения и общие вспомогательные функции.

-- Триграммный индекс для поиска игр по названию (ILIKE '%...%' и similarity()).
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Автоматическое обновление updated_at при любом UPDATE строки.
CREATE FUNCTION set_updated_at() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

-- migrate:down
DROP FUNCTION IF EXISTS set_updated_at();
DROP EXTENSION IF EXISTS pg_trgm;
