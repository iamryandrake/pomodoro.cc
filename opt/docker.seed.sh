#!/bin/bash

docker run --rm -it --link pomodoro-api-db:mongo_alias -v /pomodoro.cc/api/opt/mongo/seed.js:/run.js mongo sh -c "mongo --host mongo_alias < /run.js"
