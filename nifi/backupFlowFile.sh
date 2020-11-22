#!/usr/bin/env bash

readonly FILENAME=flow.xml.gz`date +%Y-%m-%d_%H-%M-%S`

readonly CONTAINER_ID=`docker ps -aqf "name=nifi" | head -n 1`

docker cp ${CONTAINER_ID}:/opt/nifi/nifi-current/conf/flow.xml.gz ./dump/${FILENAME}
