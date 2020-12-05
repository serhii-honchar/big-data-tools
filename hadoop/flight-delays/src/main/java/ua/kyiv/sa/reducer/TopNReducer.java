package ua.kyiv.sa.reducer;

import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import ua.kyiv.sa.model.AirlineDelayStatsResult;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.util.HashMap;
import java.util.TreeSet;

public class TopNReducer extends Reducer<Text, Text, NullWritable, AirlineDelayStatsResult> {

    private static final HashMap<String, String> AIRLINES_NAMES = new HashMap<>();
    private static final TreeSet<AirlineDelayStatsResult> TOP_RESULTS = new TreeSet<>(AirlineDelayStatsResult::compareTo);

    private int nrOfResults = 5;

    @Override
    protected void setup(Context context) throws IOException {
        populateAirlineNames(context);
        nrOfResults = Integer.parseInt(context.getConfiguration().get("NR_OF_RESULTS"));
    }

    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context) {
        Text airlinesAvgDelay = values.iterator().next();
        AirlineDelayStatsResult result = AirlineDelayStatsResult.builder()
                .avgDelayTime(new Text(airlinesAvgDelay.toString()))
                .airlineCode(new Text(key.toString()))
                .build();
        TOP_RESULTS.add(result);
        if (TOP_RESULTS.size() > nrOfResults) {
            TOP_RESULTS.pollFirst();
        }
    }

    @Override
    protected void cleanup(Context context) throws IOException, InterruptedException {
        printTopNValues(context);
    }

    private void printTopNValues(Context context) throws IOException, InterruptedException {
        for (AirlineDelayStatsResult result : TOP_RESULTS.descendingSet()) {
            result.setAirlineName(new Text(AIRLINES_NAMES.get(result.getAirlineCode().toString())));
            context.write(NullWritable.get(), result);
        }
    }

    private void populateAirlineNames(Context context) throws IOException {
        URI[] cacheFiles = context.getCacheFiles();
        if (cacheFiles != null && cacheFiles.length > 0) {
            try {
                Path getFilePath = new Path(cacheFiles[0].toString());
                new BufferedReader(new InputStreamReader(FileSystem.get(context.getConfiguration()).open(getFilePath)))
                        .lines()
                        .filter(StringUtils::isNotBlank)
                        .forEach(x -> {
                            String[] split = x.split(",");
                            AIRLINES_NAMES.put(split[0], split[1]);
                        });
            } catch (Exception e) {
                System.out.println("Unable to read the file " + cacheFiles[0]);
                System.exit(1);
            }
        }
    }
}