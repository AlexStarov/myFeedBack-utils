#!/bin/bash
echo "Запуск бэкенда в режиме разработки (Watch)..."

# Создаем сеть только если она не существует
docker network inspect feedback-network >/dev/null 2>&1 || \
    docker network create feedback-network

docker compose down --remove-orphans
# Запуск: --watch поддерживается в новых версиях docker compose (v2.x+)
# Убираем --no-cache отсюда — оно уже применено на этапе build
docker compose up --build --force-recreate # --detach