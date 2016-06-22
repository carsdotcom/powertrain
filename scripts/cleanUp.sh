#! /bin/bash

linux=$(uname)

if [ "$linux" != "Linux" ]; then
    echo "This command is only available on a Linux host"
    exit 1
fi

DATA_BEFORE=$(docker info | grep 'Data Space Available' | awk '{print $4" "$5}')

## Remove containers
echo "Removing dead and exited containers"
docker ps --filter status=dead --filter status=exited -qa | xargs -r docker rm -v

## Remove Images
echo "Removing '<none>' images"
docker images --no-trunc | grep '<none>' | awk '{ print $3}' | xargs -r docker rmi

## Remove volumes
echo "Removing dangling volumes"
docker volume ls -qf dangling=true | xargs -r docker volume rm

## All images
IMAGES=($(docker images | awk '{i=$1":"$2; if(NR>1) print i}' | sort -u))

## Images with running containers
RUNNING_IMAGES=($(docker ps | awk '{if(NR>1) print $2}' | sort -u))

echo "Number of images : ${#IMAGES[@]}"
echo "Number of images with running containers : ${#RUNNING_IMAGES[@]}"

for del in ${RUNNING_IMAGES[@]}
do
    IMAGES=(${IMAGES[@]/$del})
done

echo "Will delete ${#IMAGES[@]} unreferenced images"

for rem in ${IMAGES[@]}
do
    docker rmi $rem
done

DATA_AFTER=$(docker info | grep 'Data Space Available' | awk '{print $4" "$5}')

echo "Data space before cleanup : $DATA_BEFORE"
echo "Data space after cleanup: $DATA_AFTER"
