package ua.kyiv.sa.model;


import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;


@Getter
@Setter
@EqualsAndHashCode
public class AirlineAvgDelay implements Writable {
    private Text airlineCode = new Text();
    private Text avgDelay = new Text();

    @Override
    public void write(DataOutput dataOutput) throws IOException {
        airlineCode.write(dataOutput);
        avgDelay.write(dataOutput);
    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        airlineCode.readFields(dataInput);
        avgDelay.readFields(dataInput);
    }
}
