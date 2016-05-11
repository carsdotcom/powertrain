#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 4
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/VERSION.sh ${ARGS[1]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
if [ "${ARGS[1]}" == "all" ]; then
    CONTAINERS="$(docker ps -a | grep $REGISTRY""$NAME)"
else
    CONTAINERS="$(docker ps | grep $REGISTRY""$IMAGE)"
fi
if [ -n "$CONTAINERS" ]; then
    echo "Containers matching \"$REGISTRY""$IMAGE\"..."
    printf "$CONTAINERS\n"
fi
