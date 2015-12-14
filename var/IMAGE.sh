#!/bin/bash
source $POWERTRAIN_DIR/var/NAME.sh $1
source $POWERTRAIN_DIR/var/VERSION.sh $2
if [ "$VERSION" == "" ]; then
    IMAGE="$NAME"
else
    IMAGE="$NAME:$VERSION"
fi
