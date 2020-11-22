#!/usr/bin/env bash

echo 'Building nifi image'

docker build . -t mynifi

echo 'Running built nifi image'

docker run --name mynifi \
  -p 9090:8080 \
  -d \
  -e NIFI_WEB_HTTP_PORT='8080' \
  mynifi