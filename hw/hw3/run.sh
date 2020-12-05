#!/usr/bin/env bash

../../hadoop/flight-delays/upload_from_cloud_to_hdfs.sh \
 -f gs://procamp_hadoop/flight-delays/flights.csv \
 -a gs://procamp_hadoop/flight-delays/airlines.csv \
 -d /bdpc/hadoop_mr/flight-delays

../../hadoop/flight-delays/runAirlineDelays.sh \
  -i /bdpc/hadoop_mr/flight-delays/ \
  -o /bdpc/hadoop_mr/output \
  -n 5