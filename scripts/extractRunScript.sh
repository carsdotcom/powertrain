#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
RUN_SCRIPT=${ARGS[4]}
VERSION_SCRIPT=${ARGS[5]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}

docker run -d $REGISTRY""$IMAGE | xargs -- env r="$RUN_SCRIPT" bash -c 'docker cp $0:$r ./;echo $0' | xargs docker stop
