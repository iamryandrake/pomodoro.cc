#!/bin/bash

SCRIPT_DIR=$(dirname `readlink -f $0`)
PROJECT_DIR=$(dirname $SCRIPT_DIR)
if [ "$PROJECT_DIR" = "/" ]; then
  PROJECT_DIR="/pomodoro.cc"
fi

echo "PROJECT_DIR=$PROJECT_DIR"
echo "-------> SEEDING: $PROJECT_DIR/api/opt/mongo/seed.js"
ls -lh $PROJECT_DIR/api/opt/mongo/seed.js

docker run --rm -it --link pomodoro-api-db:mongo_alias \
  -v $PROJECT_DIR/db:/data/db \
  -v $PROJECT_DIR/api/opt/mongo/seed.js:/run.js \
  mongo sh -c "mongo --host mongo_alias < /run.js"
