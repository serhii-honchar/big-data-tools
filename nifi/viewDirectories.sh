#!/usr/bin/env bash

readonly CONTAINER_ID=`docker ps -aqf "name=nifi" | head -n 1`

docker exec -t ${CONTAINER_ID} sh -c "ls -la /home/nifi/"

