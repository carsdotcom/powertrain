#!/bin/bash
if [ "$1" == "all" ]; then
    NAME=
elif [ -z "$1" ] || [ "$1" == "default" ]; then
    NAME=powertrain
elif [ -n "$1" ]; then
    NAME=$1
fi
