#!/bin/bash
if [ "$2" == "default" ]; then
    eval "$1=$3"
elif [ -n "$2" ]; then
    eval "$1=$2"
fi
