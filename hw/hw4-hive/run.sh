#!/usr/bin/env bash

../../hadoop/flight-delays/upload_from_cloud_to_hdfs.sh \
 -f gs://procamp_hadoop/flight-delays/flights.csv \
 -a gs://procamp_hadoop/flight-delays/airlines.csv \
 -d /bdpc/hadoop_mr/flight-delays

java -jar ../../hive/flights-hive-app/flights-hive-app-0.0.1-SNAPSHOT-spring-boot.jar