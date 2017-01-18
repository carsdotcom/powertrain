#!/bin/bash
get_mount_target() {
    local mount=$1 target=""
    IFS=',' read -ra MOUNT_OPTS <<< "$mount"
    for MOUNT_OPT in "${MOUNT_OPTS[@]}"; do
        if [[ $MOUNT_OPT == target* ]]; then
            target=$(echo ${MOUNT_OPT##*=})
            break;
        fi
    done
    echo $target
}

source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 23

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
source $POWERTRAIN_DIR/var/DEFAULT.sh "CONTAINER_LABELS" ${ARGS[19]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "UPDATE_FAILURE_ACTION" ${ARGS[20]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "USR" ${ARGS[21]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "WORK_DIR" ${ARGS[22]}

# Check if this service already exists in the cluster
SRV_EXISTS=($(docker service ls -f "name=${ARGS[0]}" | awk 'NR>1 {print $1}'))

if [ -n "$SRV_EXISTS" ]; then
    source $POWERTRAIN_DIR/var/EXISTING_SERVICE_SPEC.sh ${ARGS[0]}
fi

BASEFLAGS=""

if [ -n "$USR" ]; then
    BASEFLAGS="$BASEFLAGS -u $USR"
fi

if [ -n "$WORK_DIR" ]; then
    BASEFLAGS="$BASEFLAGS -w $WORK_DIR"
fi

if [ -z "$SRV_EXISTS" ];then
    if [ -n "$LIMIT_MEM" ]; then
        BASEFLAGS="$BASEFLAGS --limit-memory $LIMIT_MEM"
    fi
fi

if [ -z "$SRV_EXISTS" ];then
    if [ -n "$LIMIT_CPU" ]; then
        BASEFLAGS="$BASEFLAGS --limit-cpu $LIMIT_CPU"
    fi
fi

if [ -z "$SRV_EXISTS" ];then
    if [ -n "$RESERVE_MEM" ]; then
        BASEFLAGS="$BASEFLAGS --reserve-memory $RESERVE_MEM"
    fi
fi

if [ -z "$SRV_EXISTS" ];then
    if [ -n "$RESERVE_CPU" ]; then
        BASEFLAGS="$BASEFLAGS --reserve-cpu $RESERVE_CPU"
    fi
fi

if [ -z "$SRV_EXISTS" ];then
    if [ -n "$SERVICE_MODE" ]; then
        BASEFLAGS="$BASEFLAGS --mode $SERVICE_MODE"
    fi
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

## Not processing mounts for existing services for now
## See Docker issue - https://github.com/docker/docker/issues/25772
if [ -n "$SRV_EXISTS" ]; then
    if [ -n "$MOUNTS" ]; then
        MOUNT_TARGETS=()
        IFS=',' read -ra AMOUNTS <<< "$MOUNTS"
        for MOUNT in "${AMOUNTS[@]}"; do
            ESCAPED=$(echo $MOUNT | sed -e 's/!!/,/g')
            MOUNT_TARGETS+=($(get_mount_target "$ESCAPED"))
            if [ -n "$SRV_EXISTS" ]; then
                BASEFLAGS="$BASEFLAGS --mount-add $ESCAPED"
            else
                BASEFLAGS="$BASEFLAGS --mount $ESCAPED"
            fi
        done
        ## Remove mounts which are not in the supplied spec
        if [ -n "$SRV_EXISTS" ]; then
            for E_MOUNT in "${E_MOUNTS[@]}"; do
                if ! array_contains MOUNT_TARGETS $E_MOUNT; then
                    BASEFLAGS="$BASEFLAGS --mount-rm $E_MOUNT"
                fi
            done
        fi
    fi
fi

if [ -n "$PUBLISHED_PORTS" ]; then
    TARGET_PORTS=()
    IFS=',' read -ra APORTS <<< "$PUBLISHED_PORTS"
    for PORT in "${APORTS[@]}"; do
        TARGET_PORTS+=($(echo ${PORT##*:}))
        if [ -n "$SRV_EXISTS" ]; then
            BASEFLAGS="$BASEFLAGS --publish-add $PORT"
        else
            BASEFLAGS="$BASEFLAGS -p $PORT"
        fi    
    done
    ## Remove ports which are not in the supplied spec
    if [ -n "$SRV_EXISTS" ]; then
        for E_PORT in "${E_PORTS[@]}"; do
            if ! array_contains TARGET_PORTS $E_PORT; then
                BASEFLAGS="$BASEFLAGS --publish-rm $E_PORT"
            fi
        done
    fi
fi

# Cannot add networks to an existing service
if [ -z "$SRV_EXISTS" ]; then
    if [ -n "$NETWORKS" ]; then
        IFS=',' read -ra ANETWORKS <<< "$NETWORKS"
        for NETWORK in "${ANETWORKS[@]}"; do
            BASEFLAGS="$BASEFLAGS --network $NETWORK"
        done
    fi
fi

if [ -n "$ENVS" ]; then
    ENV_NAMES=()
    IFS=',' read -ra AENVS <<< "$ENVS"
    for EN in "${AENVS[@]}"; do
        ENV_NAMES+=($(echo "$EN" | sed 's/=.*//'))
        if [ -n "$SRV_EXISTS" ]; then
            BASEFLAGS="$BASEFLAGS --env-add $EN"
        else
            BASEFLAGS="$BASEFLAGS -e $EN"
        fi    
    done
    ## Remove service labels which are not in the supplied spec
    if [ -n "$SRV_EXISTS" ]; then
        for E_ENV in "${E_ENVS[@]}"; do
            if ! array_contains ENV_NAMES $E_ENV; then
                BASEFLAGS="$BASEFLAGS --env-rm $E_ENV"
            fi
        done
    fi
fi

if [ -n "$LABELS" ]; then
    LABEL_NAMES=()
    IFS=',' read -ra ALABELS <<< "$LABELS"
    for LABEL in "${ALABELS[@]}"; do
        LABEL_NAMES+=($(echo "$LABEL" | sed 's/=.*//'))
        if [ -n "$SRV_EXISTS" ]; then
            BASEFLAGS="$BASEFLAGS --label-add $LABEL"
        else
            BASEFLAGS="$BASEFLAGS -l $LABEL"
        fi        
    done
    ## Remove service labels which are not in the supplied spec
    if [ -n "$SRV_EXISTS" ]; then
        for E_SRV_LABEL in "${E_SRV_LABELS[@]}"; do
            if ! array_contains LABEL_NAMES $E_SRV_LABEL; then
                BASEFLAGS="$BASEFLAGS --label-rm $E_SRV_LABEL"
            fi
        done
    fi
fi

if [ -n "$CONTAINER_LABELS" ]; then
    CONTAINER_LABEL_NAMES=()
    IFS=',' read -ra ACONTAINER_LABELS <<< "$CONTAINER_LABELS"
    for LABEL in "${ACONTAINER_LABELS[@]}"; do
        ## Add just the label name to the array
        CONTAINER_LABEL_NAMES+=($(echo "$LABEL" | sed 's/=.*//'))
        if [ -n "$SRV_EXISTS" ]; then
            BASEFLAGS="$BASEFLAGS --container-label-add $LABEL"            
        else
            BASEFLAGS="$BASEFLAGS --container-label $LABEL"
        fi            
    done
    ## Remove container labels which are not in the supplied spec
    if [ -n "$SRV_EXISTS" ]; then
        for E_CONTAINER_LABEL in "${E_CONTAINER_LABELS[@]}"; do
            if ! array_contains CONTAINER_LABEL_NAMES $E_CONTAINER_LABEL; then
                BASEFLAGS="$BASEFLAGS --container-label-rm $E_CONTAINER_LABEL"
            fi
        done
    fi
fi

if [ -n "$UPDATE_FAILURE_ACTION" ]; then
    BASEFLAGS="$BASEFLAGS --update-failure-action $UPDATE_FAILURE_ACTION"
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
    CONSTRAINT_NAMES=()
    IFS=',' read -ra ACONSTRAINTS <<< "$CONSTRAINTS"
    for CONSTRAINT in "${ACONSTRAINTS[@]}"; do
        CONSTRAINT_NAMES+=($(echo "$CONSTRAINT" | sed 's/==.*//'))
        if [ -n "$SRV_EXISTS" ]; then
            BASEFLAGS="$BASEFLAGS --constraint-add $CONSTRAINT"
        else
            BASEFLAGS="$BASEFLAGS --constraint $CONSTRAINT"
        fi
    done
    ## Remove constraints which are not in the supplied spec
    if [ -n "$SRV_EXISTS" ]; then
        for E_CONTSTRAINT in "${E_CONTSTRAINTS[@]}"; do
            if ! array_contains CONSTRAINT_NAMES $E_CONTSTRAINT; then
                BASEFLAGS="$BASEFLAGS --constraint-rm $E_CONTSTRAINT"
            fi
        done
    fi
fi

if [ -z "$SRV_EXISTS" ];then
    BASEFLAGS="$BASEFLAGS --name ${ARGS[0]}"
fi

# trim leading and trailing whitespace
BASEFLAGS="$(echo -e "${BASEFLAGS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

if [ -n "$SRV_EXISTS" ]; then
    echo "Running service update command..."
    echo "docker service update $BASEFLAGS --image $REGISTRY""$IMAGE ${ARGS[0]}"
    docker service update $BASEFLAGS --image $REGISTRY""$IMAGE ${ARGS[0]}
else
    echo "Running service command..."
    echo "docker service create $BASEFLAGS $REGISTRY""$IMAGE"

    docker service create $BASEFLAGS $REGISTRY""$IMAGE
fi

