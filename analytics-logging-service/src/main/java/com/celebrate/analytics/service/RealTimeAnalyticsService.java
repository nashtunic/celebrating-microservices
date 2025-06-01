package com.celebrate.analytics.service;

import com.celebrate.analytics.dto.AnalyticsEventDTO;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@Service
public class RealTimeAnalyticsService {
    private final SimpMessagingTemplate messagingTemplate;
    private final Map<String, AtomicInteger> eventTypeCounter = new ConcurrentHashMap<>();
    private final Map<String, AtomicInteger> serviceUsageCounter = new ConcurrentHashMap<>();
    private final Map<String, AtomicInteger> userActivityCounter = new ConcurrentHashMap<>();

    public RealTimeAnalyticsService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    public void processRealTimeEvent(AnalyticsEventDTO event) {
        // Update event type counter
        eventTypeCounter.computeIfAbsent(event.getEventType(), k -> new AtomicInteger(0))
                .incrementAndGet();

        // Update service usage counter
        serviceUsageCounter.computeIfAbsent(event.getServiceSource(), k -> new AtomicInteger(0))
                .incrementAndGet();

        // Update user activity counter
        userActivityCounter.computeIfAbsent(event.getUserId(), k -> new AtomicInteger(0))
                .incrementAndGet();

        // Send real-time updates
        sendEventTypeUpdate(event.getEventType());
        sendServiceUsageUpdate(event.getServiceSource());
        sendUserActivityUpdate(event.getUserId());
    }

    private void sendEventTypeUpdate(String eventType) {
        messagingTemplate.convertAndSend(
            "/topic/events/" + eventType,
            Map.of(
                "eventType", eventType,
                "count", eventTypeCounter.get(eventType).get()
            )
        );
    }

    private void sendServiceUsageUpdate(String service) {
        messagingTemplate.convertAndSend(
            "/topic/services/" + service,
            Map.of(
                "service", service,
                "count", serviceUsageCounter.get(service).get()
            )
        );
    }

    private void sendUserActivityUpdate(String userId) {
        messagingTemplate.convertAndSend(
            "/topic/users/" + userId,
            Map.of(
                "userId", userId,
                "count", userActivityCounter.get(userId).get()
            )
        );
    }

    public Map<String, Integer> getCurrentEventTypeCounts() {
        Map<String, Integer> counts = new ConcurrentHashMap<>();
        eventTypeCounter.forEach((key, value) -> counts.put(key, value.get()));
        return counts;
    }

    public Map<String, Integer> getCurrentServiceUsage() {
        Map<String, Integer> counts = new ConcurrentHashMap<>();
        serviceUsageCounter.forEach((key, value) -> counts.put(key, value.get()));
        return counts;
    }

    public Map<String, Integer> getCurrentUserActivity() {
        Map<String, Integer> counts = new ConcurrentHashMap<>();
        userActivityCounter.forEach((key, value) -> counts.put(key, value.get()));
        return counts;
    }
} 