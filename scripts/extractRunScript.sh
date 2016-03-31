#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
RUN_SCRIPT=${ARGS[4]}
VERSION_SCRIPT=${ARGS[5]}
TARGET_DIR=${ARGS[6]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}

docker run -d $REGISTRY""$IMAGE | xargs -- env t="$TARGET_DIR" r="$RUN_SCRIPT" bash -c 'docker cp $0:$r $t;echo $0' | xargs docker stop
