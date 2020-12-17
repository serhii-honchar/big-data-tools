package ua.kyiv.sa.model;

import lombok.*;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.io.Serializable;
import java.math.BigDecimal;

@Getter
@Setter
@EqualsAndHashCode
@Builder
@AllArgsConstructor
public class AirlineDelayStatsResult implements Writable, Comparable<AirlineDelayStatsResult>, Serializable {

    // GLC| As I can see there is no need to use writables as field members just plain java String is good
    // Writables are needed when you use them as map/reduce outputs
    private Text avgDelayTime=new Text();
    private Text airlineCode=new Text();
    private Text airlineName=new Text();

    public AirlineDelayStatsResult() {
    }

    @Override
    public void write(DataOutput dataOutput) throws IOException {
        avgDelayTime.write(dataOutput);
        airlineName.write(dataOutput);
        airlineCode.write(dataOutput);
    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        avgDelayTime.readFields(dataInput);
        airlineName.readFields(dataInput);
        airlineCode.readFields(dataInput);
    }

    @Override
    public String toString() {
        return airlineCode + "," + airlineName + "," + avgDelayTime;
    }

    @Override
    public int compareTo(AirlineDelayStatsResult o) {
        int result;
        result = new BigDecimal(this.getAvgDelayTime().toString()).compareTo(new BigDecimal(o.getAvgDelayTime().toString()));
        if (result == 0) {
            result = this.getAirlineCode().compareTo(o.getAirlineCode());
        }
        return result;
    }
}
