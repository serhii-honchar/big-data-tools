package ua.kyiv.sa.service;

public interface FlightsService {
    void uploadFlightsData();
    void printTopNAirlinesWithGreatestDepartureDelay(int numberOfRecords);
}
