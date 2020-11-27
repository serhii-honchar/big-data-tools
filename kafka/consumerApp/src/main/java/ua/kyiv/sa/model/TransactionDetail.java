package ua.kyiv.sa.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class TransactionDetail implements Serializable {
    private Long id;
    @JsonProperty("order_type")
    private OrderType orderType;
    private Long datetime;
    @JsonProperty("microtimestamp")
    private Long microTimestamp;
    @JsonFormat(shape= JsonFormat.Shape.STRING)
    private BigDecimal amount;
    @JsonFormat(shape= JsonFormat.Shape.STRING)
    private BigDecimal price;
}
