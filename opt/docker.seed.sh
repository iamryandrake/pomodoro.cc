#!/bin/bash

SCRIPT_DIR=$(dirname `readlink -f $0`)
PROJECT_DIR=$(dirname $SCRIPT_DIR)
if [ "$PROJECT_DIR" = "/" ]; then
  PROJECT_DIR="/pomodoro.cc"
fi

docker run --rm -it --link pomodoro-api-db:mongo_alias -v $PROJECT_DIR/api/opt/mongo/seed.js:/run.js mongo sh -c "mongo --host mongo_alias < /run.js"
