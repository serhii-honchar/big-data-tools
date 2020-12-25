import sys

from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.functions import from_json, window, from_unixtime
from pyspark.sql.types import StructType, StringType, DoubleType, TimestampType, StructField, LongType, DecimalType

# setup session
spark = SparkSession \
    .builder \
    .appName("BTC_TRANSACTIONS_AGG") \
    .getOrCreate()

# process program arguments
if len(sys.argv) == 4:
    topic = sys.argv[1]
    bucket_name = sys.argv[2]
    folder = sys.argv[3]
else:
    print('Job expects 3 mandatory arguments - topic, bucket and folder, however found only ' + str(len(sys.argv)))
    sys.exit()

# defined JSON schema
schema = StructType([
    StructField("data", StructType([
        StructField("id", LongType()),
        StructField("id_str", StringType()),
        StructField("order_type", LongType()),
        StructField("datetime", StringType()),
        StructField("microtimestamp", StringType()),
        StructField("amount", DoubleType()),
        StructField("amount_str", StringType()),
        StructField("price", DoubleType()),
        StructField("price_str", StringType())])),
    StructField("channel", StringType()),
    StructField("event", StringType())
])

# prepare stream for aggregation -
# connect to broker's topic,
# pull and parse the JSON,
# extract and transform required data
prepared_stream = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", topic) \
    .load() \
    .selectExpr("cast (value as string) as json") \
    .select(from_json("json", schema).alias("json-data")) \
    .select("json-data.*") \
    .select(F.col("data.price").alias("price"),
            F.col("data.datetime").alias("datetime"),
            F.col("data.amount").alias("amount"),
            F.col("data.id").alias("id")) \
    .withColumn("btc_timestamp", from_unixtime("datetime").cast(TimestampType()).alias()) \
    .withColumn("btc_sale", F.col("price") * F.col("amount"))

# make required aggregations and prepare output values
agg_stream = prepared_stream \
    .withWatermark("btc_timestamp", "3 minutes") \
    .groupBy(window("btc_timestamp", "1 minute")) \
    .agg(F.count(F.col("id")).alias("count"),
         F.avg(F.col("price")).alias("avg_price"),
         F.sum(F.col("btc_sale")).alias("total_sale")) \
    .select("window.start",
            "window.end",
            "count",
            "avg_price",
            F.col("total_sale").cast(DecimalType(38, 4)))

# configure output stream writer and output job's results
# Job will be run for 1 hour
agg_stream \
    .writeStream \
    .outputMode("append") \
    .option("path", "gs://" + bucket_name + "/" + folder) \
    .format("csv") \
    .trigger(processingTime='20 seconds') \
    .option("checkpointLocation", "gs://" + bucket_name + "/checkpointLocation") \
    .start() \
    .awaitTermination()
