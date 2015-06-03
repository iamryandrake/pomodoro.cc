#!/bin/bash

id_for_container(){
    CONTAINER="$1\s*$"
    CONTAINER_ID="$(docker ps -a | grep "$CONTAINER" | awk '{print $1}')"
    echo $CONTAINER_ID
}

stop_container(){
    CONTAINER_ID="$(id_for_container "$1")"
    if [ -n "$CONTAINER_ID" ]; then
        echo "\n\n"
        echo "----> stopping '$1'"
        docker rm -f $CONTAINER_ID
    fi
}




stop_container 'pomodoro-api'
stop_container 'pomodoro-api-1'
stop_container 'pomodoro-api-2'
stop_container 'pomodoro-socket-io'
stop_container 'pomodoro-app'
stop_container 'pomodoro'
