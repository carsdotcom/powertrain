#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
source $POWERTRAIN_DIR/var/MACHINE_NAME.sh ${ARGS[0]}
source $POWERTRAIN_DIR/var/MACHINE_ALIAS.sh ${ARGS[1]}
source $POWERTRAIN_DIR/var/MACHINE_PORT.sh ${ARGS[2]}

FORWARD=$(VBoxManage showvminfo $MACHINE_NAME --details | grep "host port = $MACHINE_PORT")
if [[ "$?" == "1" ]]; then
    echo "Adding port forward for port $MACHINE_PORT on machine $MACHINE_NAME with alias $MACHINE_ALIAS"
    VBoxManage modifyvm "$MACHINE_NAME" --natpf1 "$MACHINE_ALIAS,tcp,,$MACHINE_PORT,,$MACHINE_PORT"
fi
