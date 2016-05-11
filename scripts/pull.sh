#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 4
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
echo "Pulling \"$REGISTRY""$IMAGE\"..."
docker pull $REGISTRY""$IMAGE
