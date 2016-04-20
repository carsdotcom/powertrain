#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
PRE_BUILD_SCRIPT=${ARGS[0]}
if [ -n "$PRE_BUILD_SCRIPT" ] && [ "$PRE_BUILD_SCRIPT" != "default" ]; then
    $PRE_BUILD_SCRIPT
fi
