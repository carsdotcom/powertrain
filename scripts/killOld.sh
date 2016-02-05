#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[4]}
TOTAL_INSTANCES="$(docker ps | grep "$REGISTRY""$NAME" | wc -l | awk '{print $1}')"
OLD_INSTANCES=$((TOTAL_INSTANCES - INSTANCES))
if [ "$OLD_INSTANCES" -ge 0 ]; then
    CONTAINERS="$(docker ps | grep "$REGISTRY""$NAME" | awk '{print $1}' | xargs docker inspect -f "{{.Created}} {{.Id}}" | sort -r | tail -n +$((INSTANCES + 1)))"
    if [ -n "$CONTAINERS" ]; then
        echo "Killing the following containers:"
        printf "$CONTAINERS"
        printf "$CONTAINERS" | awk '{print $2}' | xargs docker kill
    fi
else
    echo "No containers to kill"
fi
