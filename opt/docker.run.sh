#!/bin/bash

SCRIPT_DIR=$(dirname `readlink -f $0`)
PROJECT_DIR=$(dirname $SCRIPT_DIR)
if [ "$PROJECT_DIR" = "/" ]; then
  PROJECT_DIR="/pomodoro.cc"
fi

ENV="PRO"
if [ "$1" = "DEV" ];then
  ENV="DEV"
fi

id_for_container(){
  CONTAINER="$1\s*$"
  CONTAINER_ID="$(docker ps -a | grep "$CONTAINER" | awk '{print $1}')"
  echo $CONTAINER_ID
}







if [ -z "$(id_for_container 'pomodoro-api-sessions')" ]; then
  echo "\n\n"
  echo "----> STARTING 'pomodoro-api-sessions'"
  docker run --name pomodoro-api-sessions \
    --restart=always \
    -d \
    redis:latest \
    redis-server
fi




if [ -z "$(id_for_container 'pomodoro-api-db')" ]; then
  echo "\n\n"
  echo "----> STARTING 'pomodoro-api-db'"
  docker run --name pomodoro-api-db \
    --restart=always \
    -d \
    -v $PROJECT_DIR/db:/data/db \
    -v $PROJECT_DIR/backup:/backup \
    mongo:latest
fi





if [ -z "$(id_for_container 'pomodoro-blog')" ]; then
  echo "\n\n"
  echo "----> STARTING 'pomodoro-blog'"
  docker run --name pomodoro-blog \
    --restart=always \
    -d \
    -v=$PROJECT_DIR/blog:/srv/jekyll \
    jekyll/stable
fi





if [ -z "$(id_for_container 'pomodoro-api-1')" ]; then
  echo "\n\n"
  echo "----> STARTING 'pomodoro-api-1'"
  docker run --name pomodoro-api-1 \
    --restart=always \
    -d \
    --env ENV="$ENV" \
    -v $PROJECT_DIR/credentials.json:/credentials.json \
    -v $PROJECT_DIR/shared:/shared \
    --link pomodoro-api-sessions:pomodoro-api-sessions \
    --link pomodoro-api-db:pomodoro-api-db \
    christianfei/pomodoro-api
fi

if [ -z "$(id_for_container 'pomodoro-api-2')" ]; then
  echo "\n\n"
  echo "----> STARTING 'pomodoro-api-2'"
  docker run --name pomodoro-api-2 \
    --restart=always \
    -d \
    --env ENV="$ENV" \
    -v $PROJECT_DIR/credentials.json:/credentials.json \
    -v $PROJECT_DIR/shared:/shared \
    --link pomodoro-api-sessions:pomodoro-api-sessions \
    --link pomodoro-api-db:pomodoro-api-db \
    christianfei/pomodoro-api
fi





if [ -z "$(id_for_container 'pomodoro-app')" ]; then
  echo "\n\n"
  echo "----> STARTING 'pomodoro-app'"
  if [ "$ENV" = "DEV" ]; then
    docker run --name pomodoro-app \
      --restart=always \
      -d \
      -v $PROJECT_DIR/app/www:/var/www/pomodoro.cc/ \
      christianfei/pomodoro-app
  else
    docker run --name pomodoro-app \
      --restart=always \
      -d \
      christianfei/pomodoro-app
  fi
fi





if [ -z "$(id_for_container 'pomodoro-main')" ]; then
  echo "\n\n"
  echo "----> STARTING 'pomodoro-main'"
  docker run --name pomodoro-main \
    --restart=always \
    -d \
    -p 80:80 \
    -p 443:443 \
    --link pomodoro-app:pomodoro-app \
    --link pomodoro-api-1:pomodoro-api-1 \
    --link pomodoro-api-2:pomodoro-api-2 \
    --link pomodoro-blog:pomodoro-blog \
    -v $PROJECT_DIR/main/etc/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v $PROJECT_DIR/ssl:/etc/nginx/ssl/pomodoro.cc \
    nginx:1.9.1
fi




echo "\n\n\n"
echo "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMMMMMMMMMMMMNmMMMMMMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMNMMMMMMMMMmoyyNMMMMMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMNshhddmNMMdyhyMMMMMMMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMmddyyhhhhysoyh+yhhdhhdhhmMMMMMMMMMMMMM"
echo "MMMMMMMMNhyoooo+sydysyhhhhhhhhhhhsso/+oydMMMMMMMMM"
echo "MMMMMMNyoooooooooyyhhhhshhyyhhhsom++oooooohMMMMMMM"
echo "MMMMMmooooooo+o+shhhhhyshhh/yyhhhys/o+ooooooNMMMMM"
echo "MMMMd+oooooo+syyyyyyyhNhhhhsmyohhdhyo+ooooooomMMMM"
echo "MMMN+ooooooooooooyso+o/hyhhsy/o++oo+ooooooososMMMM"
echo "MMMsooooooooooooooooooo+-shohoooooooooooooooo+MMMM"
echo "MMM/oooooooooooooooooooo++sy+oooooooooooooooo+NMMM"
echo "MMM/ooooooooooooooooooooooooooooooooooooooooooyMMM"
echo "MMMooooooooooooooooooooooooooooooooooooooooooomMMM"
echo "MMMyooooooooooooooooooooooooooooooooooooooooo+NMMM"
echo "MMMMooooooooooooooooooooooooooooooooooooooooosMMMM"
echo "MMMMd+oooooooooooooooooooooooooooooooooooooooNMMMM"
echo "MMMMMyoooooooooooooooooooooooooooooooooooooomMMMMM"
echo "MMMMMMNooooooooooooooooooooooooooooooooooooNMMMMMM"
echo "MMMMMMMMdoooooooooooooooooooooooooooooooohMMMMMMMM"
echo "MMMMMMMMMMdooooooooooooooooooooooooooosdMMMMMMMMMM"
echo "MMMMMMMMMMMMdho+oooooooooooooooooo+shNMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMNdhysooo+ooosossyhdMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
