#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
VERSION_SCRIPT=${ARGS[3]}
PROJECT_DIR=${ARGS[4]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
echo "Building \"$REGISTRY""$IMAGE\"..."
docker build -t $REGISTRY""$IMAGE $PROJECT_DIR
