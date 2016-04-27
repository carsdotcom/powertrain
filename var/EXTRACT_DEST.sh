#!/bin/bash
if [ "$1" == "default" ]; then
    EXTRACT_DEST=$(pwd)
elif [ -n "$1" ]; then
    EXTRACT_DEST=$1
fi
