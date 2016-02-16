#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/VERSION.sh ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
IMAGES="$(docker images | tail -n +2 | grep -v "${REGISTRY}${NAME}.*${VERSION}")"
if [ -n "$IMAGES" ]; then
    echo "Removing the following images:"
    printf "$IMAGES"
    printf "$IMAGES" | awk '{print $3}' | xargs docker rmi -f
fi
