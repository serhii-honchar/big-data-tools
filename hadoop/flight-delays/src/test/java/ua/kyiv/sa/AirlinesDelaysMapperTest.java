package ua.kyiv.sa;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mrunit.mapreduce.MapDriver;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import ua.kyiv.sa.mapper.AirlinesDelaysMapper;

import java.io.IOException;

@RunWith(JUnit4.class)
public class AirlinesDelaysMapperTest {

    private MapDriver<LongWritable, Text, Text, IntWritable> mapDriver;

    @Before
    public void setUp() {
        AirlinesDelaysMapper mapper = new AirlinesDelaysMapper();
        mapDriver = MapDriver.newMapDriver(mapper);
    }

    @Test
    public void test() throws IOException {
        mapDriver.withInput(new LongWritable(0), new Text("YEAR,MONTH,DAY,DAY_OF_WEEK,AIRLINE,FLIGHT_NUMBER,TAIL_NUMBER,ORIGIN_AIRPORT,DESTINATION_AIRPORT,SCHEDULED_DEPARTURE,DEPARTURE_TIME,DEPARTURE_DELAY,TAXI_OUT,WHEELS_OFF,SCHEDULED_TIME,ELAPSED_TIME,AIR_TIME,DISTANCE,WHEELS_ON,TAXI_IN,SCHEDULED_ARRIVAL,ARRIVAL_TIME,ARRIVAL_DELAY,DIVERTED,CANCELLED,CANCELLATION_REASON,AIR_SYSTEM_DELAY,SECURITY_DELAY,AIRLINE_DELAY,LATE_AIRCRAFT_DELAY,WEATHER_DELAY"))
                .withInput(new LongWritable(1), new Text("2015,1,1,4,AS,98,N407AS,ANC,SEA,0005,2354,-11,21,0015,205,194,169,1448,0404,4,0430,0408,-22,0,0,,,,,,\n"))
                .withInput(new LongWritable(2), new Text("2015,1,1,4,AA,2336,N3KUAA,LAX,PBI,0010,0002,-8,12,0014,280,279,263,2330,0737,4,0750,0741,-9,0,0,,,,,,\n"))
                .withInput(new LongWritable(3), new Text("2015,1,1,4,US,840,N171US,SFO,CLT,0020,0018,-2,16,0034,286,293,266,2296,0800,11,0806,0811,5,0,0,,,,,,\n"))
                .withInput(new LongWritable(4), new Text("2015,1,1,4,AA,258,N3HYAA,LAX,MIA,0020,0015,-5,15,0030,285,281,258,2342,0748,8,0805,0756,-9,0,0,,,,,,\n"));

        mapDriver
                .withOutput(new Text("AS"), new IntWritable(-11))
                .withOutput(new Text("AA"), new IntWritable(-8))
                .withOutput(new Text("US"), new IntWritable(-2))
                .withOutput(new Text("AA"), new IntWritable(-5));

        mapDriver.runTest();
    }


}
