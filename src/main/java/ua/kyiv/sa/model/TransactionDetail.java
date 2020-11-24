package ua.kyiv.sa.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.io.Serializable;

@Data
public class TransactionDetail implements Serializable {
    private Long id;
    @JsonProperty("order_type")
    private OrderType orderType;
    private Long datetime;
    @JsonProperty("microtimestamp")
    private Long microTimestamp;
    private Double amount;
    private Double price;
}
