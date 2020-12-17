-- GLC| Great job!

//create tables to store data from hdfs
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

CREATE TABLE IF NOT EXISTS airlines
(
    IATA_CODE String,
    AIRLINE   String
)
COMMENT
'airlines'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


// load data to hive
LOAD DATA INPATH '/bdpc/hadoop_mr/flight-delays/flights.csv' OVERWRITE INTO TABLE flights;
LOAD DATA INPATH '/bdpc/hadoop_mr/flight-delays/airlines.csv' OVERWRITE INTO TABLE airlines;

//create table with buckets
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
TBLPROPERTIES ("skip.header.line.count"="1");
-- //
-- LOAD DATA INPATH '/bdpc/hadoop_mr/flight-delays/flights.csv' OVERWRITE INTO TABLE flights_with_buckets;


//create table with partitions
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

//output the table definition
DESCRIBE FORMATTED flights_with_buckets;

//set properties required for dynamic buckets creation
set hive.enforce.bucketing = true;
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions=1000;
set hive.exec.max.dynamic.partitions.pernode=1000;

//populate tables with buckets
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
FROM flights;

//populate table with partitions
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
FROM flights;




//select to the regular table with inefficient join
-- GLC| Have you tried w/o join to estimate aggregation performance?
select f.airline              `IATA CODE`,
       a.AIRLINE              `AIRLINE`,
       avg(f.departure_delay) `Average Delay`
from flights f
join airlines a on f.AIRLINE = a.IATA_CODE
group by f.airline, a.AIRLINE
order by `Average Delay` desc
limit 5;

----------------------------------------------------------------------------------------------
VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      8          8        0        0       0       0
Map 4 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      3          3        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 04/04  [==========================>>] 100%  ELAPSED TIME: 369.58 s
----------------------------------------------------------------------------------------------
OK
NK      Spirit Air Lines        15.944765880783688
UA      United Air Lines Inc.   14.435441010805953
F9      Frontier Airlines Inc.  13.350858345331709
B6      JetBlue Airways 11.5143526744102
WN      Southwest Airlines Co.  10.581986295158847
Time taken: 370.75 seconds, Fetched: 5 row(s)



select top5DelayedFlights.IATA_CODE     `IATA CODE`,
       a.AIRLINE                        `AIRLINE`,
       top5DelayedFlights.Average_Delay `Average Delay`
from (select f.airline              IATA_CODE,
             avg(f.departure_delay) Average_Delay
      from flights f
      group by f.airline
      order by Average_Delay desc
      limit 5) top5DelayedFlights
         join airlines a on top5DelayedFlights.IATA_CODE = a.IATA_CODE
-- GLC| Have you tried w/o another order?
order by `Average Delay` desc;


----------------------------------------------------------------------------------------------
VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      8          8        0        0       0       0
Map 5 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      3          3        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0
Reducer 4 ...... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 32.40 s
----------------------------------------------------------------------------------------------
OK
NK      Spirit Air Lines        15.944765880783688
UA      United Air Lines Inc.   14.435441010805953
F9      Frontier Airlines Inc.  13.350858345331709
B6      JetBlue Airways 11.5143526744102
WN      Southwest Airlines Co.  10.581986295158847
Time taken: 33.351 seconds, Fetched: 5 row(s)





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

----------------------------------------------------------------------------------------------
VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      7          7        0        0       0       0
Map 5 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      3          3        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0
Reducer 4 ...... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 28.53 s
----------------------------------------------------------------------------------------------
OK
NK      Spirit Air Lines        15.944791386971321
UA      United Air Lines Inc.   14.435461491208617
F9      Frontier Airlines Inc.  13.351116968844488
B6      JetBlue Airways 11.5143526744102
WN      Southwest Airlines Co.  10.581997194509713
Time taken: 29.446 seconds, Fetched: 5 row(s)



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

----------------------------------------------------------------------------------------------
VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      9          9        0        0       0       0
Map 5 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      3          3        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0
Reducer 4 ...... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 29.68 s
----------------------------------------------------------------------------------------------
OK
NK      Spirit Air Lines        15.945515652339623
UA      United Air Lines Inc.   14.435600931061417
F9      Frontier Airlines Inc.  13.349966217338812
B6      JetBlue Airways 11.514764015446953
WN      Southwest Airlines Co.  10.582010093722841
Time taken: 30.677 seconds, Fetched: 5 row(s)


select distinct
    airline,
    avg(DEPARTURE_DELAY) over  (partition by AIRLINE)
from flights_partitioned limit 15;

----------------------------------------------------------------------------------------------
VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      9          9        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      3          3        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      3          3        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 03/03  [==========================>>] 100%  ELAPSED TIME: 49.16 s
----------------------------------------------------------------------------------------------
OK
B6      11.514764015446953
DL      7.369247244513391
EV      8.715417218447978
OO      7.801246118830279
US      6.141309201780095
AA      8.900817507231794
AS      1.7860757873672208
F9      13.349966217338812
VX      9.023819997719015
HA      0.4860401256060228
MQ      10.124913031843725
NK      15.945515652339623
UA      14.435600931061417
WN      10.582010093722841
Time taken: 50.03 seconds, Fetched: 14 row(s)


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

----------------------------------------------------------------------------------------------
VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      8          8        0        0       0       0
Map 5 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      2          2        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0
Reducer 4 ...... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 28.20 s
----------------------------------------------------------------------------------------------
OK
AA      American Airlines Inc.  8.900856346719806
Time taken: 29.187 seconds, Fetched: 1 row(s)


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

----------------------------------------------------------------------------------------------
VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      7          7        0        0       0       0
Map 5 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      2          2        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0
Reducer 4 ...... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 27.58 s
----------------------------------------------------------------------------------------------
OK
AA      American Airlines Inc.  8.900870182518931
Time taken: 28.543 seconds, Fetched: 1 row(s)

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
order by `Average Delay` desc;

----------------------------------------------------------------------------------------------
VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      3          3        0        0       0       0
Map 5 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      1          1        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0
Reducer 4 ...... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 18.54 s
----------------------------------------------------------------------------------------------
OK
AA      American Airlines Inc.  8.900817507231794
Time taken: 19.657 seconds, Fetched: 1 row(s)