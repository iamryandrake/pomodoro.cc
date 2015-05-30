#!/bin/bash

id_for_container(){
    CONTAINER="$1\s*$"
    CONTAINER_ID="$(docker ps -a | grep "$CONTAINER" | awk '{print $1}')"
    echo $CONTAINER_ID
}

stop_container(){
    CONTAINER_ID="$(id_for_container "$1")"
    if [ -n "$CONTAINER_ID" ]; then
        echo " ===> stopping '$1'"
        docker rm -f $CONTAINER_ID
        echo ""
    fi
}

stop_container 'pomodoro-api'
stop_container 'pomodoro-api-1'
stop_container 'pomodoro-api-2'
stop_container 'pomodoro-socket-io'
stop_container 'pomodoro-app'
stop_container 'pomodoro-app-beta'
stop_container 'pomodoro-main'


echo "\n --> building pomodoro-app"
docker build -t christianfei/pomodoro-app /vagrant/app

echo "\n --> building pomodoro-app-beta"
docker build -t christianfei/pomodoro-app-beta /vagrant/app-beta

echo "\n --> building pomodoro-api"
docker build -t christianfei/pomodoro-api /vagrant/api

echo "\n --> building pomodoro-socket-io"
docker build -t christianfei/pomodoro-socket-io /vagrant/socket-io

if [ -z "$(id_for_container 'pomodoro-api-sessions')" ]; then
    echo "\n ===> starting 'pomodoro-api-sessions'"
    docker run --name pomodoro-api-sessions \
        --restart=always \
        -d \
        redis:latest \
        redis-server
fi

if [ -z "$(id_for_container 'pomodoro-api-db')" ]; then
    echo "\n ===> starting 'pomodoro-api-db'"
    docker run --name pomodoro-api-db \
        --restart=always \
        -d \
        -v /data/pomodoro-api-db:/data/db \
        mongo:latest
fi

if [ -z "$(id_for_container 'pomodoro-api-db-test')" ]; then
    echo "\n ===> starting 'pomodoro-api-db-test'"
    docker run --name pomodoro-api-db-test \
        --restart=always \
        -d \
        mongo:latest
fi

echo "\n ===> starting 'pomodoro-api-1'"
docker run --name pomodoro-api-1 \
    --restart=always \
    -d \
    -v /vagrant/api:/api \
    -v /vagrant/credentials.json:/credentials.json \
    --link pomodoro-api-sessions:pomodoro-api-sessions \
    --link pomodoro-api-db:pomodoro-api-db \
    christianfei/pomodoro-api

echo "\n ===> starting 'pomodoro-api-2'"
docker run --name pomodoro-api-2 \
    --restart=always \
    -d \
    -v /vagrant/api:/api \
    -v /vagrant/credentials.json:/credentials.json \
    --link pomodoro-api-sessions:pomodoro-api-sessions \
    --link pomodoro-api-db:pomodoro-api-db \
    christianfei/pomodoro-api

echo "\n ===> starting 'pomodoro-socket-io'"
docker run --name pomodoro-socket-io \
    --restart=always \
    -d \
    christianfei/pomodoro-socket-io

echo "\n ===> starting 'pomodoro'"
docker run --name pomodoro-app \
    --restart=always \
    -d \
    -v /vagrant/app/etc/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v /vagrant/app/www:/var/www/pomodoro.cc \
    --link pomodoro-api-1:pomodoro-api-1 \
    --link pomodoro-api-2:pomodoro-api-2 \
    --link pomodoro-socket-io:pomodoro-socket-io \
    christianfei/pomodoro-app

echo "\n ===> starting 'pomodoro-app-beta'"
docker run --name pomodoro-app-beta \
    --restart=always \
    -d \
    -v /vagrant/app-beta/www:/var/www/pomodoro.cc \
    christianfei/pomodoro-app-beta

echo "\n ===> starting 'pomodoro-main'"
docker run --name pomodoro-main \
    --restart=always \
    -d \
    -p 80:80 \
    -v /vagrant/main/etc/nginx/nginx.conf:/etc/nginx/nginx.conf \
    --link pomodoro-app:pomodoro-app \
    --link pomodoro-app-beta:pomodoro-app-beta \
    nginx:1.9.1
