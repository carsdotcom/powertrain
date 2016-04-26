#!/bin/bash
if [ "$1" == "default" ]; then
    LABELS=
elif [ -n "$1" ]; then
    LABELS=$1
fi
