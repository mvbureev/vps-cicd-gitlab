#!/usr/bin/env sh
# Падаем сразу, если возникли какие-то ошибки
set -e
# Выводим, то , что делаем
set -v

# 
DOCKER_COMPOSE_FILE=docker-compose.yml
# Куда деплоим (добавлин напрямую в gitlab)
# DEPLOY_HOST=78.140.136.90
# Путь для сертификатов клиента, то есть в нашем случае - gitlab-воркера
DOCKER_CERT_PATH=/root/.docker

# проверим, что в контейнере все имеется
docker info
docker-compose version

# создаем путь (сейчас работаем в клиенте - воркере gitlab'а)
mkdir $DOCKER_CERT_PATH
# изымаем содержимое переменных, при этом удаляем лишние символы добавленные при сохранении переменных.
echo "$CA_PEM" | tr -d '\r' > $DOCKER_CERT_PATH/ca.pem
echo "$CERT_PEM" | tr -d '\r' > $DOCKER_CERT_PATH/cert.pem
echo "$KEY_PEM" | tr -d '\r' > $DOCKER_CERT_PATH/key.pem
# на всякий случай даем только читать
chmod 400 $DOCKER_CERT_PATH/ca.pem
chmod 400 $DOCKER_CERT_PATH/cert.pem
chmod 400 $DOCKER_CERT_PATH/key.pem

# далее начинаем уже работать с удаленным docker-демоном. Собственно, сам деплой
export DOCKER_TLS_VERIFY=1
export DOCKER_HOST=tcp://$DEPLOY_HOST:2376

# проверим, что коннектится все успешно
docker-compose \
  -f $DOCKER_COMPOSE_FILE \
  ps

# логинимся в docker-регистри, тут можете указать свой "местный" регистри
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD

docker-compose \
  -f $DOCKER_COMPOSE_FILE \
  pull app
# поднимаем приложение
docker-compose \
  -f $DOCKER_COMPOSE_FILE \
  up --build -d app
