#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
VERSION_SCRIPT=${ARGS[6]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}
source $POWERTRAIN_DIR/var/EXTRACT_SRC.sh ${ARGS[4]}
source $POWERTRAIN_DIR/var/EXTRACT_DEST.sh ${ARGS[5]}

if [ "$EXTRACT_DIR" == "$POWERTRAIN_DIR" ]; then
    printf "\nEXTRACT_DEST cannot be powertrain directory. Exiting...\n\n"
    exit 1
fi

CMD=""
IFS=',' read -ra ASRC <<< "$EXTRACT_SRC"
for SRC in "${ASRC[@]}"; do
    CMD="${CMD}docker cp \$0:$SRC $EXTRACT_DEST;echo \$0;"
done

docker run -d $REGISTRY""$IMAGE | xargs -- bash -c "${CMD}echo \$0" | xargs docker stop
