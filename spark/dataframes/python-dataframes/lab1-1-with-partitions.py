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
    count_window = Window.partitionBy(MONTH, DEST) \
        .rowsBetween(Window.unboundedPreceding, Window.unboundedFollowing)
    max_window = Window.partitionBy(MONTH) \
        .rowsBetween(Window.unboundedPreceding, Window.unboundedFollowing)

    # solution using window
    flights_opt1 = flights.select(MONTH,
                                  DEST,
                                  F.count(DEST).over(count_window).alias("COUNT")) \
        .withColumn("MAX", F.max("COUNT").over(max_window).alias("MAX")) \
        .where(F.col("MAX") == F.col("COUNT")) \
        .distinct() \
        .join(F.broadcast(airports), F.col(DEST) == airports['IATA_CODE'], "left") \
        .select(F.col(MONTH), F.col(AIRPORT), F.col("COUNT")) \
        .orderBy(F.col(MONTH), F.col(AIRPORT))

    flights_opt1.write.option("delimiter", "\t").csv(sys.argv[3] + "/opt1/")

    sc.stop()
