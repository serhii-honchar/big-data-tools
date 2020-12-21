import sys
from pyspark import SparkContext, SparkConf, SQLContext
from pyspark.sql import Window
from pyspark.sql import functions as F

APP_NAME = "DEST_AIRPORTS_STATS_APP_DATAFRAME"
MONTH = "MONTH"
DEST = "DESTINATION_AIRPORT"
AIRPORT = "AIRPORT"

if __name__ == "__main__":
    conf = SparkConf().setAppName(APP_NAME)
    sc = SparkContext(conf=conf)
    sqlContext = SQLContext(sc)

    # read dataset
    airports = sqlContext.read.csv(sys.argv[2], header=True, inferSchema=True)
    flights = sqlContext.read.csv(sys.argv[1], header=True, inferSchema=True)

    # defining windows for further calculations
    max_window = Window.partitionBy(MONTH) \
        .rowsBetween(Window.unboundedPreceding, Window.unboundedFollowing)

    # solution using groupBy aggregation
    flights_opt2 = flights \
        .groupBy([MONTH, DEST]) \
        .agg(F.count(DEST).alias("count")) \
        .withColumn("max", F.max("count").over(max_window).alias("max")) \
        .where(F.col("count") == F.col("max")) \
        .join(F.broadcast(airports), F.col(DEST) == airports['IATA_CODE'], "left") \
        .select(F.col(MONTH), F.col(AIRPORT), F.col("COUNT")) \
        .orderBy([MONTH, DEST])

    flights_opt2.write.option("delimiter", "\t").csv(sys.argv[3] + "/opt2/")

    sc.stop()
