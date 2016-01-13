#!/bin/bash

MACHINE=dev
if [[ ! -z "$1" ]]; then
    MACHINE=$1
fi

$POWERTRAIN_DIR/scripts/machineRoute.sh

STATUS=`docker-machine status $MACHINE`
if [[ "$STATUS" == "Stopped" ]]; then
    docker-machine start $MACHINE
fi

$POWERTRAIN_DIR/scripts/machineEnv.sh $MACHINE
