#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
CONTAINERS="$(docker ps -a | grep -v $REGISTRY""$IMAGE)"
if [ -n "$CONTAINERS" ]; then
    echo "Removing the following containers:"
    printf "$CONTAINERS\n"
    docker rm -f $(printf "$CONTAINERS" | awk '{print $1}')
fi
