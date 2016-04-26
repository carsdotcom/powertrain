#!/bin/bash
if [ "$1" == "default" ]; then
    VOLUMES=
elif [ -n "$1" ]; then
    VOLUMES=$1
fi
