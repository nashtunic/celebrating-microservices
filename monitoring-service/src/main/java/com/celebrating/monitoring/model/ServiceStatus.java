package com.celebrating.monitoring.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ServiceStatus {
    private String serviceName;
    private String status;
    private String health;
    private String instanceId;
    private String host;
    private int port;
    private LocalDateTime lastUpdated;
    private String errorMessage;
    private boolean isUp;
} 