#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
source $POWERTRAIN_DIR/var/MACHINE_NAME.sh ${ARGS[0]}

STATUS=$(docker-machine status $MACHINE_NAME)
if [[ "$STATUS" == "Running" ]]; then
    docker-machine stop $MACHINE_NAME
fi

