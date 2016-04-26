#!/bin/bash
if [ "$1" == "default" ]; then
    RESTART=
elif [ -n "$1" ]; then
    RESTART=$1
fi
