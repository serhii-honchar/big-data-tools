## Hive

Application outputs the top N airlines with the greatest value of departure delay from the provided dataset using Hive with Spring boot

Source path: hive/flights-hive-app

### Steps to run application
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
cd big-data-tools/hw/hw4-hive
```
6) Review run.sh script, edit parameters if needed (described below), save and run it: 
```sh
chmod +755 run.sh
./run.sh
```
DON'T MODIFY -d PARAMETER of the first script because this value is currently hardcoded   


### This script executes 2 actions: 
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
 
2) Runs application that establishes connection with hive service and: 
 - creates required tables - flights and airlines;
 - uploads files from HDFS to Hive thus fills in created tables;
 - executes prepared query to find information about airlines with top 5 greatest values of departure delay;
 - prints fetched results to the output of the logger
 
    
 ## IMPORTANT NOTES
 Considering time-saving reasons, some simplifications are made, thus created application require further customizations: 
 - There's no way to specify way to source files
 - It's expected that Hive is up and running on the port 10000 on the master node
 - The default database is called 'default'
 - tests can be provided a little bit later: some library for Hive testing are mentioned on the Hive page.
 
 
 
### QUERY SAMPLES AND THEIR RESULTS
 1) Creating flights table
 ```sql
 CREATE TABLE IF NOT EXISTS flights
 (
     YEAR                int,
     MONTH               int,
     DAY                 int,
     DAY_OF_WEEK         int,
     AIRLINE             String,
     FLIGHT_NUMBER       int,
     TAIL_NUMBER         String,
     ORIGIN_AIRPORT      String,
     DESTINATION_AIRPORT String,
     SCHEDULED_DEPARTURE String,
     DEPARTURE_TIME      int,
     DEPARTURE_DELAY     int,
     TAXI_OUT            int,
     WHEELS_OFF          String,
     SCHEDULED_TIME      int,
     ELAPSED_TIME        int,
     AIR_TIME            int,
     DISTANCE            int,
     WHEELS_ON           String,
     TAXI_IN             int,
     SCHEDULED_ARRIVAL   String,
     ARRIVAL_TIME        String,
     ARRIVAL_DELAY       int,
     DIVERTED            int,
     CANCELLED           int,
     CANCELLATION_REASON String,
     AIR_SYSTEM_DELAY    String,
     SECURITY_DELAY      String,
     AIRLINE_DELAY       String,
     LATE_AIRCRAFT_DELAY String,
     WEATHER_DELAY       String
 ) COMMENT 'Flights'
     ROW FORMAT DELIMITED
     FIELDS TERMINATED BY ','
     LINES TERMINATED BY '\n'
     STORED AS TEXTFILE;
``` 
2) Creating 'airlines' table

```sql
CREATE TABLE IF NOT EXISTS airlines
(
    IATA_CODE String,
    AIRLINE   String
)
COMMENT 'airlines'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;
```  
3) Load data to Hive tables 

```sql
LOAD DATA INPATH '${source}/flights.csv' OVERWRITE INTO TABLE flights;
LOAD DATA INPATH '${source}/airlines.csv' OVERWRITE INTO TABLE airlines;
```

4) create table with buckets
```sql
CREATE TABLE IF NOT EXISTS flights_with_buckets
(
    YEAR                int,
    MONTH               int,
    DAY                 int,
    DAY_OF_WEEK         int,
    AIRLINE             String,
    FLIGHT_NUMBER       int,
    TAIL_NUMBER         String,
    ORIGIN_AIRPORT      String,
    DESTINATION_AIRPORT String,
    SCHEDULED_DEPARTURE String,
    DEPARTURE_TIME      int,
    DEPARTURE_DELAY     int,
    TAXI_OUT            int,
    WHEELS_OFF          String,
    SCHEDULED_TIME      int,
    ELAPSED_TIME        int,
    AIR_TIME            int,
    DISTANCE            int,
    WHEELS_ON           String,
    TAXI_IN             int,
    SCHEDULED_ARRIVAL   String,
    ARRIVAL_TIME        String,
    ARRIVAL_DELAY       int,
    DIVERTED            int,
    CANCELLED           int,
    CANCELLATION_REASON String,
    AIR_SYSTEM_DELAY    String,
    SECURITY_DELAY      String,
    AIRLINE_DELAY       String,
    LATE_AIRCRAFT_DELAY String,
    WEATHER_DELAY       String
) CLUSTERED BY(airline) INTO 16 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1")
```
5) Create table partitioned by airline code 
```sql
CREATE TABLE IF NOT EXISTS flights_partitioned
(
    YEAR                int,
    MONTH               int,
    DAY                 int,
    DAY_OF_WEEK         int,
    FLIGHT_NUMBER       int,
    TAIL_NUMBER         String,
    ORIGIN_AIRPORT      String,
    DESTINATION_AIRPORT String,
    SCHEDULED_DEPARTURE String,
    DEPARTURE_TIME      int,
    DEPARTURE_DELAY     int,
    TAXI_OUT            int,
    WHEELS_OFF          String,
    SCHEDULED_TIME      int,
    ELAPSED_TIME        int,
    AIR_TIME            int,
    DISTANCE            int,
    WHEELS_ON           String,
    TAXI_IN             int,
    SCHEDULED_ARRIVAL   String,
    ARRIVAL_TIME        String,
    ARRIVAL_DELAY       int,
    DIVERTED            int,
    CANCELLED           int,
    CANCELLATION_REASON String,
    AIR_SYSTEM_DELAY    String,
    SECURITY_DELAY      String,
    AIRLINE_DELAY       String,
    LATE_AIRCRAFT_DELAY String,
    WEATHER_DELAY       String
) PARTITIONED By (airline String)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    STORED AS TEXTFILE
 TBLPROPERTIES ("skip.header.line.count"="1");
```
6) Output the table definition:
```sql
DESCRIBE FORMATTED flights_with_buckets;
```

7) Properties required for dynamic buckets creation
```sql
   set hive.enforce.bucketing = true;
   set hive.exec.dynamic.partition=true;
   set hive.exec.dynamic.partition.mode=nonstrict;
   set hive.exec.max.dynamic.partitions=1000;
   set hive.exec.max.dynamic.partitions.pernode=1000;
```

8) Populate tables with buckets
```sql
INSERT
OVERWRITE TABLE flights_with_buckets
SELECT YEAR,
       MONTH,
       DAY,
       DAY_OF_WEEK,
       AIRLINE,
       FLIGHT_NUMBER,
       TAIL_NUMBER,
       ORIGIN_AIRPORT,
       DESTINATION_AIRPORT,
       SCHEDULED_DEPARTURE,
       DEPARTURE_TIME,
       DEPARTURE_DELAY,
       TAXI_OUT,
       WHEELS_OFF,
       SCHEDULED_TIME,
       ELAPSED_TIME,
       AIR_TIME,
       DISTANCE,
       WHEELS_ON,
       TAXI_IN,
       SCHEDULED_ARRIVAL,
       ARRIVAL_TIME,
       ARRIVAL_DELAY,
       DIVERTED,
       CANCELLED,
       CANCELLATION_REASON,
       AIR_SYSTEM_DELAY,
       SECURITY_DELAY,
       AIRLINE_DELAY,
       LATE_AIRCRAFT_DELAY,
       WEATHER_DELAY
FROM flights
```
9) Populate table with partitions
 
```sql  
  INSERT INTO TABLE flights_partitioned
        PARTITION (airline)
    SELECT   YEAR,
             MONTH,
             DAY,
             DAY_OF_WEEK,
    
             FLIGHT_NUMBER,
             TAIL_NUMBER,
             ORIGIN_AIRPORT,
             DESTINATION_AIRPORT,
             SCHEDULED_DEPARTURE,
             DEPARTURE_TIME,
             DEPARTURE_DELAY,
             TAXI_OUT,
             WHEELS_OFF,
             SCHEDULED_TIME,
             ELAPSED_TIME,
             AIR_TIME,
             DISTANCE,
             WHEELS_ON,
             TAXI_IN,
             SCHEDULED_ARRIVAL,
             ARRIVAL_TIME,
             ARRIVAL_DELAY,
             DIVERTED,
             CANCELLED,
             CANCELLATION_REASON,
             AIR_SYSTEM_DELAY,
             SECURITY_DELAY,
             AIRLINE_DELAY,
             LATE_AIRCRAFT_DELAY,
             WEATHER_DELAY,
             AIRLINE
    FROM flights
```



### Querying observations
1) Regular table with inefficient join
```sql
select f.airline              `IATA CODE`,
       a.AIRLINE              `AIRLINE`,
       avg(f.departure_delay) `Average Delay`
from flights f
join airlines a on f.AIRLINE = a.IATA_CODE
group by f.airline, a.AIRLINE
order by `Average Delay` desc
limit 5;
```

 VERTICES     |     MODE     |   STATUS    |  TOTAL  | COMPLETED | RUNNING | PENDING | FAILED | KILLED
--------------|--------------|-------------|---------|-----------|---------|---------|--------|--------
 Map 1        |  container   |  SUCCEEDED  |    8    |      8    |    0    |    0    |   0    |   0
 Map 4        |  container   |  SUCCEEDED  |    1    |      1    |    0    |    0    |   0    |   0
 Reducer 2    |  container   |  SUCCEEDED  |    3    |      3    |    0    |    0    |   0    |   0
 Reducer 3    |  container   |  SUCCEEDED  |    1    |      1    |    0    |    0    |   0    |   0
--------------|--------------|------ ------|---------|-----------|---------|---------|--------|--------
 VERTICES: 04/04  [==========================>>] 100%  ELAPSED TIME: 369.58 s


2) Regular search

```sql
select top5DelayedFlights.IATA_CODE     `IATA CODE`,
       a.AIRLINE                        `AIRLINE`,
       top5DelayedFlights.Average_Delay `Average Delay`
from (select f.airline              IATA_CODE,
             avg(f.departure_delay) Average_Delay
      from flights_with_buckets f
      group by f.airline
      order by Average_Delay desc
      limit 5) top5DelayedFlights
         join airlines a on top5DelayedFlights.IATA_CODE = a.IATA_CODE
order by `Average Delay` desc;
```
VERTICES      |    MODE      |      STATUS  |  TOTAL |   COMPLETED | RUNNING | PENDING | FAILED | KILLED
--------------|--------------|--------------|--------|-------------|---------|---------|--------|-----
Map 1         | container  |   SUCCEEDED  |    7   |       7     |   0     |   0     |  0     |  0
Map 5         | container  |   SUCCEEDED  |    1   |       1     |   0     |   0     |  0     |  0
Reducer 2     | container  |   SUCCEEDED  |    3   |       3     |   0     |   0     |  0     |  0
Reducer 3     | container  |   SUCCEEDED  |    1   |       1     |   0     |   0     |  0     |  0
Reducer 4     | container  |   SUCCEEDED  |    1   |       1     |   0     |   0     |  0     |  0
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 28.53 s


3) Select in partitioned table 
```sql
select top5DelayedFlights.IATA_CODE     `IATA CODE`,
       a.AIRLINE                        `AIRLINE`,
       top5DelayedFlights.Average_Delay `Average Delay`
from (select f.airline              IATA_CODE,
             avg(f.departure_delay) Average_Delay
      from flights_partitioned f
      group by f.airline
      order by Average_Delay desc
      limit 5) top5DelayedFlights
         join airlines a on top5DelayedFlights.IATA_CODE = a.IATA_CODE
order by `Average Delay` desc;
```
VERTICES       |   MODE       |   STATUS    |  TOTAL |   COMPLETED | RUNNING | PENDING | FAILED | KILLED
---------------|--------------|-------------|--------|-------------|---------|---------|--------|-----
Map 1          |  container   |  SUCCEEDED  |    9   |       9     |   0     |   0     |  0     |  0
Map 5          |  container   |  SUCCEEDED  |    1   |       1     |   0     |   0     |  0     |  0
Reducer 2      |  container   |  SUCCEEDED  |    3   |       3     |   0     |   0     |  0     |  0
Reducer 3      |  container   |  SUCCEEDED  |    1   |       1     |   0     |   0     |  0     |  0
Reducer 4      |  container   |  SUCCEEDED  |    1   |       1     |   0     |   0     |  0     |  0
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 29.68 s

4) select with window function
```sql
select distinct
    airline,
    avg(DEPARTURE_DELAY) over  (partition by AIRLINE)
from flights_partitioned limit 15;
```
VERTICES      |     MODE     |   STATUS    | TOTAL | COMPLETED | RUNNING | PENDING  |  FAILED | KILLED
--------------|--------------|-------------|-------|-----------|---------|----------|---------|-------
Map 1         |  container   |  SUCCEEDED  |   9   |    9      |    0    |    0     |    0    |   0
Reducer 2     |  container   |  SUCCEEDED  |   3   |    3      |    0    |    0     |    0    |   0
Reducer 3     |  container   |  SUCCEEDED  |   3   |    3      |    0    |    0     |    0    |   0
VERTICES: 03/03  [==========================>>] 100%  ELAPSED TIME: 49.16 s


5) Regular table for specific airline
```sql

select top5DelayedFlights.IATA_CODE     `IATA CODE`,
       a.AIRLINE                        `AIRLINE`,
       top5DelayedFlights.Average_Delay `Average Delay`
from (select f.airline              IATA_CODE,
             avg(f.departure_delay) Average_Delay
      from flights f
    where AIRLINE='AA'
      group by f.airline
      order by Average_Delay desc
      limit 5) top5DelayedFlights
         join airlines a on top5DelayedFlights.IATA_CODE = a.IATA_CODE
order by `Average Delay` desc;
```

VERTICES        |    MODE     |   STATUS     | TOTAL  |  COMPLETED | RUNNING | PENDING | FAILED | KILLED
----------------|-------------|--------------|--------|------------|---------|---------|--------|-----
Map 1           | container   |  SUCCEEDED   |   8    |      8     |   0     |   0     |  0     |  0
Map 5           | container   |  SUCCEEDED   |   1    |      1     |   0     |   0     |  0     |  0
Reducer 2       | container   |  SUCCEEDED   |   2    |      2     |   0     |   0     |  0     |  0
Reducer 3       | container   |  SUCCEEDED   |   1    |      1     |   0     |   0     |  0     |  0
Reducer 4       | container   |  SUCCEEDED   |   1    |      1     |   0     |   0     |  0     |  0
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 28.20 s


6) Table with buckets queries for some airline 
```sql
select top5DelayedFlights.IATA_CODE     `IATA CODE`,
       a.AIRLINE                        `AIRLINE`,
       top5DelayedFlights.Average_Delay `Average Delay`
from (select f.airline              IATA_CODE,
             avg(f.departure_delay) Average_Delay
      from flights_with_buckets f
      where AIRLINE='AA'
      group by f.airline
      order by Average_Delay desc
      limit 5) top5DelayedFlights
         join airlines a on top5DelayedFlights.IATA_CODE = a.IATA_CODE
order by `Average Delay` desc;
```

VERTICES        |    MODE     |   STATUS    |  TOTAL  |  COMPLETED | RUNNING | PENDING | FAILED | KILLED
----------------|-------------|-------------|---------|------------|---------|---------|--------|-----
Map 1           | container   |  SUCCEEDED  |    7    |      7     |   0     |   0     |  0     |  0
Map 5           | container   |  SUCCEEDED  |    1    |      1     |   0     |   0     |  0     |  0
Reducer 2       | container   |  SUCCEEDED  |    2    |      2     |   0     |   0     |  0     |  0
Reducer 3       | container   |  SUCCEEDED  |    1    |      1     |   0     |   0     |  0     |  0
Reducer 4       | container   |  SUCCEEDED  |    1    |      1     |   0     |   0     |  0     |  0
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 27.58 s

7) Partitioned table querying for some airline
```sql
select top5DelayedFlights.IATA_CODE     `IATA CODE`,
       a.AIRLINE                        `AIRLINE`,
       top5DelayedFlights.Average_Delay `Average Delay`
from (select f.airline              IATA_CODE,
             avg(f.departure_delay) Average_Delay
      from flights_partitioned f
      where f.AIRLINE='AA'
      group by f.airline
      order by Average_Delay desc
      limit 5) top5DelayedFlights
         join airlines a on top5DelayedFlights.IATA_CODE = a.IATA_CODE
order by `Average Delay` desc
``` 

VERTICES      |    MODE     |    STATUS     | TOTAL |   COMPLETED | RUNNING | PENDING | FAILED | KILLED
--------------|-------------|---------------|-------|-------------|---------|---------|--------|------
Map 1         |  container  |   SUCCEEDED   |   3   |       3     |   0     |   0     |  0     |  0
Map 5         |  container  |   SUCCEEDED   |   1   |       1     |   0     |   0     |  0     |  0
Reducer 2     |  container  |   SUCCEEDED   |   1   |       1     |   0     |   0     |  0     |  0
Reducer 3     |  container  |   SUCCEEDED   |   1   |       1     |   0     |   0     |  0     |  0
Reducer 4     |  container  |   SUCCEEDED   |   1   |       1     |   0     |   0     |  0     |  0
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 18.54 s

