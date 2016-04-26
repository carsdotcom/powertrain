#!/bin/bash
if [ "$1" == "default" ]; then
    PORTS=
elif [ -n "$1" ]; then
    PORTS=$1
fi
