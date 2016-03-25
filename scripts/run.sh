#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
RUN_SCRIPT=${ARGS[5]}
VERSION_SCRIPT=${ARGS[6]}

source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[3]}
source $POWERTRAIN_DIR/var/DEFAULT_PORT.sh ${ARGS[4]}

for ((i=1; i<=$INSTANCES; i++)); do

    if [ -n "$DEFAULT_PORT" ]; then

        source $POWERTRAIN_DIR/var/NEXT_PORT.sh $DEFAULT_PORT $NEXT_PORT

        if [ "$RUN_SCRIPT" == "" ] || [ "$RUN_SCRIPT" == "default" ]; then
            echo "Running default run command..."
            docker run -d -p $NEXT_PORT:$DEFAULT_PORT $REGISTRY""$IMAGE
        else
            echo "Running \"$RUN_SCRIPT\"..."
            $RUN_SCRIPT $REGISTRY""$IMAGE $NEXT_PORT $DEFAULT_PORT
        fi

    else

        if [ "$RUN_SCRIPT" == "" ] || [ "$RUN_SCRIPT" == "default" ]; then
            echo "Running default run command..."
            docker run -d $REGISTRY""$IMAGE
        else
            echo "Running \"$RUN_SCRIPT\"..."
            $RUN_SCRIPT $REGISTRY""$IMAGE
        fi

    fi

done
