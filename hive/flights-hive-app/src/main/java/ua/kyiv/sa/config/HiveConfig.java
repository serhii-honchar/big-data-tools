package ua.kyiv.sa.config;

import org.apache.commons.dbcp.BasicDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

@Configuration
public class HiveConfig {
    @Value("${hive.connectionURL}")
    private String hiveConnectionURL;

    @Value("${hive.username:root}")
    private String userName;

    @Value("${hive.password:root}")
    private String password;

    public DataSource getHiveDataSource() {

        BasicDataSource dataSource = new BasicDataSource();
        dataSource.setUrl(this.hiveConnectionURL);
        dataSource.setDriverClassName("org.apache.hive.jdbc.HiveDriver");
        dataSource.setUsername(this.userName);
        dataSource.setPassword(this.password);

        return dataSource;
    }

    @Bean(name = "jdbcTemplate")
    public JdbcTemplate getJdbcTemplate() {
        return new JdbcTemplate(getHiveDataSource());
    }
}
