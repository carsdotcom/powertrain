#!/bin/bash

VALID_PORT_RANGES=8000-8099,9000-9099,10000-10099,1337-1357,8446-8461

above_range() {
    local port=$1
    if (( $port>8099 || $port>9099   || $port>10099  || $port>1357 || $port>8461 )); then
        return 0
    else
        return 1
    fi
}

get_initial_port() {
    # if configured port is in the allowed ranges, 
    # assign the range start boundary as the initial port
    local port=$1 start_port
    IFS=',' read -ra RANGES <<< "$VALID_PORT_RANGES"
    for RANGE in "${RANGES[@]}"; do
        IFS='-'; read -ra ARANGE <<< "$RANGE"
        if (("${ARANGE[0]}"<="$port" && "$port"<="${ARANGE[1]}")); then
            start_port="${ARANGE[0]}"
        fi
    done
    echo $start_port
}

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

read -d '' INVALID_PORT_MESSAGE <<EOM
Configured port [$NEXT_PORT] is out of the below allowed ranges
    8000  -  8099  ( Web Apps )
    9000  -  9099  ( RESTful Services )
    10000 -  10099 ( Composite services )
    1337  -  1357  ( Rendering )
    8446  -  8461  ( Sell )
EOM

NEXT_PORT=$(get_initial_port "$NEXT_PORT")

if [ -z "$NEXT_PORT" ];then
    echo "$INVALID_PORT_MESSAGE"
    exit 1
fi

while in_array $NEXT_PORT "${ALLPORTS[@]}"; do
    NEXT_PORT=$((NEXT_PORT+1))
    if above_range $NEXT_PORT; then
        echo "******************** FATAL ********************"
        echo "Powertrain cannot allocate port [$NEXT_PORT]"
        echo "Port [$NEXT_PORT] outside of limit allowed by firewall rules."
        echo "******************** FATAL ********************"
        exit 1
    fi
done
