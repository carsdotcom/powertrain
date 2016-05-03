#!/bin/bash
if [ "$1" == "default" ]; then
    EXTRACT_ROOT=
elif [ -n "$1" ]; then
    EXTRACT_ROOT="$1/"
fi
