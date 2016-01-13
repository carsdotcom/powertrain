#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh

HOST=127.0.0.1
MACHINE=dev

if [[ ! -z "${ARGS[0]}" ]]; then
    MACHINE=${ARGS[0]}
fi

#TODO figure out if you are on vpn 
echo 'export DOCKER_TLS_VERIFY="1"'
echo 'export DOCKER_HOST="tcp://'$HOST':2376"'
echo 'export DOCKER_CERT_PATH="`echo ~`/.docker/machine/machines/'$MACHINE'"'
echo 'export DOCKER_MACHINE_NAME="'$MACHINE'"'
echo '# Run this command to configure your shell:'
echo '# eval "$(powertrain machine-env' $MACHINE')"'
