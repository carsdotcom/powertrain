#!/bin/bash
pushd $PT_CONTEXT > /dev/null
if [ "$1" == "all" ]; then
    VERSION=
elif [ -z "$1" ] || [ "$1" == "default" ]; then
    if [ "$VERSION_SCRIPT" == "" ] || [ "$VERSION_SCRIPT" == "default" ]; then
         HEAD="$(git rev-parse HEAD 2>&1)"
         if [[ $HEAD =~ ^[0-9a-f]{5,40}$ ]]; then
            VERSION=$HEAD
        else
            VERSION=latest
        fi
    else
        VERSION=$($VERSION_SCRIPT)
    fi
elif [ -n "$1" ]; then
    VERSION=$1
fi
popd > /dev/null
