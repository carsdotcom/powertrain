#!/bin/bash
if [ "$1" == "default" ]; then
    EXTRACT_DEST=$ENTRY_DIR
elif [ -n "$1" ]; then
    EXTRACT_DEST=$1
fi
