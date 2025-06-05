package com.celebrating.monitoring.controller;

import com.celebrating.monitoring.model.ServiceStatus;
import com.celebrating.monitoring.service.ServiceMonitor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class MonitoringController {
    private final ServiceMonitor serviceMonitor;

    @Autowired
    public MonitoringController(ServiceMonitor serviceMonitor) {
        this.serviceMonitor = serviceMonitor;
    }

    @GetMapping("/")
    public String dashboard(Model model) {
        model.addAttribute("services", serviceMonitor.getAllServiceStatuses());
        return "dashboard";
    }

    @GetMapping("/api/services")
    @ResponseBody
    public List<ServiceStatus> getAllServices() {
        return serviceMonitor.getAllServiceStatuses();
    }

    @GetMapping("/api/services/{instanceId}")
    @ResponseBody
    public ServiceStatus getServiceStatus(@PathVariable String instanceId) {
        return serviceMonitor.getServiceStatus(instanceId);
    }
} 