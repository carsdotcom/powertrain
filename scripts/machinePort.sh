#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh

MACHINE=dev
ALIAS="vpnhost"
PORT=2376

if [[ ! -z "${ARGS[0]}" ]]; then
    MACHINE=${ARGS[0]}
fi
if [[ ! -z "${ARGS[1]}" ]]; then
    ALIAS=${ARGS[1]}
fi
if [[ ! -z "${ARGS[2]}" ]]; then
    PORT=${ARGS[2]}
fi

STATUS=`docker-machine status $MACHINE`

if [[ "$STATUS" == "Running" ]]; then
    echo "Stopping machine $MACHINE"
    docker-machine stop $MACHINE
fi

echo "Adding port forward for port $PORT on machine $MACHINE with alias $ALIAS"
VBoxManage modifyvm "$MACHINE" --natpf1 "$ALIAS,tcp,,$PORT,,$PORT"

if [[ "$STATUS" == "Running" ]]; then
    echo "Starting machine $MACHINE"
    docker-machine start $MACHINE
fi
