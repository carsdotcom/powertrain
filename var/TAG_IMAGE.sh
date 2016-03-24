#!/bin/bash
if [ "$2" == "" ]; then
    TAG_IMAGE="$1"
else
    TAG_IMAGE="$1:$2"
fi
