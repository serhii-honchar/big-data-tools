package ua.kyiv.sa;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;
import ua.kyiv.sa.service.FlightsService;

// GLC| Don't quite understand the use-case senarious of the tool

@SpringBootApplication
public class FlightsHiveApplication {

    public static void main(String[] args) {
        ConfigurableApplicationContext applicationContext = SpringApplication.run(FlightsHiveApplication.class, args);
        FlightsService service = applicationContext.getBean(FlightsService.class);
        service.uploadFlightsData();
        service.printTopNAirlinesWithGreatestDepartureDelay(5);
    }

}
