package ua.kyiv.sa.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ua.kyiv.sa.model.AirlinesAvgDepartureDelay;
import ua.kyiv.sa.repository.FlightsRepository;

import java.util.List;

@Service
@Slf4j
public class FlightServiceImpl implements FlightsService {
    private static final String MESSAGE_PATTERN = "%15s\t%30s\t%20s";

    @Autowired
    private FlightsRepository flightsRepository;

    public void uploadFlightsData() {
        log.info("<<<<<<<<<<<<<<<<<<creating tables>>>>>>>>>>>>>>>>>>");
        flightsRepository.createTables();
        log.info("<<<<<<<<<<<<<<<<<<uploading data>>>>>>>>>>>>>>>>>>");
        flightsRepository.uploadData();
    }

    public void printTopNAirlinesWithGreatestDepartureDelay(int numberOfRecords) {
        log.info("<<<<<<<<<<<<<<<<<<Executing query>>>>>>>>>>>>>>>>>>");
        List<AirlinesAvgDepartureDelay> avgDepartureDelay = flightsRepository.getAvgDepartureDelay();
        log.info("<<<<<<<<<<<<<<<<<< RESULT >>>>>>>>>>>>>>>>>>");
        log.info(String.format(MESSAGE_PATTERN, "IATA_CODE", "AIRLINE", "AVG DEPARTURE DELAY"));
        avgDepartureDelay.forEach(x -> {
            log.info(String.format(MESSAGE_PATTERN, x.getAirlineCode(), x.getAirlineName(), x.getAvgDepartureDelay()));
        });
    }
}
