#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
echo "Killing \"$REGISTRY""$IMAGE\"..."
docker ps | grep $REGISTRY""$IMAGE | awk '{print $1}' | xargs docker kill