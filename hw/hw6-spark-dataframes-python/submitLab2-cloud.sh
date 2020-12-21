spark-submit \
 --master yarn --deploy-mode cluster \
 --num-executors 20 --executor-memory 1G --executor-cores 1 \
 --driver-memory 1G \
 --conf spark.yarn.appMasterEnv.SPARK_HOME=/dev/null \
 --conf spark.executorEnv.SPARK_HOME=/dev/null \
 ../../spark/dataframes/python-dataframes/lab2.py \
 hdfs:///bdpc/hadoop_mr/flight-delays/flights.csv \
 hdfs:///bdpc/hadoop_mr/flight-delays/airports.csv \
 hdfs:///bdpc/hadoop_mr/flight-delays/airlines.csv \
 hdfs:///bdpc/spark/dataframes/output/