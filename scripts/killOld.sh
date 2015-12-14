#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
echo "Killing the following containers:"
echo "$(docker ps | tail -n +2 | grep -v "$REGISTRY""$IMAGE" | grep "$REGISTRY""$NAME")"
docker ps | tail -n +2 | grep -v "$REGISTRY""$IMAGE" | grep "$REGISTRY""$NAME" | awk '{print $1}' | xargs docker kill
