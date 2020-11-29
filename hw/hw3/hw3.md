## MapReduce application

Outputs the top N airlines with the greatest value of departure delay from the provided dataset

Source path: hadoop/flight-delays
Test source: hadoop/flight-delays/src/test/java/ua/kyiv/sa/AirlinesDelaysMapperTest.java


### STEPS TO RUN APPLICATION
1) Download the dataset from  https://www.kaggle.com/usdot/flight-delays
2) Upload unpacked files to some folder in the GCP bucket
3) Connect to the Master node of Dataproc cluster
```sh
gcloud compute ssh procamp-cluster-m --zone=[ZONE_ID] --project=[YOUR PROJECT ID]
```
4) Clone the project from the GitHub
```sh
git clone https://github.com/serhii-honchar/big-data-tools.git
```
5) Navigate to the homework directory
```sh
cd big-data-tools/hw/hw3
```
6) Review run.sh script, edit parameters if needed (described below), save and run it: 
```sh
chmod +755 run.sh
./run.sh
```

This script executes 2 actions: 
1) copies files to HDFS from bucket
```sh
./hadoop/flight-delays/upload_from_cloud_to_hdfs.sh
```
Available options: 

Flag    | Description                          | Default value   
--------|--------------------------------------|-------------------------------------------------
 -f     | Path with flights.csv file in GCP    | gs://procamp_hadoop/flight-delays/flights.csv
 -a     | Path with airlines.csv file in GCP   | gs://procamp_hadoop/flight-delays/airlines.csv           
 -d     | HDFS destination path                | /bdpc/hadoop_mr/flight-delays           

2) Runs job
```sh
./hadoop/flight-delays/runAirlineDelays.sh
```

Available options: 

Flag    | Description                          | Default value   
--------|--------------------------------------|-------------------------------
 -i     | input path with *.csv files          | /bdpc/hadoop_mr/flight-delays/
 -o     | output path                          | /bdpc/hadoop_mr/output           
 -n     | number of records in the output      | 5           

