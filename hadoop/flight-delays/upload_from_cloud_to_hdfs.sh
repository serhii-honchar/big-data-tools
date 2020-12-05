usage() {
  echo -e "Usage: $0 [-a <airlines path>] [-f <flights path>] [-d <hdfs destination path>]\n"\
       "where\n"\
       "-f defines a path with flights.csv file, default - gs://procamp_hadoop/flight-delays/flights.csv\n"\
       "-a defines a path with airlines.csv file, default - gs://procamp_hadoop/flight-delays/airlines.csv\n"\
       "-d defines an hdfs destination path, default - /bdpc/hadoop_mr/flight-delays\n"\
       "\n"\
        1>&2
  exit 1
}

while getopts ":a:f:d:" opt; do
    case "$opt" in
        a)  AIRLINES_PATH=${OPTARG} ;;
        f)  FLIGHTS_PATH=${OPTARG} ;;
        d)  HDFS_PATH=${OPTARG} ;;
        *)  usage ;;
    esac
done

if [[ -z "$AIRLINES_PATH" ]];
then
  AIRLINES_PATH="gs://procamp_hadoop/flight-delays/airlines.csv"
fi

if [[ -z "$FLIGHTS_PATH" ]];
then
  FLIGHTS_PATH="gs://procamp_hadoop/flight-delays/flights.csv"
fi

if [[ -z "$HDFS_PATH" ]];
then
  HDFS_PATH="/bdpc/hadoop_mr/flight-delays/"
fi


hadoop fs -rm -R "$HDFS_PATH"
hdfs dfs -mkdir -p "$HDFS_PATH"

THIS_FILE=$(readlink -f "$0")
THIS_PATH=$(dirname "$THIS_FILE")
BASE_PATH=$(readlink -f "$THIS_PATH/../")

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "THIS_FILE = $THIS_FILE"
echo "THIS_PATH = $THIS_PATH"
echo "BASE_PATH = $BASE_PATH"
echo "-------------------------------------"
echo "FLIGHTS_PATH = $FLIGHTS_PATH"
echo "AIRLINES_PATH = $AIRLINES_PATH"
echo "HDFS_PATH = $HDFS_PATH"
echo "-------------------------------------"


SUBMIT_CMD="hdfs dfs -cp ${AIRLINES_PATH} ${FLIGHTS_PATH} ${HDFS_PATH}"
echo "$SUBMIT_CMD"
${SUBMIT_CMD}

echo "<<<<<<<<<<<<<<<<<<  HDFS  <<<<<<<<<<<<<<<<<<<<<"

hdfs dfs -ls ${HDFS_PATH}

echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"