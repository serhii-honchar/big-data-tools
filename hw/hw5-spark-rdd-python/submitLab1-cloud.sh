./spark-submit --master yarn-cluster  \
  --num-executors 20 --executor-memory 1G --executor-cores 3 \
 --driver-memory 1G \
 --conf spark.yarn.appMasterEnv.SPARK_HOME=/dev/null \
 --conf spark.executorEnv.SPARK_HOME=/dev/null \
 --files  ../../spark/rdd/python/lab1.py \
 hdfs:///bdpc/hadoop_mr/flight-delays/flights.csv \
 hdfs:///bdpc/hadoop_mr/flight-delays/airports.csv \
 hdfs:///bdpc/spark/output/result.tsv