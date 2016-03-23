#!/bin/bash
if [ -z "$1" ] || [ "$1" == "default" ]; then
    DEFAULT_PORT=
elif [ -n "$1" ]; then
    DEFAULT_PORT=$1
fi
