package com.cqu.zhang.habit;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.core.mapping.MongoMappingContext;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EnableTransactionManagement
public class HabitApplication {
    public static void main(String[] args) {
        SpringApplication.run(HabitApplication.class, args);
    }
}
