package ua.kyiv.sa.reducer;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

public class AirlinesDelaysReducer extends Reducer<Text, IntWritable, Text, Text> {


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

            context.write(key, new Text(avgDepartureDelay.toString()));
        }
    }
}