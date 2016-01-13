#!/bin/bash

HOST=127.0.0.1
MACHINE=dev

if [[ ! -z "$1" ]]; then
    MACHINE=$1
fi

VPN=`ifconfig -a | grep utun`

if [[ ! -z "$VPN" ]]; then
    echo 'export DOCKER_TLS_VERIFY="1"'
    echo 'export DOCKER_HOST="tcp://'$HOST':2376"'
    echo 'export DOCKER_CERT_PATH="`echo ~`/.docker/machine/machines/'$MACHINE'"'
    echo 'export DOCKER_MACHINE_NAME="'$MACHINE'"'
    echo '# Run this command to configure your shell:'
    echo '# eval "$(powertrain machine-env MACHINE='$MACHINE')"'
else
    docker-machine env $MACHINE
fi

