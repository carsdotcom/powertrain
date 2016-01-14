#!/bin/bash

#Breaking the pattern due to this script will be called thru eval thus it wont have the other items sourced in

if [[ ! -z "$1" ]]; then
    MACHINE_NAME=$1
else 
    MACHINE_NAME=cars
fi

VPN=$(ifconfig -a | grep utun)

if [[ ! -z "$VPN" ]]; then
    echo 'export DOCKER_TLS_VERIFY="1"'
    echo 'export DOCKER_HOST="tcp://127.0.0.1:2376"'
    echo 'export DOCKER_CERT_PATH="`echo ~`/.docker/machine/machines/'$MACHINE_NAME'"'
    echo 'export DOCKER_MACHINE_NAME="'$MACHINE_NAME'"'
    echo '# Run this command to configure your shell:'
    echo '# eval "$(powertrain machine-env MACHINE_NAME='$MACHINE_NAME')"'
else
    echo '# Run this command to configure your shell:'
    echo '# eval $(docker-machine env '$MACHINE_NAME')'
fi

