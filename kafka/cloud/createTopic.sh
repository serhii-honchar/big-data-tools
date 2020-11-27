#!/usr/bin/env bash
/usr/lib/kafka/bin/kafka-topics.sh \
                                 --create --topic btc-transactions \
                                      --partitions 3 \
                                      --replication-factor 3 \
                                      --if-not-exists \
                                      --zookeeper procamp-cluster-m:2181
