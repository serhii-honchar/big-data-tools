#!/usr/bin/env bash
mvn clean package

java -jar ./target/bigdata-tools-0.0.1-spring-boot.jar \
 --cron="*/1 * * * * *" \
 --spring.kafka.bootstrap-servers="localhost:9092" \
 --logging.level.ua.kyiv.sa.TopResultsDataHolderServiceImpl=INFO \
 --logging.level.root=ERROR \
 --logging.level=ERROR

