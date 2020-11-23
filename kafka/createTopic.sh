docker-compose exec kafka1  kafka-topics \
                                 --create --topic btc-transactions \
                                      --partitions 3 \
                                      --replication-factor 3 \
                                      --if-not-exists \
                                      --zookeeper zookeeper:2181
