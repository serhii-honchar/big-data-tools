package ua.kyiv.sa;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;
import ua.kyiv.sa.mapper.AirlinesAvgDelaysMapper;
import ua.kyiv.sa.mapper.AirlinesDelaysMapper;
import ua.kyiv.sa.model.AirlineDelayStatsResult;
import ua.kyiv.sa.reducer.AirlinesDelaysReducer;
import ua.kyiv.sa.reducer.TopNReducer;

import java.net.URI;
import java.util.Arrays;

public class AirlinesWithGreatestAvgDelaysCalculator {

    private static final String TEMP_FOLDER_NAME = "/temp";

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        GenericOptionsParser optionParser = new GenericOptionsParser(conf, args);
        String[] remainingArgs = optionParser.getRemainingArgs();
        System.out.println(Arrays.toString(remainingArgs));
        if ((remainingArgs.length != 5)) {
            System.err.println("Usage: airlineDelays <in-flights> <in-airlines> <out>");
            System.exit(2);
        }
        String temporaryOutputFolder = args[3] + TEMP_FOLDER_NAME;
        Job job = Job.getInstance(conf, "test_airlines_delays");
        job.setJarByClass(AirlinesWithGreatestAvgDelaysCalculator.class);

        job.setReducerClass(AirlinesDelaysReducer.class);
        job.setNumReduceTasks(1);

        FileInputFormat.addInputPath(job, new Path(args[1]));
        job.setMapperClass(AirlinesDelaysMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);


        FileOutputFormat.setOutputPath(job, new Path(temporaryOutputFolder));
        conf.set("NR_OF_RESULTS", args[4] != null ? args[4] : "5");

        int code = job.waitForCompletion(true) ? 0 : 1;

        if (code == 0) {
            Job topRecordsJob = Job.getInstance(conf);
            topRecordsJob.setJarByClass(AirlinesWithGreatestAvgDelaysCalculator.class);
            topRecordsJob.setJobName("Top_N_Departure_Delays");

            FileInputFormat.addInputPath(topRecordsJob, new Path(temporaryOutputFolder));
            topRecordsJob.setMapperClass(AirlinesAvgDelaysMapper.class);
            topRecordsJob.setMapOutputKeyClass(Text.class);
            topRecordsJob.setMapOutputValueClass(Text.class);

            topRecordsJob.addCacheFile(new URI(args[2]));

            FileOutputFormat.setOutputPath(topRecordsJob, new Path(args[3] + "/top"));

            topRecordsJob.setReducerClass(TopNReducer.class);
            topRecordsJob.setNumReduceTasks(1);

            topRecordsJob.setOutputKeyClass(NullWritable.class);
            topRecordsJob.setOutputValueClass(AirlineDelayStatsResult.class);

            System.exit(topRecordsJob.waitForCompletion(true) ? 0 : 1);
        }
    }

}
