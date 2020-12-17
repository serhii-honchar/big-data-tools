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
            // GLC| It's not a good idea to silently skip records -> Counters
            if (flightFields.length > 10) {
                String departureDelay = flightFields[11];
                String airLines = flightFields[4];
                // GLC| It's not a good idea to silently skip records -> Counters
                if (StringUtils.isNotBlank(departureDelay)) {
                    try {
                        int delay = Integer.parseInt(StringUtils.trim(departureDelay));
                        try {
                            // GLC| It's worth reusing writables.
                            // GLC| You can initialise a writable along with the mapper instance and update its state before writing
                            // GLC| private Text t = new Text();
                            // GLC| ..
                            // GLC| public void map >> t.set("some value"); context.write(t, ..);
                            context.write(new Text(StringUtils.trim(airLines)), new IntWritable(delay));
                        } catch (Exception e) {
                            // GLC| It's not a good idea to write out logs per each exception case
                            // GLC| It's better to use Counters with some chance (small one) of emitting logs
                            // GLC| Another way is to emit a log entry per exception type (say, NumberParseExc) only once
                            System.out.println("Error writing to context " + e);
                        }
                    } catch (Exception e) {
                        // GLC| It's not a good idea to write out logs per each exception case
                        System.out.println("Error parsing to integer '" + departureDelay + "' " + e);
                    }
                }
            }
        }
    }

    private boolean isHeader(LongWritable key, Text value) {
        // GLC|trick| If you take a look at Mapper implementation you may guess the skipping can be done in setup
        return key.get() == 0
                && value.toString().contains(DEPARTURE_DELAY_COLUMN_NAME);
    }
}
