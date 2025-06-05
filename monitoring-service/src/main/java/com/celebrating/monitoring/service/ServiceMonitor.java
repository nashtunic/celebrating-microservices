package com.celebrating.monitoring.service;

import com.celebrating.monitoring.model.ServiceStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class ServiceMonitor {
    private final DiscoveryClient discoveryClient;
    private final RestTemplate restTemplate;
    private final Map<String, ServiceStatus> serviceStatuses = new ConcurrentHashMap<>();

    @Autowired
    public ServiceMonitor(DiscoveryClient discoveryClient) {
        this.discoveryClient = discoveryClient;
        this.restTemplate = new RestTemplate();
    }

    @Scheduled(fixedRate = 30000) // Check every 30 seconds
    public void updateServiceStatuses() {
        discoveryClient.getServices().forEach(serviceName -> {
            discoveryClient.getInstances(serviceName).forEach(instance -> {
                ServiceStatus status = new ServiceStatus();
                status.setServiceName(serviceName);
                status.setInstanceId(instance.getInstanceId());
                status.setHost(instance.getHost());
                status.setPort(instance.getPort());
                status.setLastUpdated(LocalDateTime.now());

                try {
                    String healthUrl = instance.getUri() + "/actuator/health";
                    Map<String, Object> health = restTemplate.getForObject(healthUrl, Map.class);
                    status.setHealth(health.get("status").toString());
                    status.setUp(true);
                    status.setErrorMessage(null);
                } catch (Exception e) {
                    status.setUp(false);
                    status.setErrorMessage(e.getMessage());
                }

                serviceStatuses.put(instance.getInstanceId(), status);
            });
        });
    }

    public List<ServiceStatus> getAllServiceStatuses() {
        return new ArrayList<>(serviceStatuses.values());
    }

    public ServiceStatus getServiceStatus(String instanceId) {
        return serviceStatuses.get(instanceId);
    }
} 