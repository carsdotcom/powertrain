#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 5
VERSION_SCRIPT=${ARGS[3]}
PT_CONTEXT=${ARGS[4]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
echo "Building \"$REGISTRY""$IMAGE\"..."
docker build -t $REGISTRY""$IMAGE $PT_CONTEXT
