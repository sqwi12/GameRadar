#!/bin/bash
# Запуск в одном контейнере: сначала миграции, затем worker и сервер.
# Если один из процессов завершится, останавливаем второй и выходим —
# хостинг перезапустит контейнер целиком.
set -uo pipefail

/app/migrate up || exit 1

/app/worker &
worker=$!
/app/server &
server=$!

stop() {
  kill -TERM "$worker" "$server" 2>/dev/null
}
trap stop TERM INT

wait -n "$worker" "$server"
status=$?
stop
wait
exit "$status"
