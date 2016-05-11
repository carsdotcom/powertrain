#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 1
VALIDATE_SCRIPT=${ARGS[0]}
if [ -n "$VALIDATE_SCRIPT" ] && [ "$VALIDATE_SCRIPT" != "default" ]; then
    $VALIDATE_SCRIPT $SEMVER
fi
