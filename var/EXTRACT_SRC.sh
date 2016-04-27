#!/bin/bash
if [ "$1" == "default" ]; then
    EXTRACT_SRC=
elif [ -n "$1" ]; then
    EXTRACT_SRC=$1
fi
