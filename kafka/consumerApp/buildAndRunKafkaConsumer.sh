#!/usr/bin/env bash
mvn -f ./big-data-tools/kafka/consumerApp/pom.xml clean package
./big-data-tools/kafka/consumerApp/runKafkaConsumer.sh

