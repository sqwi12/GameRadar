# Сборка worker. Контекст сборки — корень монорепо (см. docker-compose.yml).
FROM dart:stable AS build
WORKDIR /src

COPY pubspec.yaml pubspec.lock ./
COPY shared/pubspec.yaml shared/
COPY worker/pubspec.yaml worker/

# В workspace есть Flutter-приложение, а в образе dart нет Flutter SDK.
# Оставляем в workspace только нужные пакеты; версии фиксирует pubspec.lock.
RUN sed -i '/^  - app$/d; /^  - server$/d' pubspec.yaml && dart pub get

COPY shared/ shared/
COPY worker/ worker/
RUN dart pub get --offline && dart compile exe worker/bin/worker.dart -o /out/worker

# Минимальный образ: только бинарник и runtime-файлы (libc, сертификаты).
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /out/worker /app/worker
USER 65534
ENTRYPOINT ["/app/worker"]
