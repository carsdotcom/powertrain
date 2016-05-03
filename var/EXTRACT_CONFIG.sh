#!/bin/bash
if [ "$1" == "default" ]; then
    EXTRACT_CONFIG=
elif [ -n "$1" ]; then
    EXTRACT_CONFIG=$1
fi
