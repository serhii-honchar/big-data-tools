import sys
from operator import add

from pyspark import SparkConf, SparkContext, AccumulatorParam

APP_NAME = "DEST_AIRPORTS_STATS_APP"


def extract_flights(s):
    if len(s) > 0:
        arr = s.split(",")
        return arr[1], arr[8], 1


def read_airports():
    airports_read = sc.textFile(sys.argv[2])
    header_line = airports_read.first()

    airports_parsed = airports_read \
        .filter(lambda line: len(line) > 0) \
        .filter(lambda line: line != header_line) \
        .map(lambda line: line.split(',')) \
        .map(lambda arr: (arr[0], arr[1]))

    return airports_parsed.collectAsMap()


def get_elem(a):
    return a


def append(a, b):
    if a[1] > b[1]:
        return a
    elif a[1] < b[1]:
        return b
    else:
        return a


def extend(a, b):
    if a[1] > b[1]:
        return a
    elif a[1] < b[1]:
        return b
    else:
        return a


if __name__ == "__main__":
    conf = SparkConf().setAppName(APP_NAME)
    sc = SparkContext(conf=conf)

    # read airports to map from file in hdfs
    airports = read_airports()

    # broadcast airports map
    airports_broadcasted = sc.broadcast(airports)

    # read flights
    flights_rdd = sc.textFile(sys.argv[1])
    header = flights_rdd.first()

    # calculate each airport count per month
    month_dest_airport_records = flights_rdd \
        .filter(lambda line: line != header) \
        .map(lambda x: extract_flights(x)) \
        .map(lambda x: ((x[0], x[1]), x[2])) \
        .reduceByKey(add)

    # get the the most frequent airport for each month
    res = month_dest_airport_records \
        .map(lambda x: (x[0][0], (x[0][1], x[1]))) \
        .combineByKey(get_elem, append, extend)

    # join result with airport name
    res = res.map(lambda x: (x[0], airports_broadcasted.value.get(x[1][0], x[1][0]), x[1][1])) \
        .map(lambda x: (str(x[0]) + "\t" + x[1] + "\t" + str(x[2])))

    # output result
    if len(sys.argv) <= 3:
        res.foreach(print)
    else:
        res.saveAsTextFile(sys.argv[3])

    sc.stop()
