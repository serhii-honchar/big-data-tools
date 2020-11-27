#!/usr/bin/env bash

java -jar ./target/kafkaConsumer-0.0.1-spring-boot.jar \
 --cron="*/10 * * * * *" \
 --readRate=5000 \
 --spring.kafka.bootstrap-servers=localhost:9092 \
 --logging.level.root=ERROR \
 --logging.level=ERROR

