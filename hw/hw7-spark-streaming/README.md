## HW7 DESCRIPTION

### Spark Structured streaming 

### Steps to check HW #7
1) Connect to master over ssh
``` sh
gcloud compute ssh procamp-cluster-m --zone=us-east1-b --project=${PROJECT_ID}
```

2) Clone project from repository
```sh
git clone https://github.com/serhii-honchar/big-data-tools.git
```
3) Execute the next scripts to start nifi and create Kafka topic
```   
chmod +755  big-data-tools/hw/hw7-spark-streaming/run.sh
    
big-data-tools/hw/hw7-spark-streaming/run.sh
```

4) submit the spark job using gcloud console:
```
gcloud dataproc jobs submit pyspark lab.py --cluster=procamp-cluster  --region=us-east1  --properties  spark.jars.packages=org.apache.spark:spark-sql-kafka-0-10_2.12:2.4.7 -- btc-transactions bdpc spark/streaming/output
```

According to the task's description, this command has 3 mandatory arguments, so it's possible to customize the job:

 Order |Argument           | Description  
-------|-------------------|-----------------------------------------------
 1     |Kafka topic        | Kafka topic with bitcoin transactions 
 2     |bucket name        | GCP bucket name that will be used be this job            
 3     |output path        | path that will contain job's results            






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
sudo cp big-data-tools/hw/hw7-spark-streaming/flow.xml.gz /opt/nifi/nifi-current/conf/flow.xml.gz
sudo /opt/nifi/nifi-current/bin/nifi.sh start
```

- starts all involved processors
```
chmod +755 ./big-data-tools/hw/hw7-spark-streaming/startNifiProcessors.sh
./big-data-tools/hw/hw7-spark-streaming/startNifiProcessors.sh
```