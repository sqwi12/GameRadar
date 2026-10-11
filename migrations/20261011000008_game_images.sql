-- migrate:up
-- Обложки игр (header 460×215). Скачивает их только worker — через ту же
-- очередь и лимит запросов, что и всё остальное (правило 2), а сервер отдаёт
-- их по своему адресу. Так приложение не обращается к доменам Steam даже
-- за картинками (правило 1).
CREATE TABLE game_images (
  app_id        integer      PRIMARY KEY REFERENCES games (app_id) ON DELETE CASCADE,
  -- Адрес в Steam, с которого скачано: если в описании игры он сменился
  -- (Steam меняет параметр ?t=), worker скачает обложку заново.
  source_url    text         NOT NULL,
  content_type  text         NOT NULL CHECK (content_type IN ('image/jpeg', 'image/png', 'image/webp')),
  content       bytea        NOT NULL CHECK (octet_length(content) BETWEEN 1 AND 1048576),
  -- Короткий хеш содержимого: ETag и версия в URL для кэша приложения.
  etag          text         NOT NULL,
  fetched_at    timestamptz  NOT NULL DEFAULT now()
);

-- migrate:down
DROP TABLE IF EXISTS game_images;
