package ua.kyiv.sa;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mrunit.mapreduce.MapDriver;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import ua.kyiv.sa.mapper.AirlinesAvgDelaysMapper;

import java.io.IOException;

@RunWith(JUnit4.class)
public class AirlinesAvgDelaysMapperTest {

    private MapDriver<LongWritable, Text, Text, Text> mapDriver;

    @Before
    public void setUp() {
        AirlinesAvgDelaysMapper mapper = new AirlinesAvgDelaysMapper();
        mapDriver = MapDriver.newMapDriver(mapper);
    }

    @Test
    public void test() throws IOException {
        mapDriver.withInput(new LongWritable(1), new Text("AA	8.90"));
        mapDriver.withInput(new LongWritable(2), new Text("AS	1.79"));
        mapDriver.withInput(new LongWritable(3), new Text("B6	11.51"));
        mapDriver.withInput(new LongWritable(4), new Text("DL	7.37"));
        mapDriver.withInput(new LongWritable(5), new Text("EV	8.72"));
        mapDriver.withInput(new LongWritable(6), new Text("F9	13.35"));
        mapDriver.withInput(new LongWritable(7), new Text("HA	0.49"));
        mapDriver.withInput(new LongWritable(8), new Text("MQ	10.13"));

        mapDriver.withOutput(new Text("AA"), new Text("8.90"));
        mapDriver.withOutput(new Text("AS"), new Text("1.79"));
        mapDriver.withOutput(new Text("B6"), new Text("11.51"));
        mapDriver.withOutput(new Text("DL"), new Text("7.37"));
        mapDriver.withOutput(new Text("EV"), new Text("8.72"));
        mapDriver.withOutput(new Text("F9"), new Text("13.35"));
        mapDriver.withOutput(new Text("HA"), new Text("0.49"));
        mapDriver.withOutput(new Text("MQ"), new Text("10.13"));

        mapDriver.runTest();
    }
}
