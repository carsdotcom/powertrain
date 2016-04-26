#!/bin/bash
if [ "$1" == "default" ]; then
    ENVS=
elif [ -n "$1" ]; then
    ENVS=$1
fi
