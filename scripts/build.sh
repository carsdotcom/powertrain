#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 6
VERSION_SCRIPT=${ARGS[4]}
PT_CONTEXT=${ARGS[5]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "DOCKERFILE" ${ARGS[3]}
echo "Building \"$REGISTRY""$IMAGE\"..."

if [ -n "$DOCKERFILE" ]; then
    DOCKERFILE_FLAG="-f $DOCKERFILE"
fi

docker build $DOCKERFILE_FLAG -t $REGISTRY""$IMAGE $PT_CONTEXT
