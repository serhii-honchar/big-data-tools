package ua.kyiv.sa.model;

import lombok.Data;

@Data
public class AirlinesAvgDepartureDelay {
    private String airlineCode;
    private String airlineName;
    private Double avgDepartureDelay;
}
