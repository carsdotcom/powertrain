#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 4
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
CONTAINERS="$(docker ps | tail -n +2 | grep -v "$REGISTRY""$IMAGE" | grep "$REGISTRY""$NAME")"
if [ -n "$CONTAINERS" ]; then
    echo "Killing the following containers:"
    printf "$CONTAINERS\n"
    docker kill $(printf "$CONTAINERS" | awk '{print $1}')
fi
