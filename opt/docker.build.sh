#!/bin/bash

echo "\n\n"
echo "----> building pomodoro"
docker build -t christianfei/pomodoro-app app

echo "\n\n"
echo "----> building pomodoro-api"
docker build -t christianfei/pomodoro-api api

echo "\n\n"
echo "----> building pomodoro-socket-io"
docker build -t christianfei/pomodoro-socket-io socket-io
