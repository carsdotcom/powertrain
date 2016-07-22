#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 10

source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "PUBLISHED_PORT" ${ARGS[4]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "ENVS" ${ARGS[5]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LABELS" ${ARGS[6]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "UPDATE_DELAY" ${ARGS[7]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "PARALLEL_UPDATES" ${ARGS[8]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "CONSTRAINTS" ${ARGS[9]}


BASEFLAGS=""

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

if [ -n "$PUBLISHED_PORT" ]; then
    BASEFLAGS="$BASEFLAGS -p $PUBLISHED_PORT"
fi

if [ -n "$UPDATE_DELAY" ]; then
    BASEFLAGS="$BASEFLAGS --update-delay $UPDATE_DELAY"
fi

if [ -n "$PARALLEL_UPDATES" ]; then
    BASEFLAGS="$BASEFLAGS --update-parallelism $PARALLEL_UPDATES"
fi

if [ -n "$INSTANCES" ]; then
    BASEFLAGS="$BASEFLAGS --replicas $INSTANCES"
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

