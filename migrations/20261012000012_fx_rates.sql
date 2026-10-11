-- migrate:up

-- Официальные курсы Национального банка Казахстана: сколько тенге стоит
-- одна единица валюты. Нужны, чтобы сравнивать цены Steam в разных
-- регионах в тенге. Обновляет worker раз в сутки.
CREATE TABLE fx_rates (
  currency      char(3)        PRIMARY KEY CHECK (currency ~ '^[A-Z]{3}$'),
  kzt_per_unit  numeric(18, 6) NOT NULL CHECK (kzt_per_unit > 0),
  rate_date     date           NOT NULL,
  updated_at    timestamptz    NOT NULL DEFAULT now()
);

-- migrate:down

DROP TABLE fx_rates;
