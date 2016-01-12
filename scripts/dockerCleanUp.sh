#! /bin/sh

## Remove exited container
echo "Cleaning up containers"
docker rm -v $(docker ps -a -q -f status=exited)

## Remove 'dangling' containers
echo "Cleaning up images"
docker rmi $(docker images -f "dangling=true" -q)
