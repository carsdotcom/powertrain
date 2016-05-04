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

# if [ -n "$PT_CONFIG" ] && [ -f "${PT_CONTEXT}/powertrain/${PT_CONFIG}.env" ]; then
#     while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
#         VARNAME=$(echo $LINE | cut -d'=' -f1)
#         if [ -z "${!VARNAME}" ]; then
#             $LINE
#         fi
#     done < "$PT_CONTEXT/powertrain/${PT_CONFIG}.env"
# fi

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

# trim leading and trailing whitespace
BASEFLAGS="$(echo -e "${BASEFLAGS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

for ((i=1; i<=$INSTANCES; i++)); do

    PORTFLAGS=""

    if [ -n "$PORTS" ]; then
        IFS=',' read -ra APORTS <<< "$PORTS"
        for PORT in "${APORTS[@]}"; do
            source $POWERTRAIN_DIR/var/NEXT_PORT.sh $PORT
            PORTFLAGS="$PORTFLAGS -p $NEXT_PORT:$PORT"
        done
    fi

    # trim leading and trailing whitespace
    PORTFLAGS="$(echo -e "${PORTFLAGS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

    if [ "$RUN_SCRIPT" == "" ] || [ "$RUN_SCRIPT" == "default" ]; then
        echo "Running default run command..."
        echo "docker run -d $BASEFLAGS $PORTFLAGS $REGISTRY""$IMAGE"
        docker run -d $BASEFLAGS $PORTFLAGS $REGISTRY""$IMAGE
    else
        echo "Running \"$RUN_SCRIPT\"..."
        echo "$RUN_SCRIPT $REGISTRY""$IMAGE \"$BASEFLAGS $PORTFLAGS\""
        $RUN_SCRIPT $REGISTRY""$IMAGE "$BASEFLAGS $PORTFLAGS"
    fi

done
