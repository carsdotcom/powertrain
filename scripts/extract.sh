#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 9
VERSION_SCRIPT=${ARGS[8]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/VERSION.sh ${ARGS[1]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}
source $POWERTRAIN_DIR/var/EXTRACT_ROOT.sh ${ARGS[4]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "EXTRACT_SRC" ${ARGS[5]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "EXTRACT_DEST" ${ARGS[6]} $ENTRY_DIR
source $POWERTRAIN_DIR/var/DEFAULT.sh "EXTRACT_CONFIG" ${ARGS[7]}

if [ "$EXTRACT_DEST" == "$POWERTRAIN_DIR" ]; then
    printf "\nEXTRACT_DEST cannot be powertrain directory. Exiting...\n\n"
    exit 1
fi

mkdir -p $EXTRACT_DEST

if [ -n "$EXTRACT_CONFIG" ]; then
    [ -z "$EXTRACT_ROOT" ] && echo "EXTRACT_ROOT must be set when extracting config" && exit 1
    if [ -n "$EXTRACT_SRC" ]; then
        EXTRACT_SRC="$EXTRACT_SRC,powertrain.mk"
    else
        EXTRACT_SRC="powertrain.mk"
    fi
    EXTRACT_SRC="${EXTRACT_SRC},powertrain/"
fi

CMD=""
IFS=',' read -ra ASRC <<< "$EXTRACT_SRC"
for SRC in "${ASRC[@]}"; do
    CMD="${CMD}docker cp \$0:${EXTRACT_ROOT}${SRC} $EXTRACT_DEST;"
done

[ -f "$EXTRACT_DEST/powertrain_runtime_config.mk" ] && rm $EXTRACT_DEST/powertrain_runtime_config.mk
[ -n "$NAME" ] && echo "NAME=${ARGS[0]}" >> $EXTRACT_DEST/powertrain_runtime_config.mk
[ -n "$VERSION" ] && echo "VERSION=${ARGS[1]}" >> $EXTRACT_DEST/powertrain_runtime_config.mk
[ -n "$REGISTRY" ] && echo "REGISTRY=${ARGS[2]}" >> $EXTRACT_DEST/powertrain_runtime_config.mk

docker run -d $REGISTRY""$IMAGE | xargs -- bash -c "${CMD} echo \$0" 2>/dev/null | xargs docker stop
