#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
EXTRACT_SRC=${ARGS[4]}
EXTRACT_DEST=${ARGS[5]}
VERSION_SCRIPT=${ARGS[6]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}

CMD=""
IFS=',' read -ra ASRC <<< "$EXTRACT_SRC"
for SRC in "${ASRC[@]}"; do
    CMD="${CMD}docker cp \$0:$SRC $EXTRACT_DEST;echo \$0;"
done

docker run -d $REGISTRY""$IMAGE | xargs -- bash -c "${CMD}echo \$0" | xargs docker stop
