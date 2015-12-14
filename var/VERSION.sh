#!/bin/bash
if [ "$1" == "all" ]; then
    VERSION=
elif [ -z "$1" ] || [ "$1" == "default" ]; then
    if [ "$VERSION_SCRIPT" == "" ] || [ "$VERSION_SCRIPT" == "default" ]; then
        VERSION=latest
    else
        VERSION=$($VERSION_SCRIPT)
    fi
elif [ -n "$1" ]; then
    VERSION=$1
fi
