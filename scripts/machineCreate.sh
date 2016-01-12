#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh

MACHINE=dev
if [[ ! -z "${ARGS[0]}" ]]; then
    MACHINE=${ARGS[0]}
fi

echo "Creating machine $MACHINE"
docker-machine create -d virtualbox --virtualbox-boot2docker-url=https://github.com/boot2docker/boot2docker/releases/download/v1.9.0/boot2docker.iso --tls-san=127.0.0.1 $MACHINE

$POWERTRAIN_DIR/scripts/machinePort.sh $MACHINE vpn 2376  
