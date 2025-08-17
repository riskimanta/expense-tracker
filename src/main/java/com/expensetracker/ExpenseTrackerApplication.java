package com.expensetracker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class ExpenseTrackerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ExpenseTrackerApplication.class, args);
        System.out.println("🚀 Expense Tracker Backend berhasil dijalankan!");
        System.out.println("📍 API tersedia di: http://localhost:8080/api");
        System.out.println("📊 Health check: http://localhost:8080/api/actuator/health");
    }
}
