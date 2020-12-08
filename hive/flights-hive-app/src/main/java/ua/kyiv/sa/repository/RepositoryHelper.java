package ua.kyiv.sa.repository;

import org.springframework.stereotype.Component;

@Component
public class RepositoryHelper {

    private static final String CREATE_FLIGHTS_TABLE_QUERY = "CREATE TABLE IF NOT EXISTS flights\n" +
            "(\n" +
            "    YEAR                int,\n" +
            "    MONTH               int,\n" +
            "    DAY                 int,\n" +
            "    DAY_OF_WEEK         int,\n" +
            "    AIRLINE             String,\n" +
            "    FLIGHT_NUMBER       int,\n" +
            "    TAIL_NUMBER         String,\n" +
            "    ORIGIN_AIRPORT      String,\n" +
            "    DESTINATION_AIRPORT String,\n" +
            "    SCHEDULED_DEPARTURE String,\n" +
            "    DEPARTURE_TIME      int,\n" +
            "    DEPARTURE_DELAY     int,\n" +
            "    TAXI_OUT            int,\n" +
            "    WHEELS_OFF          String,\n" +
            "    SCHEDULED_TIME      int,\n" +
            "    ELAPSED_TIME        int,\n" +
            "    AIR_TIME            int,\n" +
            "    DISTANCE            int,\n" +
            "    WHEELS_ON           String,\n" +
            "    TAXI_IN             int,\n" +
            "    SCHEDULED_ARRIVAL   String,\n" +
            "    ARRIVAL_TIME        String,\n" +
            "    ARRIVAL_DELAY       int,\n" +
            "    DIVERTED            int,\n" +
            "    CANCELLED           int,\n" +
            "    CANCELLATION_REASON String,\n" +
            "    AIR_SYSTEM_DELAY    String,\n" +
            "    SECURITY_DELAY      String,\n" +
            "    AIRLINE_DELAY       String,\n" +
            "    LATE_AIRCRAFT_DELAY String,\n" +
            "    WEATHER_DELAY       String\n" +
            ") COMMENT 'Flights'\n" +
            "    ROW FORMAT DELIMITED\n" +
            "    FIELDS TERMINATED BY ','\n" +
            "    LINES TERMINATED BY '\\n'\n" +
            "    STORED AS TEXTFILE";

    private final static String CREATE_AIRLINES_TABLE_QUERY = "CREATE TABLE IF NOT EXISTS airlines \n" +
            "(\n" +
            "    IATA_CODE String, \n" +
            "     AIRLINE   String \n" +
            " ) \n" +
            " COMMENT 'airlines' \n" +
            " ROW FORMAT DELIMITED  \n" +
            " FIELDS TERMINATED BY ',' \n" +
            " LINES TERMINATED BY '\n' \n" +
            " STORED AS TEXTFILE";

    private final static String UPLOAD_FLIGHTS = "LOAD DATA INPATH '/bdpc/hadoop_mr/flight-delays/flights.csv' OVERWRITE INTO TABLE flights";
    private final static String UPLOAD_AIRLINES = "LOAD DATA INPATH '/bdpc/hadoop_mr/flight-delays/airlines.csv' OVERWRITE INTO TABLE airlines";

    private final static String FIND_AIRLINES_AVG_DEPART_DELAY_QUERY = "select \n" +
            "       top5DelayedFlights.IATA_CODE     `airlineCode`,\n" +
            "       a.AIRLINE                        `airlineName`,\n" +
            "       top5DelayedFlights.Average_Delay `avgDepartureDelay`\n" +
            "from (select f.airline              IATA_CODE,\n" +
            "             avg(f.departure_delay) Average_Delay\n" +
            "      from flights f\n" +
            "      group by f.airline\n" +
            "      order by Average_Delay desc\n" +
            "      limit 5) top5DelayedFlights\n" +
            "         join airlines a on top5DelayedFlights.IATA_CODE = a.IATA_CODE\n" +
            "order by `avgDepartureDelay` desc";


    public String getCreateFlightsTableQuery() {
        return CREATE_FLIGHTS_TABLE_QUERY;
    }

    public String getCreateAirlinesTableQuery() {
        return CREATE_AIRLINES_TABLE_QUERY;
    }

    public String getUploadFlightsQuery() {
        return UPLOAD_FLIGHTS;
    }

    public String getUploadAirlinesQuery() {
        return UPLOAD_AIRLINES;
    }

    public String getFindTopNAirlinesWithGreatestDelayQuery() {
        return FIND_AIRLINES_AVG_DEPART_DELAY_QUERY;
    }
}
