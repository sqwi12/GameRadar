-- migrate:up

-- Уведомления о рекордно низкой цене: настройка пользователя (по умолчанию
-- включено) и отметка, о какой цене уже уведомили, чтобы не повторяться.
ALTER TABLE users ADD COLUMN notify_record_low boolean NOT NULL DEFAULT true;
ALTER TABLE watchlist ADD COLUMN record_low_notified_price bigint
  CHECK (record_low_notified_price >= 0);

-- migrate:down

ALTER TABLE watchlist DROP COLUMN record_low_notified_price;
ALTER TABLE users DROP COLUMN notify_record_low;
