#!/bin/bash

echo "\n\n"
echo "----> building pomodoro"
docker build -t christianfei/pomodoro-app /pomodoro.cc/app

echo "\n\n"
echo "----> building pomodoro-api"
docker build -t christianfei/pomodoro-api /pomodoro.cc/api

echo "\n\n"
echo "----> building pomodoro-socket-io"
docker build -t christianfei/pomodoro-socket-io /pomodoro.cc/socket-io
