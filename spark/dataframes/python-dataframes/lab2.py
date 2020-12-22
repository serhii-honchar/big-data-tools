import sys

from pyspark import SparkContext, SparkConf, SQLContext
from pyspark.sql import Window
from pyspark.sql import functions as F

APP_NAME = "CANCELLED_FLIGHTS_APP_DATAFRAME"
ORIGIN = "ORIGIN_AIRPORT"
AIRPORT = "AIRPORT"
IATA_CODE = "IATA_CODE"
AIRLINE = "AIRLINE"
CANCELLED = "CANCELLED"

if __name__ == "__main__":
    conf = SparkConf().setAppName(APP_NAME)
    sc = SparkContext(conf=conf)
    sqlContext = SQLContext(sc)

    # read dataset
    flights = sqlContext.read.csv(sys.argv[1], header=True, inferSchema=True)
    airports = sqlContext.read.csv(sys.argv[2], header=True, inferSchema=True) \
        .select(F.col(IATA_CODE), F.col(AIRPORT))
    airlines = sqlContext.read.csv(sys.argv[3], header=True, inferSchema=True)

    # defining windows for further calculations
    stats_window = Window.partitionBy(AIRPORT, ORIGIN) \
        .rowsBetween(Window.unboundedPreceding, Window.unboundedFollowing)

    result = flights.select(AIRLINE,
                            ORIGIN,
                            CANCELLED).alias("flights") \
        .groupBy(AIRLINE, ORIGIN) \
        .agg(F.sum(CANCELLED)   .alias("cancelled"),
             F.count(ORIGIN)    .alias("total")) \
        .join(F.broadcast(airlines)
              .alias("airlines"), F.col("flights.AIRLINE") == airlines[IATA_CODE], "left") \
        .join(F.broadcast(airports)
              .alias("airports"), F.col("flights.ORIGIN_AIRPORT") == airports[IATA_CODE], "left") \
        .select(
            F.coalesce(F.col("airlines.AIRLINE"), F.col("flights.AIRLINE"))         .alias("airline"),
            F.coalesce(F.col("airports.AIRPORT"), F.col("flights.ORIGIN_AIRPORT"))  .alias("originAirport"),
            (F.col("cancelled") / F.col("total"))                                   .alias("cancelledPercentage"),
            F.col("cancelled")                                                      .alias("cancelledFlights"),
            (F.col("total") - F.col("cancelled"))                                   .alias("processedFlights")) \
        .orderBy(F.col("airline"), F.col("cancelledPercentage"))

    # prepare output in JSON and CSV formats
    json_results = result \
        .where(F.col("originAirport") != 'Waco Regional Airport')

    csv_results = result \
        .where(F.col("originAirport") == 'Waco Regional Airport')

    # write results
    if len(sys.argv) <= 4:
        csv_results.show()
        json_results.show()
    else:
        csv_results.write.csv(sys.argv[4]+"/csv")
        json_results.write.json(sys.argv[4]+"/json")

    sc.stop()
