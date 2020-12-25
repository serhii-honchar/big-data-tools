## HW2 DESCRIPTION

### Kafka consumer setup 
Application has 2 additional arguments for simplicity reasons:

Argument    | Unit            | Default value   | Value description  
------------|-----------------|-----------------|---------------
readRate    | milliseconds    | 5000            | reads from broker broker each 5 secs 
cron        | cron expression | "*/10 * * * * *"| writes results to console each 10 secs           

These arguments can be changed in  kafka/consumerApp/buildAndRunKafkaConsumer.sh


### Steps to check HW #2
1) Connect to master over ssh
``` sh
gcloud compute ssh procamp-cluster-m --zone=us-east1-b --project=${PROJECT_ID}
```

2) Install maven on the master node
```sh
sudo apt install maven -y
```

3) Clone project from repository
```sh
git clone https://github.com/serhii-honchar/big-data-tools.git
```
4) Execute the next scripts:
```   
chmod +755  big-data-tools/hw/hw2/run.sh
    
big-data-tools/hw/hw2/run.sh
```







## run.sh completes the next actions:

- creates Kafka topic
```
/usr/lib/kafka/bin/kafka-topics.sh \
      --create --topic btc-transactions \
      --partitions 3 \
      --replication-factor 3 \
      --if-not-exists \
      --zookeeper procamp-cluster-m:2181
```
- prepares NiFi 
```
sudo /opt/nifi/nifi-current/bin/nifi.sh stop
sudo cp big-data-tools/hw/hw2/flow.xml.gz /opt/nifi/nifi-current/conf/flow.xml.gz
sudo /opt/nifi/nifi-current/bin/nifi.sh start
```

- builds and launches consumer application
```
./big-data-tools/kafka/consumerApp/buildAndRunKafkaConsumer.sh
```

- starts all involved processors
```
chmod +755 ./big-data-tools/hw/hw2/startNifiProcessors.sh
./big-data-tools/hw/hw2/startNifiProcessors.sh
```