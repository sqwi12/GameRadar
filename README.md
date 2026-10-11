# GameRadar

Приложение для отслеживания скидок и онлайна игр из магазина Steam: цены по региону (по умолчанию Казахстан, KZT), история цен, онлайн и его пики, push-уведомления о скидках.

> GameRadar не связан с Valve Corporation. Steam — товарный знак Valve Corporation.

## Структура монорепо

```
GameRadar/
├── app/             Flutter-приложение (Riverpod, go_router, dio, drift)
├── shared/          Общие модели freezed + json_serializable
├── server/          REST API на Dart Frog
├── worker/          Фоновый процесс: единственный клиент Steam, очередь, уведомления
├── migrations/      SQL-миграции PostgreSQL (формат dbmate)
├── docker-compose.yml
├── .env.example
└── pubspec.yaml     Корень pub workspace
```

Все Dart-пакеты объединены в [pub workspace](https://dart.dev/tools/pub/workspaces): одна команда `flutter pub get` в корне ставит зависимости для всех пакетов, `pubspec.lock` общий.

## Архитектура

```
 Приложение ──HTTP──▶ server (Dart Frog) ──▶ PostgreSQL ◀── worker ──▶ Steam
                                         └─▶ Redis ◀───────┘   └──▶ FCM HTTP v1
```

- Приложение обращается **только** к нашему API, никогда к Steam напрямую.
- Ключ Steam Web API хранится только в переменных окружения сервера и worker.
- Worker — единственный, кто ходит в Steam: все запросы идут через очередь в Redis с лимитом 1 запрос в 1,5 с на хост. На 429/403 задача возвращается в очередь с паузой 1 → 2 → 4 → 8 минут.
- Цены запрашиваются пакетами по 50 appid (`appdetails?filters=price_overview&cc=kz`). Обновляются только отслеживаемые игры и топ-1000 по онлайну, в первую очередь игры с большим числом подписчиков.

| Данные | Частота |
|---|---|
| Цены | раз в 2–6 ч, в распродажу раз в час (`SALE_MODE=true`) |
| Онлайн топ-1000 | раз в 25–30 мин (15 мин не помещается в лимит запросов) |
| Онлайн остальных | раз в 1–3 ч |
| Отзывы | раз в день |
| Описания | раз в неделю |
| Список желаемого Steam (импорт) | раз в сутки |

## База данных

| Таблица | Назначение |
|---|---|
| `games` | Каталог игр; кэш онлайна, пиков, места в топе и числа подписчиков |
| `game_prices` | Текущая цена по паре `app_id` + `region` |
| `price_history` | Только изменения цены |
| `player_counts` | Точки онлайна; старше 30 дней сжимаются до максимума за час |
| `users` | Анонимные пользователи (SHA-256 от ID устройства), язык, регион, тихие часы |
| `devices` | FCM-токены |
| `watchlist` | Отслеживание: `target_price`, `min_discount_pct`, `last_notified_price`, `source` (`manual` / `wishlist`) |
| `steam_links` | Привязка профиля Steam для импорта списка желаемого: ввод пользователя, SteamID, статус, порог скидки |

Цены хранятся в минимальных единицах валюты (`bigint`): 249900 для KZT означает 2 499,00 ₸.

Часть правил реализована прямо в БД:

- **История только изменений.** Триггеры на `game_prices` пишут в `price_history` первую цену и каждое фактическое изменение. Обновление одного `checked_at` историю не трогает, поэтому worker просто делает upsert.
- **`games.watchers_count`** поддерживается триггером на `watchlist` и задаёт приоритет в очереди.
- **`compact_player_counts(interval)`** сворачивает точки старше 30 дней в максимум за час. Функция идемпотентна, worker вызывает её раз в сутки.
- **`refresh_player_peaks(int[])`** пересчитывает пики за 24 ч, 7 и 30 дней из `player_counts` в кэш `games`.

## Быстрый старт

### Без Docker (локальный PostgreSQL и Memurai/Redis)

```bash
cp .env.example .env                      # заполните DATABASE_URL, JWT_SECRET, STEAM_API_KEY
flutter pub get                           # зависимости всех пакетов workspace
cd worker && dart run tool/migrate.dart   # применить миграции
dart run bin/worker.dart                  # worker: собирает данные из Steam
cd ../server && dart_frog dev             # API на http://localhost:8080
```

Проверить связь со Steam без БД и Redis: `cd worker && dart run tool/steam_smoke.dart`.

### В Docker

```bash
cp .env.example .env
docker compose up -d                          # PostgreSQL :5433, Redis :6379 и миграции
docker compose --profile full up -d --build   # плюс server и worker
```

### Миграции

Файлы в `migrations/` в формате [dbmate](https://github.com/amacneil/dbmate): секции `-- migrate:up` и `-- migrate:down`. Без Docker их применяет `worker/tool/migrate.dart`, в Docker — контейнер `migrate`. Оба используют одну таблицу `schema_migrations`, поэтому их можно чередовать.

PostgreSQL в Docker слушает на хосте порт **5433**, чтобы не конфликтовать с локально установленным сервером.

## APK для Android

Готовый APK лежит на странице [Releases](https://github.com/sqwi12/GameRadar/releases).

**Важно:** приложение ходит только на наш сервер, а не в Steam. APK версии 0.1.0 собран под сервер на компьютере разработчика в домашней сети (`http://192.168.1.177:8080`). Поэтому он работает, только если:

- телефон подключён к той же Wi‑Fi сети, что и компьютер;
- на компьютере запущены сервер и worker (см. «Быстрый старт»);
- в брандмауэре Windows разрешены входящие подключения на порт 8080;
- адрес компьютера в сети не поменялся. Его стоит закрепить в настройках роутера (резервирование DHCP).

Установка: скачать `GameRadar-0.1.0.apk` на телефон, открыть и разрешить установку из этого источника. Контрольная сумма SHA-256 — в файле `.sha256` рядом с APK.

Сборка под другой адрес сервера:

```
cd app
flutter build apk --release --dart-define=API_BASE_URL=http://<адрес>:8080 --dart-define=APP_VERSION=0.1.0
```

APK подписан отладочным ключом. Для публикации в Google Play нужен собственный ключ подписи, а сервер — по HTTPS на постоянном адресе.

## Этапы разработки

1. ✅ Структура монорепо, docker-compose, SQL-миграции
2. ✅ Пакет `shared` с моделями
3. ✅ Worker: Steam-клиент, очередь, rate limiter, задачи цен и онлайна (подробности в [worker/README.md](worker/README.md))
4. ✅ Сервер: эндпоинты games, top, watchlist, devices, auth/anonymous (подробности в [server/README.md](server/README.md))
5. ✅ Приложение: навигация, тема, api-клиент, кэш drift (подробности в [app/README.md](app/README.md))
6. ✅ Экраны поиска, игры, топа, скидок, списка отслеживания
7. ✅ Push-уведомления (FCM HTTP v1; Android проверен на эмуляторе, для iOS нужен ключ APNs)

Дополнительно: ✅ **импорт списка желаемого Steam**. Пользователь вставляет ссылку на профиль или ник (вход через Steam не нужен), worker раз в сутки читает открытый список желаемого и добавляет игры в отслеживаемые с выбранным порогом скидки. Игры, убранные из списка желаемого, убираются; добавленные или изменённые вручную не трогаются.
