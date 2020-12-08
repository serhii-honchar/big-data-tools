package ua.kyiv.sa.repository;

import ua.kyiv.sa.model.AirlinesAvgDepartureDelay;

import java.util.List;

public interface FlightsRepository {
    void createTables();
    void uploadData();
    List<AirlinesAvgDepartureDelay> getAvgDepartureDelay();
}
