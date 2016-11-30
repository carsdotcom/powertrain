#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 19

source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "PUBLISHED_PORTS" ${ARGS[4]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "ENVS" ${ARGS[5]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LABELS" ${ARGS[6]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "UPDATE_DELAY" ${ARGS[7]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "PARALLEL_UPDATES" ${ARGS[8]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "CONSTRAINTS" ${ARGS[9]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "NETWORKS" ${ARGS[10]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "SERVICE_MODE" ${ARGS[11]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LIMIT_CPU" ${ARGS[12]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LIMIT_MEM" ${ARGS[13]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "RESERVE_CPU" ${ARGS[14]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "RESERVE_MEM" ${ARGS[15]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "MOUNTS" ${ARGS[16]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LOG_DRIVER" ${ARGS[17]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LOG_OPTS" ${ARGS[18]}


BASEFLAGS=""

if [ -n "$LIMIT_MEM" ]; then
    BASEFLAGS="$BASEFLAGS --limit-memory $LIMIT_MEM"
fi

if [ -n "$LIMIT_CPU" ]; then
    BASEFLAGS="$BASEFLAGS --limit-cpu $LIMIT_CPU"
fi

if [ -n "$RESERVE_MEM" ]; then
    BASEFLAGS="$BASEFLAGS --reserve-memory $RESERVE_MEM"
fi

if [ -n "$RESERVE_CPU" ]; then
    BASEFLAGS="$BASEFLAGS --reserve-cpu $RESERVE_CPU"
fi

if [ -n "$SERVICE_MODE" ]; then
    BASEFLAGS="$BASEFLAGS --mode $SERVICE_MODE"
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

if [ -n "$MOUNTS" ]; then
    IFS=',' read -ra AMOUNTS <<< "$MOUNTS"
    for MOUNT in "${AMOUNTS[@]}"; do
        ESCAPED=$(echo $MOUNT | sed -e 's/!!/,/g')
        BASEFLAGS="$BASEFLAGS --mount $ESCAPED"
    done
fi

if [ -n "$PUBLISHED_PORTS" ]; then
    IFS=',' read -ra APORTS <<< "$PUBLISHED_PORTS"
    for PORT in "${APORTS[@]}"; do
        BASEFLAGS="$BASEFLAGS -p $PORT"
    done
fi

if [ -n "$NETWORKS" ]; then
    IFS=',' read -ra ANETWORKS <<< "$NETWORKS"
    for NETWORK in "${ANETWORKS[@]}"; do
        BASEFLAGS="$BASEFLAGS --network $NETWORK"
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

if [ -n "$UPDATE_DELAY" ]; then
    BASEFLAGS="$BASEFLAGS --update-delay $UPDATE_DELAY"
fi

if [ -n "$PARALLEL_UPDATES" ]; then
    BASEFLAGS="$BASEFLAGS --update-parallelism $PARALLEL_UPDATES"
fi

if [ -n "$INSTANCES" ]; then
    if [ "$SERVICE_MODE" == 'global' ]; then
        echo "WARN: Service is configured to run in global mode. Ignoring INSTANCES"
    else
        BASEFLAGS="$BASEFLAGS --replicas $INSTANCES"
    fi    
fi

if [ -n "$CONSTRAINTS" ]; then
    IFS=',' read -ra ACONSTRAINTS <<< "$CONSTRAINTS"
    for CONSTRAINT in "${ACONSTRAINTS[@]}"; do
        BASEFLAGS="$BASEFLAGS --constraint $CONSTRAINT"
    done
fi

BASEFLAGS="$BASEFLAGS --name ${ARGS[0]}"
# trim leading and trailing whitespace
BASEFLAGS="$(echo -e "${BASEFLAGS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

# Check if this service already exists in the cluster
SRV_EXISTS=($(docker service ls -f "name=${ARGS[0]}" | awk 'NR>1 {print $1}'))

if [ -n "$SRV_EXISTS" ]; then
    echo "Running service update command..."
    echo "docker service update $BASEFLAGS --image $REGISTRY""$IMAGE ${ARGS[0]}"
    docker service update $BASEFLAGS --image $REGISTRY""$IMAGE ${ARGS[0]}
else
    echo "Running service command..."
    echo "docker service create $BASEFLAGS $REGISTRY""$IMAGE"

    docker service create $BASEFLAGS $REGISTRY""$IMAGE
fi

