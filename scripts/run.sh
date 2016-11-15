#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 16
RUN_SCRIPT=${ARGS[14]}
VERSION_SCRIPT=${ARGS[15]}

source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "NET" ${ARGS[4]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "RESTART" ${ARGS[5]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "EXPOSE" ${ARGS[6]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "PORTS" ${ARGS[7]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "VOLUMES" ${ARGS[8]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "ENVS" ${ARGS[9]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LABELS" ${ARGS[10]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LOG_DRIVER" ${ARGS[11]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LOG_OPTS" ${ARGS[12]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "HOSTS" ${ARGS[13]}

BASEFLAGS=""

if [ -n "$NET" ]; then
    BASEFLAGS="$BASEFLAGS --net=$NET"
fi

if [ -n "$RESTART" ]; then
    BASEFLAGS="$BASEFLAGS --restart=$RESTART"
fi

if [ -n "$EXPOSE" ]; then
    BASEFLAGS="$BASEFLAGS --expose=$EXPOSE"
fi

if [ -n "$HOSTS" ]; then
    IFS=',' read -ra AHOSTS <<< "$HOSTS"
    for HOST in "${AHOSTS[@]}"; do
        ESCAPED=$(echo $HOST | sed -e 's/!!/,/g')
        BASEFLAGS="$BASEFLAGS --add-host $ESCAPED"
    done
fi

if [ -n "$VOLUMES" ]; then
    IFS=',' read -ra AVOLUMES <<< "$VOLUMES"
    for VOLUME in "${AVOLUMES[@]}"; do
        ESCAPED=$(echo $VOLUME | sed -e 's/!!/,/g')
        BASEFLAGS="$BASEFLAGS -v $ESCAPED"
    done
fi

if [ -n "$ENVS" ]; then
    IFS=',' read -ra AENVS <<< "$ENVS"
    for EN in "${AENVS[@]}"; do
        ESCAPED=$(echo $EN | sed -e 's/!!/,/g')
        BASEFLAGS="$BASEFLAGS -e $ESCAPED"
    done
fi

if [ -n "$LABELS" ]; then
    IFS=',' read -ra ALABELS <<< "$LABELS"
    for LABEL in "${ALABELS[@]}"; do
        ESCAPED=$(echo $LABEL | sed -e 's/!!/,/g')
        BASEFLAGS="$BASEFLAGS -l $ESCAPED"
    done
fi

if [ -n "$LOG_DRIVER" ]; then
    BASEFLAGS="$BASEFLAGS --log-driver=$LOG_DRIVER"
fi

if [ -n "$LOG_OPTS" ]; then
    IFS=',' read -ra ALOG_OPTS <<< "$LOG_OPTS"
    for LOG_OPT in "${ALOG_OPTS[@]}"; do
        ESCAPED=$(echo $LOG_OPT | sed -e 's/!!/,/g')
        BASEFLAGS="$BASEFLAGS --log-opt $ESCAPED"
    done
fi

# trim leading and trailing whitespace
BASEFLAGS="$(echo -e "${BASEFLAGS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

for ((i=1; i<=$INSTANCES; i++)); do

    PORTFLAGS=""
    USED_PORTS=""

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
            USED_PORTS="$USED_PORTS,$NEXT_PORT"
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
        USED_PORTS=$(printf "%s\n" ${USED_PORTS[@]}|sort)
        $RUN_SCRIPT $REGISTRY""$IMAGE "$BASEFLAGS $PORTFLAGS" "$USED_PORTS"
    fi

done
