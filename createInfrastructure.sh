#!/usr/bin/env bash


docker-compose up --scale nifi=3 -d
#sleep 10s
#echo "waiting 10 seconds"
#./kafka/createTopic.sh

docker ps


