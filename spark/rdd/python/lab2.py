import sys

from pyspark import SparkConf, SparkContext

APP_NAME = "CANCELLED_FLIGHTS_APP"


def extract_flights(s):
    if len(s) > 0:
        arr = s.split(",")
        return arr[4], arr[7], int(arr[24]), 1


def read_airports():
    airports_read = sc.textFile(sys.argv[2])
    header_line = airports_read.first()

    airports_parsed = airports_read \
        .filter(lambda line: len(line) > 0) \
        .filter(lambda line: line != header_line) \
        .map(lambda line: line.split(',')) \
        .map(lambda arr: (arr[0], arr[1]))

    return airports_parsed.collectAsMap()


def read_airlines():
    airlines = sc.textFile(sys.argv[3])
    header_line = airlines.first()

    airlines_parsed = airlines \
        .filter(lambda line: len(line) > 0) \
        .filter(lambda line: line != header_line) \
        .map(lambda line: line.split(',')) \
        .map(lambda arr: (arr[0], arr[1]))

    return airlines_parsed.collectAsMap()


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


def process_result(x):
    if x[1] == 'Waco Regional Airport':
        return x[0] + "," + x[1] + "," + x[2] + "," + x[3] + "," + x[4]
    else:
        return ("{" + "\"airline\":" + x[0] +
                ",\"airport\":" + x[1] +
                ",\"cancelledPercentage\":" + x[2] +
                ",\"cancelledFlights\":" + x[3] +
                ",\"totalFlights\":" + x[4] +
                "}")


if __name__ == "__main__":
    # configure spark context
    conf = SparkConf().setAppName(APP_NAME)
    sc = SparkContext(conf=conf)

    # read airports and airlines to map from file in hdfs
    airports = read_airports()
    airlines = read_airlines()

    # broadcast airports and airlines maps
    airports_broadcasted = sc.broadcast(airports)
    airlines_broadcasted = sc.broadcast(airlines)

    # read flights
    flights_rdd = sc.textFile(sys.argv[1])
    header = flights_rdd.first()

    #  rdd example (AS, ANC, 0, 1)
    # calculate totals for each airport and origin airline
    cancelled_total_tuple = (0, 0)
    totals_per_airlines_and_origin = flights_rdd \
        .filter(lambda line: line != header) \
        .map(lambda x: extract_flights(x)) \
        .map(lambda x: ((x[0], x[1]), x[2])) \
        .aggregateByKey(cancelled_total_tuple,
                        lambda a, b: (a[0] + b, a[1] + 1),
                        lambda a, b: (a[0] + b[0], a[1] + b[1]))

    # calculate average cancellation rate and processed flights for for each airline/origin
    avg_cancelled_per_airlines_and_origin = totals_per_airlines_and_origin \
        .mapValues(lambda value: (value[0] / value[1], value[0], value[1] - value[0])).collect()

    # join with the broadcast values
    avg_cancelled_per_airlines_and_origin_rdd = sc.parallelize(avg_cancelled_per_airlines_and_origin) \
        .map(lambda x: (
            airlines_broadcasted.value.get(x[0][0], x[0][0]),  # airline
            airports_broadcasted.value.get(x[0][1], x[0][1]),  # airport
            x[1][0],  # cancelled percentage
            x[1][1],  # cancelled count
            x[1][2])) \
        .sortBy(lambda x: (x[0], x[2]))  # sort by airline / cancelled percentage

    # prepare output in JSON format
    json_results_rdd = avg_cancelled_per_airlines_and_origin_rdd \
        .filter(lambda x: x[1] != 'Waco Regional Airport') \
        .map(lambda x: "{" + "\"airline\":" + x[0] +
                       ",\"airport\":" + x[1] +
                       ",\"cancelledPercentage\":" + str(x[2]) +
                       ",\"cancelledFlights\":" + str(x[3]) +
                       ",\"processedFlights\":" + str(x[4]) + "}")

    # prepare output in CSV format
    csv_result_rdd = avg_cancelled_per_airlines_and_origin_rdd \
        .filter(lambda x: x[1] == 'Waco Regional Airport') \
        .map(lambda x: x[0] + "," + x[1] + "," + str(x[2]) + "," + str(x[3]) + "," + str(x[4]))

    # output results, print to console if output path is not specified
    if len(sys.argv) <= 4:
        json_results_rdd.foreach(print)
        print("====================")
        csv_result_rdd.foreach(print)
    else:
        json_results_rdd.saveAsTextFile(sys.argv[4] + "/json")
        csv_result_rdd.saveAsTextFile(sys.argv[4] + "/csv")

    sc.stop()
