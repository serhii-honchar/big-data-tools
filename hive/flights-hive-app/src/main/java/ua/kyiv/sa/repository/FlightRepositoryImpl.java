package ua.kyiv.sa.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import ua.kyiv.sa.model.AirlinesAvgDepartureDelay;

import java.util.List;

@Repository
public class FlightRepositoryImpl implements FlightsRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private RepositoryHelper repositoryHelper;


    public void createTables() {

        jdbcTemplate.execute(repositoryHelper.getCreateAirlinesTableQuery());
        jdbcTemplate.execute(repositoryHelper.getCreateFlightsTableQuery());
    }

    public void uploadData() {
        jdbcTemplate.execute(repositoryHelper.getUploadAirlinesQuery());
        jdbcTemplate.execute(repositoryHelper.getUploadFlightsQuery());

    }

    public List<AirlinesAvgDepartureDelay> getAvgDepartureDelay() {
        return jdbcTemplate.query(repositoryHelper.getFindTopNAirlinesWithGreatestDelayQuery(),
                new BeanPropertyRowMapper<>(AirlinesAvgDepartureDelay.class));
    }
}
