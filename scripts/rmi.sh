#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/VERSION.sh ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
echo "Removing the following images:"
echo "$(docker images | grep "${REGISTRY}${NAME}.*${VERSION}")"
docker images | grep "${REGISTRY}${NAME}.*${VERSION}" | awk '{print $3}' | xargs docker rmi -f
