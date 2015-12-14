#!/bin/bash
source $POWERTRAIN_DIR/var/ARGS.sh
source $POWERTRAIN_DIR/var/SEMVER.sh ${ARGS[0]}
BUMP_SCRIPT=${ARGS[1]}
if [ -n "$BUMP_SCRIPT" ] && [ "$BUMP_SCRIPT" != "default" ]; then
    $BUMP_SCRIPT $SEMVER
fi
