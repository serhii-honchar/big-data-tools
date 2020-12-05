package ua.kyiv.sa;

import junit.framework.TestCase;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mrunit.mapreduce.MapReduceDriver;
import org.apache.hadoop.mrunit.types.Pair;
import org.junit.Test;
import ua.kyiv.sa.mapper.AirlinesAvgDelaysMapper;
import ua.kyiv.sa.mapper.AirlinesDelaysMapper;
import ua.kyiv.sa.model.AirlineDelayStatsResult;
import ua.kyiv.sa.reducer.AirlinesDelaysReducer;
import ua.kyiv.sa.reducer.TopNReducer;

import java.util.List;

public class AirlinesTopDelaysIntegrationTest extends TestCase {

    @Test
    public void testJob() throws Exception {
        Configuration conf = new Configuration();
        conf.set("NR_OF_RESULTS", "2");

        List<Pair<Text, Text>> avgDelayJobResult = new MapReduceDriver<LongWritable, Text, Text, IntWritable, Text, Text>()
                .withMapper(new AirlinesDelaysMapper())
                .withInput(new LongWritable(0), new Text("YEAR,MONTH,DAY,DAY_OF_WEEK,AIRLINE,FLIGHT_NUMBER,TAIL_NUMBER,ORIGIN_AIRPORT,DESTINATION_AIRPORT,SCHEDULED_DEPARTURE,DEPARTURE_TIME,DEPARTURE_DELAY,TAXI_OUT,WHEELS_OFF,SCHEDULED_TIME,ELAPSED_TIME,AIR_TIME,DISTANCE,WHEELS_ON,TAXI_IN,SCHEDULED_ARRIVAL,ARRIVAL_TIME,ARRIVAL_DELAY,DIVERTED,CANCELLED,CANCELLATION_REASON,AIR_SYSTEM_DELAY,SECURITY_DELAY,AIRLINE_DELAY,LATE_AIRCRAFT_DELAY,WEATHER_DELAY"))
                .withInput(new LongWritable(1), new Text("2015,1,1,4,AS,98,N407AS,ANC,SEA,0005,2354,-11,21,0015,205,194,169,1448,0404,4,0430,0408,-22,0,0,,,,,,\n"))
                .withInput(new LongWritable(2), new Text("2015,1,1,4,AA,2336,N3KUAA,LAX,PBI,0010,0002,-8,12,0014,280,279,263,2330,0737,4,0750,0741,-9,0,0,,,,,,\n"))
                .withInput(new LongWritable(3), new Text("2015,1,1,4,US,840,N171US,SFO,CLT,0020,0018,-2,16,0034,286,293,266,2296,0800,11,0806,0811,5,0,0,,,,,,\n"))
                .withInput(new LongWritable(4), new Text("2015,1,1,4,AA,258,N3HYAA,LAX,MIA,0020,0015,-5,15,0030,285,281,258,2342,0748,8,0805,0756,-9,0,0,,,,,,\n"))
                .withReducer(new AirlinesDelaysReducer())
                .withOutput(new Text("US"), new Text("-2.00"))
                .withOutput(new Text("AA"), new Text("-6.50"))
                .withOutput(new Text("AS"), new Text("-11.00"))
                .run();

        MapReduceDriver<LongWritable, Text, Text, Text, NullWritable, AirlineDelayStatsResult> topResultsJob
                = new MapReduceDriver<LongWritable, Text, Text, Text, NullWritable, AirlineDelayStatsResult>()
                .withCacheFile("src/test/resources/airlines.csv")
                .withMapper(new AirlinesAvgDelaysMapper())
                .withReducer(new TopNReducer())
                .withOutput(NullWritable.get(),
                        AirlineDelayStatsResult.builder()
                                .airlineCode(new Text("US"))
                                .airlineName(new Text("US Airways Inc."))
                                .avgDelayTime(new Text("-2.00")).build())
                .withOutput(NullWritable.get(),
                        AirlineDelayStatsResult.builder()
                                .airlineCode(new Text("AA"))
                                .airlineName(new Text("American Airlines Inc."))
                                .avgDelayTime(new Text("-6.50")).build());
        for (Pair<Text, Text> prevJobResult : avgDelayJobResult) {
            topResultsJob.withInput(new Pair<>(new LongWritable(1), new Text(prevJobResult.getFirst() + "\t" + prevJobResult.getSecond())));
        }
        topResultsJob.getConfiguration().set("NR_OF_RESULTS", "2");
        topResultsJob.runTest();
    }

}