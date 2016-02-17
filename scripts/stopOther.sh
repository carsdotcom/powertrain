#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
CONTAINERS="$(docker ps | grep -v "$REGISTRY""$IMAGE" | grep "$REGISTRY""$NAME")"
if [ -n "$CONTAINERS" ]; then
    echo "Stopping the following containers:"
    printf "$CONTAINERS\n"
    docker stop $(printf "$CONTAINERS" | awk '{print $1}')
else
    echo "No containers to stop."
fi
