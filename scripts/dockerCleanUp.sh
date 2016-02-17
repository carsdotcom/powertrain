#!/bin/bash

# Remove exited container
EXITED=$(docker ps -a -q -f status=exited)
if [ -n "$EXITED" ]; then
    echo "Cleaning up exited containers"
    docker rm -v $EXITED
else
    echo "No exited containers to clean up"
fi

# Remove dangling containers
DANGLING=$(docker images -f "dangling=true" -q)
if [ -n "$DANGLING" ]; then
    echo "Cleaning up dangling images"
    docker rmi $DANGLING
else
    echo "No dangling images to clean up"
fi
