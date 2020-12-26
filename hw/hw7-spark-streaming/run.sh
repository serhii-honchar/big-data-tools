#!/usr/bin/env bash

echo "create kafka topic"
/usr/lib/kafka/bin/kafka-topics.sh \
                                 --create --topic btc-transactions \
                                      --partitions 3 \
                                      --replication-factor 3 \
                                      --if-not-exists \
                                      --zookeeper procamp-cluster-m:2181

echo "preparing nifi"
sudo /opt/nifi/nifi-current/bin/nifi.sh stop
sudo cp big-data-tools/hw/hw7-spark-streaming/flow.xml.gz /opt/nifi/nifi-current/conf/flow.xml.gz
echo "nifi settings was copied, starting nifi now"
sudo /opt/nifi/nifi-current/bin/nifi.sh start

echo "waiting 30s for nifi"
sleep 30s

echo "starting nifi processors"
chmod +755 ./big-data-tools/hw/hw7-spark-streaming/startNifiProcessors.sh
./big-data-tools/hw/hw7-spark-streaming/startNifiProcessors.sh
