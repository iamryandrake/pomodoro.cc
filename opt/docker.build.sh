#!/bin/bash

SCRIPT_DIR=$(dirname `readlink -f $0`)
PROJECT_DIR=$(dirname $SCRIPT_DIR)

if [ "$PROJECT_DIR" = "/" ]; then
  PROJECT_DIR="/pomodoro.cc"
fi

echo "\n\n"
echo "----> building pomodoro-app"
docker build -t christianfei/pomodoro-app $PROJECT_DIR/app

echo "\n\n"
echo "----> building pomodoro-api"
docker build -t christianfei/pomodoro-api $PROJECT_DIR/api
