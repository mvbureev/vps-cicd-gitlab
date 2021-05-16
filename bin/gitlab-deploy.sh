#!/usr/bin/env sh
# Падаем сразу, если возникли какие-то ошибки
set -e
# Выводим, то , что делаем
set -v

DOCKER_COMPOSE_FILE=docker-compose.yml
# export DOCKER_HOST=tcp://$DEPLOY_HOST:2376

# проверим, что коннектится все успешно
docker-compose \
  -f $DOCKER_COMPOSE_FILE \
  ps

# логинимся в docker-регистри, тут можете указать свой "местный" регистри
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD

docker-compose \
  -f $DOCKER_COMPOSE_FILE \
  pull

docker-compose \
  -f $DOCKER_COMPOSE_FILE \
  build

docker-compose \
  -f $DOCKER_COMPOSE_FILE \
  down

# поднимаем приложение
docker-compose \
  -f $DOCKER_COMPOSE_FILE \
  up
