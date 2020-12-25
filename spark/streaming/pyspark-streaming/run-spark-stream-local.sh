#!/usr/bin/env bash
export SPARK_DIST_CLASSPATH=$(/usr/local/hadoop/bin/hadoop classpath)
/usr/local/spark/bin/spark-submit --master local --driver-memory 4g --num-executors 1 --executor-memory 4g --packages org.apache.spark:spark-sql-kafka-0-10_2.12:2.4.7 /home/serhio/IdeaProjects/bigdata-tools/spark/streaming/pyspark-streaming/lab-local.py

