#!/bin/bash
in_array() {
    local needle=$1 arr=$2
    for item in $arr; do
        [[ $item == $needle ]] && return 0
    done
    return 1
}

ALLPORTS=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "'$1'/tcp") 0).HostPort}}' $(docker ps -q) 2> /dev/null |  tr -d ' ' | grep -v '^$')

NEXT_PORT=$1

while in_array $NEXT_PORT "${ALLPORTS[@]}"; do
    NEXT_PORT=$((NEXT_PORT+1))
done
