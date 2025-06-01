package com.celebrate.analytics;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class AnalyticsLoggingApplication {
    public static void main(String[] args) {
        SpringApplication.run(AnalyticsLoggingApplication.class, args);
    }
} 