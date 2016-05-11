#!/bin/bash
pushd $PT_CONTEXT
source $POWERTRAIN_DIR/var/ARGS.sh
enforce_args_length 2
source $POWERTRAIN_DIR/var/SEMVER.sh ${ARGS[0]}
BUMP_SCRIPT=${ARGS[1]}
if [ -n "$BUMP_SCRIPT" ] && [ "$BUMP_SCRIPT" != "default" ]; then
    $BUMP_SCRIPT $SEMVER
fi
popd
