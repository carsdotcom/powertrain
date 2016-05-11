#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 1
POST_BUILD_SCRIPT=${ARGS[0]}
if [ -n "$POST_BUILD_SCRIPT" ] && [ "$POST_BUILD_SCRIPT" != "default" ]; then
    $POST_BUILD_SCRIPT
fi
