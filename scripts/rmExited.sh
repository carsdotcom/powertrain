#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[1]}
CONTAINERS="$(docker ps -a -f "status=exited" | grep $REGISTRY""$IMAGE)"
if [ -n "$CONTAINERS" ]; then
    echo "Cleaning up exited containers"
    docker rm -v $(printf "$CONTAINERS" | awk '{print $1}')
else
    echo "No exited containers to clean up"
fi
