#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 6
VERSION_SCRIPT=${ARGS[3]}
source $POWERTRAIN_DIR/var/NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/IMAGE.sh ${ARGS[0]} ${ARGS[1]}
source $POWERTRAIN_DIR/var/REGISTRY.sh ${ARGS[2]}
source $POWERTRAIN_DIR/var/INSTANCES.sh ${ARGS[4]}
source $POWERTRAIN_DIR/var/DEFAULT.sh "LABELS" ${ARGS[5]}

ENV=""

if [ -n "$LABELS" ]; then
    IFS=',' read -ra ALABELS <<< "$LABELS"
    for LABEL in "${ALABELS[@]}"; do
        ESCAPED=$(echo $LABEL | sed -e 's/!!/,/g')
        IFS="=" read -ra KV <<< "$ESCAPED"
        if [ "${KV[0]}" == "ENV" ];then
          ENV="${KV[1]}"
        fi
    done
fi

TOTAL_INSTANCES=""
if [ -n "$ENV" ];then
  echo "ENV label set to $ENV"
  TOTAL_INSTANCES="$(docker ps -f label=ENV="$ENV" | grep "$REGISTRY""$NAME": | wc -l | awk '{print $1}')"
else
  TOTAL_INSTANCES="$(docker ps | grep "$REGISTRY""$NAME": | wc -l | awk '{print $1}')"
fi

OLD_INSTANCES=$((TOTAL_INSTANCES - INSTANCES))

if [ "$OLD_INSTANCES" -ge 0 ]; then
    CONTAINERS=""
    if [ -n "$ENV" ];then
      CONTAINERS="$(docker ps -f label=ENV="$ENV" | grep "$REGISTRY""$NAME": | awk '{print $1}' | xargs docker inspect -f "{{.Created}} {{.Id}}" | sort -r | tail -n +$((INSTANCES + 1)))"
    else
      CONTAINERS="$(docker ps | grep "$REGISTRY""$NAME": | awk '{print $1}' | xargs docker inspect -f "{{.Created}} {{.Id}}" | sort -r | tail -n +$((INSTANCES + 1)))"
    fi
    if [ -n "$CONTAINERS" ]; then
        echo "Stopping the following containers:"
        docker stop $(printf "$CONTAINERS" | awk '{print $2}')
    fi
else
    echo "No containers to stop."
fi
