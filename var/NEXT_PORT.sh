#!/bin/bash
in_array() {
    local needle=$1 arr=$2
    for item in $arr; do
        [[ $item == $needle ]] && return 0
    done
    return 1
}

# if we have netstat and we're on OS X...
if [ -n "$(which netstat)" ] && [ "$(uname)" == "Darwin" ]; then
    # if using docker-machine...
    if [ -n "$(which docker-machine)" ] && [ -n "$DOCKER_MACHINE_NAME" ]; then
        ALLPORTS=$(docker-machine ssh $DOCKER_MACHINE_NAME netstat -anl | grep -E "^tcp|^udp" | awk '{print $4}' | rev | cut -d ':' -f1 | rev | sort -g | uniq)
    # if using docker for mac...
    else
        ALLPORTS=$(netstat -anl | grep -E "^tcp|^udp" | awk '{print $4}' | rev | cut -d'.' -f1 | rev | sort -g | uniq | grep -v "*")
    fi
# if we have netstat and are on Linux...
elif [ -n "$(which netstat)" ] && [ "$(uname)" == "Linux" ]; then
    ALLPORTS=$(netstat -anl | grep -E "^tcp|^udp" | awk '{print $4}' | rev | cut -d ':' -f1 | rev | sort -g | uniq)
# if we're in an unknown OS...
else
    ALLPORTS=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "'$1'/tcp") 0).HostPort}}' $(docker ps -q) 2> /dev/null |  tr -d ' ' | grep -v '^$')
fi

NEXT_PORT=$1

while in_array $NEXT_PORT "${ALLPORTS[@]}"; do
    NEXT_PORT=$((NEXT_PORT+1))
done
