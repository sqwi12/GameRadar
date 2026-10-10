# Сборка сервера. Контекст сборки — корень монорепо (см. docker-compose.yml).
FROM dart:stable AS build
WORKDIR /src

COPY pubspec.yaml pubspec.lock ./
COPY shared/pubspec.yaml shared/
COPY server/pubspec.yaml server/

# В workspace есть Flutter-приложение, а в образе dart нет Flutter SDK.
# Оставляем в workspace только нужные пакеты; версии фиксирует pubspec.lock.
RUN sed -i '/^  - app$/d; /^  - worker$/d' pubspec.yaml && dart pub get
RUN dart pub global activate dart_frog_cli

COPY shared/ shared/
COPY server/ server/

# dart_frog build генерирует build/bin/server.dart из папки routes.
# Компилируем его внутри workspace: отдельный pubspec из build/ не нужен.
RUN cd server && dart pub get --offline && /root/.pub-cache/bin/dart_frog build \
    && cd /src && dart compile exe server/build/bin/server.dart -o /out/server

# Минимальный образ: только бинарник и runtime-файлы (libc, сертификаты).
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /out/server /app/server
ENV PORT=8080
EXPOSE 8080
USER 65534
ENTRYPOINT ["/app/server"]
