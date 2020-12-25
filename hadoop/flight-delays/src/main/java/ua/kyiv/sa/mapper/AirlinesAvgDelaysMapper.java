package ua.kyiv.sa.mapper;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

public class AirlinesAvgDelaysMapper extends Mapper<LongWritable, Text, Text, Text> {

    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] inputValues = value.toString().split("\t");
        String airlineCode = inputValues[0];
        String airlineAvgDelay = inputValues[1];

        // GLC| It's worth reusing writables.
        // GLC| You can initialise a writable along with the mapper instance and update its state before writing
        // GLC| private Text t = new Text();
        // ..
        // GLC| public void map >> t.set("some value"); context.write(t, ..);
        context.write(new Text(airlineCode), new Text(airlineAvgDelay));

        // GLC| if you pass airlineAvgDelay * -1 you'll get items already ordered so you'll need to just
        // GLC| pick up the first N and airlineAvgDelay * -1 again to get the correct result value
    }
}