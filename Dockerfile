# Образ для хостинга одним контейнером (Render): миграции, worker и сервер.
# Redis не нужен: без REDIS_URL worker держит очередь в памяти, а отметки
# периодических работ — в PostgreSQL. Для docker compose (отдельные
# контейнеры и Redis) — server/Dockerfile и worker/Dockerfile.
FROM dart:stable AS build
WORKDIR /src

COPY pubspec.yaml pubspec.lock ./
COPY shared/pubspec.yaml shared/
COPY server/pubspec.yaml server/
COPY worker/pubspec.yaml worker/

# В workspace есть Flutter-приложение, а в образе dart нет Flutter SDK.
# Убираем его из workspace; версии остальных пакетов фиксирует pubspec.lock.
RUN sed -i '/^  - app$/d' pubspec.yaml && dart pub get
RUN dart pub global activate dart_frog_cli

COPY shared/ shared/
COPY server/ server/
COPY worker/ worker/

# dart_frog build генерирует build/bin/server.dart из папки routes.
RUN cd server && dart pub get --offline && /root/.pub-cache/bin/dart_frog build \
    && cd /src && mkdir -p /out \
    && dart compile exe server/build/bin/server.dart -o /out/server \
    && dart compile exe worker/bin/worker.dart -o /out/worker \
    && dart compile exe worker/tool/migrate.dart -o /out/migrate

# Нужна оболочка для запуска двух процессов, поэтому не scratch.
FROM debian:bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /out/ /app/
COPY migrations/ /app/migrations/
COPY deploy/start.sh /app/start.sh
ENV MIGRATIONS_DIR=/app/migrations \
    PORT=8080
EXPOSE 8080
USER 65534
ENTRYPOINT ["/bin/bash", "/app/start.sh"]
