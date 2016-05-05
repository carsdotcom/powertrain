#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
RUN_SCRIPT=${ARGS[9]}
VERSION_SCRIPT=${ARGS[10]}

source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "RESTART" ${ARGS[4]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "PORTS" ${ARGS[5]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "VOLUMES" ${ARGS[6]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "ENVS" ${ARGS[7]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LABELS" ${ARGS[8]}

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

# trim leading and trailing whitespace
BASEFLAGS="$(echo -e "${BASEFLAGS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

for ((i=1; i<=$INSTANCES; i++)); do

    PORTFLAGS=""

    if [ -n "$PORTS" ]; then
        IFS=',' read -ra APORTS <<< "$PORTS"
        for PORT in "${APORTS[@]}"; do
            if [[ ${PORT:0:1} == ":" ]]; then
                NEXT_PORT=
                PORT=${PORT:1}
            elif [[ $PORT == *":"* ]]; then
                source $POWERTRAIN_DIR/var/NEXT_PORT.sh $(echo $PORT | cut -d':' -f1)
                PORT=$(echo $PORT | cut -d':' -f2)
            else
                source $POWERTRAIN_DIR/var/NEXT_PORT.sh $PORT
            fi
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
