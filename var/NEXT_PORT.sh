#!/bin/bash
source $POWERTRAIN_DIR/var/DEFAULT_PORT.sh $1

in_array() {
    local needle=$1 arr=$2
    for item in $arr; do
        [[ $item == $needle ]] && return 0
    done
    return 1
}

PORTS=$(docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{(index $conf 0).HostPort}} {{end}}' $(docker ps -q) 2> /dev/null |  tr -d ' ' | grep -v '^$')

NEXT_PORT=$DEFAULT_PORT

while in_array $NEXT_PORT "${PORTS[@]}"; do
    NEXT_PORT=$((NEXT_PORT+1))
done
