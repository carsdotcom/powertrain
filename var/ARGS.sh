#!/bin/bash
ARGS=( "$@" )
while (( "$#" )); do
    shift
done
enforce_args_length() {
    if [ -z "$ARGS" ] || [ -z "$1" ]; then
        echo "Invalid arguments for 'enforce_args_length()'."
        exit 1;
    elif [ -z "${ARGS[($1-1)]}" ]; then
        echo "**********************************************************"
        echo "Invalid arguments. This can happen when you explicitly set parameters as empty. If you are trying to set an empty parameter, do not declare it."
        echo "**********************************************************"
        exit 1;
    fi
}
