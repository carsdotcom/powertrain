#!/bin/bash
if [ "$1" == "default" ]; then
    REGISTRY=
elif [ -n "$1" ]; then
    REGISTRY="$1/"
fi
