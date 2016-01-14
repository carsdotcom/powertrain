#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
source $POWERTRAIN_DIR/var/MACHINE_NAME.sh ${ARGS[0]}

docker-machine status $MACHINE_NAME
if [[ "$?" == "1" ]]; then
    echo "Creating machine $MACHINE_NAME"
    docker-machine create -d virtualbox --virtualbox-boot2docker-url=https://github.com/boot2docker/boot2docker/releases/download/v1.9.0/boot2docker.iso --tls-san=127.0.0.1 $MACHINE_NAME
fi
