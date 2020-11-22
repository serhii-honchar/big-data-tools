#!/usr/bin/env bash

readonly CONTAINER_ID=`docker ps -aqf "name=mynifi"`


if [[ -z  ${CONTAINER_ID} ]]
then
    echo 'No container found to stop or remove'
else
    echo 'Stopping container '${CONTAINER_ID}
    docker stop ${CONTAINER_ID}

    echo 'Removing container '${CONTAINER_ID}
    docker rm ${CONTAINER_ID}
fi
