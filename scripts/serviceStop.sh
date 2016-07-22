#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 1

SRV_EXISTS=($(docker service ls -f "name=${ARGS[0]}" | awk 'NR>1 {print $1}'))

if [ -n "$SRV_EXISTS" ]; then
    echo "Removing service..."
    docker service rm ${ARGS[0]}
else
    echo "No service named ${ARGS[0]} in this swarm cluster"
    exit 1
fi

