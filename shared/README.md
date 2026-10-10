# gameradar_shared

Общие модели API GameRadar (freezed + json_serializable) для приложения, сервера и worker. Пакет на чистом Dart, без зависимости от Flutter.

- JSON-ключи в `snake_case`, как в БД; ключи со значением `null` не отправляются.
- Цены — `int` в минимальных единицах валюты.
- Параметры списков (`SearchQuery`, `TopQuery`, `DiscountsQuery`) передаются в query-строке: `toQueryParameters()` в приложении, `fromQueryParameters()` на сервере.
- У запросов есть `validate()`: сервер возвращает ошибки как `ApiError` с кодами полей, приложение может проверить ввод заранее.
- Сгенерированные файлы `*.freezed.dart` и `*.g.dart` коммитятся, чтобы сборка Docker-образов не требовала build_runner.

```bash
dart run build_runner build   # перегенерировать после изменения моделей
dart test
```
