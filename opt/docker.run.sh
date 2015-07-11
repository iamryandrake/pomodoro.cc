#!/bin/bash

id_for_container(){
  CONTAINER="$1\s*$"
  CONTAINER_ID="$(docker ps -a | grep "$CONTAINER" | awk '{print $1}')"
  echo $CONTAINER_ID
}

SCRIPT_DIR=$(dirname `readlink -f $0`)
PROJECT_DIR=$(dirname $SCRIPT_DIR)

echo "SCRIPT_DIR=$SCRIPT_DIR"
echo "PROJECT_DIR=$PROJECT_DIR"

if [ -z "$(id_for_container 'pomodoro-api-sessions')" ]; then
  echo "\n\n"
  echo "----> starting 'pomodoro-api-sessions'"
  docker run --name pomodoro-api-sessions \
    --restart=always \
    -d \
    redis:latest \
    redis-server
fi

if [ -z "$(id_for_container 'pomodoro-api-db')" ]; then
  echo "\n\n"
  echo "----> starting 'pomodoro-api-db'"
  docker run --name pomodoro-api-db \
    --restart=always \
    -d \
    -v /db:/data/db \
    -v /backup:/backup \
    mongo:latest
fi

if [ -z "$(id_for_container 'pomodoro-blog')" ]; then
  echo "\n\n"
  echo "----> starting 'pomodoro-blog'"
  docker run --name pomodoro-blog \
    --restart=always \
    -d \
    -v=$PROJECT_DIR/blog:/srv/jekyll \
    jekyll/stable
fi

if [ -z "$(id_for_container 'pomodoro-api')" ]; then
  echo "\n\n"
  echo "----> starting 'pomodoro-api'"
  docker run --name pomodoro-api \
    --restart=always \
    -d \
    -v $PROJECT_DIR/credentials.json:/credentials.json \
    --link pomodoro-api-sessions:pomodoro-api-sessions \
    --link pomodoro-api-db:pomodoro-api-db \
    christianfei/pomodoro-api
fi

if [ -z "$(id_for_container 'pomodoro-app')" ]; then
  echo "\n\n"
  echo "----> starting 'pomodoro-app'"
  docker run --name pomodoro-app \
    --restart=always \
    -d \
    christianfei/pomodoro-app
fi

if [ -z "$(id_for_container 'pomodoro-main')" ]; then
  echo "\n\n"
  echo "----> starting 'pomodoro-main'"
  docker run --name pomodoro-main \
    --restart=always \
    -d \
    -p 80:80 \
    -p 443:443 \
    --link pomodoro-app:pomodoro-app \
    --link pomodoro-api:pomodoro-api \
    --link pomodoro-blog:pomodoro-blog \
    -v $PROJECT_DIR/ssl:/etc/nginx/ssl/pomodoro.cc \
    christianfei/pomodoro-main
fi
