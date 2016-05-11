#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 4
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/VERSION.sh ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
IMAGES="$(docker images | grep "${REGISTRY}${NAME}.*${VERSION}")"
if [ -n "$IMAGES" ]; then
    echo "Images matching \"$REGISTRY""$NAME:$VERSION\"..."
    printf "$IMAGES\n"
fi
