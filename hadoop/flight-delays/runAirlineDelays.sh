#!/usr/bin/env bash
usage() {
  echo -e "Usage: $0 [-i <path>] [-o <path>]\n"\
       "where\n"\
       "-i defines an input path containing flights.csv and airlines.csv files, by default /bdpc/hadoop_mr/flight-delays/ will be used \n"\
       "-o defines an output path, default - /bdpc/hadoop_mr/output \n"\
       "-n defines an number of records in the output, 5 is default value\n"\
       "-e defines an executor: hadoop or yarn, yarn but default\n"\
       "\n"\
        1>&2
  exit 1
}


while getopts ":i:o:e:n:" opt; do
    case "$opt" in
        i)  INPUT_PATH=${OPTARG} ;;
        o)  OUTPUT_PATH=${OPTARG} ;;
        e)  EXECUTOR=${OPTARG} ;;
        n)  NR_OF_RESULTS=${OPTARG} ;;
        *)  usage ;;
    esac
done

HADOOP_HOME="/bdpc/hadoop_mr"

if [[ -z "$INPUT_PATH" ]];
then
  INPUT_PATH="${HADOOP_HOME}/flight-delays/"
fi

if [[ -z "$FLIGHTS_FILE" ]];
then
  FLIGHTS_FILE="${INPUT_PATH}flights.csv"
fi

if [[ -z "$AIRLINES_FILE" ]];
then
  AIRLINES_FILE="${INPUT_PATH}airlines.csv"
fi

if [[ -z "$OUTPUT_PATH" ]];
then
  OUTPUT_PATH="${HADOOP_HOME}/output"
fi

TOP_FLIGHTS_OUTPUT_PATH="${OUTPUT_PATH}/top"

if [[ -z "$EXECUTOR" ]];
then
  EXECUTOR="yarn"
fi

if [[ -z "$NR_OF_RESULTS" ]];
then
  NR_OF_RESULTS=5
fi

hadoop fs -rm -R $OUTPUT_PATH
hdfs dfs -ls ${INPUT_PATH}

THIS_FILE=$(readlink -f "$0")
THIS_PATH=$(dirname "$THIS_FILE")
BASE_PATH=$(readlink -f "$THIS_PATH/../")
APP_PATH="$THIS_PATH/flight-delays-1.0-jar-with-dependencies.jar"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "THIS_FILE = $THIS_FILE"
echo "THIS_PATH = $THIS_PATH"
echo "BASE_PATH = $BASE_PATH"
echo "APP_PATH = $APP_PATH"
echo "-------------------------------------"
echo "INPUT_PATH = $INPUT_PATH"
echo "OUTPUT_PATH = $OUTPUT_PATH"
echo "-------------------------------------"

mapReduceArguments=(
  "$APP_PATH"
  "ua.kyiv.sa.AirlinesWithGreatestAvgDelaysCalculator"
  "$FLIGHTS_FILE"
  "$AIRLINES_FILE"
  "$OUTPUT_PATH"
  "$NR_OF_RESULTS"
)

SUBMIT_CMD="${EXECUTOR} jar ${mapReduceArguments[@]}"
echo "$SUBMIT_CMD"
${SUBMIT_CMD}

echo "You should find results here: 'hadoop fs -ls $TOP_FLIGHTS_OUTPUT_PATH'"
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
