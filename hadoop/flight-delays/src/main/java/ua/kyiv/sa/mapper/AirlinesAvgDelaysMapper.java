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
        context.write(new Text(airlineCode), new Text(airlineAvgDelay));
    }
}