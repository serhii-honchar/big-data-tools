package ua.kyiv.sa.reducer;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

public class AirlinesDelaysReducer extends Reducer<Text, IntWritable, Text, Text> {

    // GLC| if you set the only reducer for the job
    // GLC| you can implement TopN algorithm right in here and write on Reducer.cleanup
    // GLC| so there is no need for extra MR jobs
    // GLC| AND YOU HAVE IMPLEMENT IT -> TopNReducer :))

    @Override
    protected void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
        long totalAirlineDepartureDelayTime = 0;
        long totalAirlineFlightsCount = 0;

        for (IntWritable value : values) {
            totalAirlineDepartureDelayTime += value.get();
            totalAirlineFlightsCount++;
        }
        if (totalAirlineFlightsCount != 0) {
            BigDecimal avgDepartureDelay = BigDecimal.valueOf(totalAirlineDepartureDelayTime)
                    .divide(BigDecimal.valueOf(totalAirlineFlightsCount), 2, RoundingMode.HALF_UP);

            // GLC| It's worth reusing writables.
            // GLC| You can initialise a writable along with the mapper instance and update its state before writing
            // GLC| private Text t = new Text();
            // ..
            // GLC| public void reduce >> t.set("some value"); context.write(t, ..)
            context.write(key, new Text(avgDepartureDelay.toString()));
        }
    }
}