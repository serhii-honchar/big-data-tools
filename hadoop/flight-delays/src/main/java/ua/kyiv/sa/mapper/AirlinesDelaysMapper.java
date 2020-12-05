package ua.kyiv.sa.mapper;

import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class AirlinesDelaysMapper extends Mapper<LongWritable, Text, Text, IntWritable> {

    private static final String DEPARTURE_DELAY_COLUMN_NAME = "DEPARTURE_DELAY";

    @Override
    protected void map(LongWritable key, Text value, Context context) {
        if (!isHeader(key, value)) {
            String flightData = value.toString();
            String[] flightFields = flightData.split(",");
            if (flightFields.length > 10) {
                String departureDelay = flightFields[11];
                String airLines = flightFields[4];
                if (StringUtils.isNotBlank(departureDelay)) {
                    try {
                        int delay = Integer.parseInt(StringUtils.trim(departureDelay));
                        try {
                            context.write(new Text(StringUtils.trim(airLines)), new IntWritable(delay));
                        } catch (Exception e) {
                            System.out.println("Error writing to context " + e);
                        }
                    } catch (Exception e) {
                        System.out.println("Error parsing to integer '" + departureDelay + "' " + e);
                    }
                }
            }
        }
    }

    private boolean isHeader(LongWritable key, Text value) {
        return key.get() == 0
                && value.toString().contains(DEPARTURE_DELAY_COLUMN_NAME);
    }
}
