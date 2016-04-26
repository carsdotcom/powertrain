#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
RUN_SCRIPT=${ARGS[9]}
VERSION_SCRIPT=${ARGS[10]}

source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}
source $POWERTRAIN_DIR/var/RESTART.sh ${ARGS[4]}
source $POWERTRAIN_DIR/var/PORTS.sh ${ARGS[5]}
source $POWERTRAIN_DIR/var/VOLUMES.sh ${ARGS[6]}
source $POWERTRAIN_DIR/var/ENVS.sh ${ARGS[7]}
source $POWERTRAIN_DIR/var/LABELS.sh ${ARGS[8]}

BASEFLAGS=""

if [ -n "$RESTART" ]; then
    BASEFLAGS="$BASEFLAGS --restart=$RESTART"
fi

if [ -n "$VOLUMES" ]; then
    IFS=',' read -ra AVOLUMES <<< "$VOLUMES"
    for VOLUME in "${AVOLUMES[@]}"; do
        BASEFLAGS="$BASEFLAGS -v $VOLUME"
    done
fi

if [ -n "$ENVS" ]; then
    IFS=',' read -ra AENVS <<< "$ENVS"
    for EN in "${AENVS[@]}"; do
        BASEFLAGS="$BASEFLAGS -e $EN"
    done
fi

if [ -n "$LABELS" ]; then
    IFS=',' read -ra ALABELS <<< "$LABELS"
    for LABEL in "${ALABELS[@]}"; do
        BASEFLAGS="$BASEFLAGS -l $LABEL"
    done
fi

for ((i=1; i<=$INSTANCES; i++)); do

    PORTFLAGS=""

    if [ -n "$PORTS" ]; then
        IFS=',' read -ra APORTS <<< "$PORTS"
        for PORT in "${APORTS[@]}"; do
            source $POWERTRAIN_DIR/var/NEXT_PORT.sh $PORT
            PORTFLAGS="$PORTFLAGS -p $NEXT_PORT:$PORT"
        done
    fi

    if [ "$RUN_SCRIPT" == "" ] || [ "$RUN_SCRIPT" == "default" ]; then
        echo "Running default run command..."
        docker run -d $BASEFLAGS $PORTFLAGS $REGISTRY""$IMAGE
    else
        echo "Running \"$RUN_SCRIPT\"..."
        $RUN_SCRIPT $REGISTRY""$IMAGE "$BASEFLAGS $PORTFLAGS"
    fi

done
