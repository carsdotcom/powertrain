#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 2
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[1]}
IMAGES="$(docker images -f "dangling=true"| grep $REGISTRY""$NAME)"
if [ -n "$IMAGES" ]; then
    echo "Cleaning up dangling images"
    docker rmi -f $(printf "$IMAGES" | awk '{print $3}')
else
    echo "No dangling images to clean up"
fi
