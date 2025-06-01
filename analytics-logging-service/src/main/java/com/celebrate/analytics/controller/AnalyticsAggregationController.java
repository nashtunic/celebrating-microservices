package com.celebrate.analytics.controller;

import com.celebrate.analytics.service.AnalyticsAggregationService;
import com.celebrate.analytics.service.RealTimeAnalyticsService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/analytics/aggregations")
@PreAuthorize("hasAnyRole('ADMIN', 'ANALYST')")
public class AnalyticsAggregationController {
    private final AnalyticsAggregationService aggregationService;
    private final RealTimeAnalyticsService realTimeService;

    public AnalyticsAggregationController(
            AnalyticsAggregationService aggregationService,
            RealTimeAnalyticsService realTimeService) {
        this.aggregationService = aggregationService;
        this.realTimeService = realTimeService;
    }

    @GetMapping("/events/counts")
    public ResponseEntity<List<Map>> getEventCounts(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(aggregationService.getEventCountsByType(start, end));
    }

    @GetMapping("/users/top")
    public ResponseEntity<List<Map>> getTopUsers(
            @RequestParam(defaultValue = "10") int limit) {
        return ResponseEntity.ok(aggregationService.getTopActiveUsers(limit));
    }

    @GetMapping("/services/usage")
    public ResponseEntity<List<Map>> getServiceUsage(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(aggregationService.getServiceUsageStats(start, end));
    }

    @GetMapping("/events/hourly")
    public ResponseEntity<List<Map>> getHourlyDistribution(
            @RequestParam String eventType) {
        return ResponseEntity.ok(aggregationService.getHourlyActivityDistribution(eventType));
    }

    @GetMapping("/sessions")
    public ResponseEntity<List<Map>> getSessionAnalytics() {
        return ResponseEntity.ok(aggregationService.getUserSessionAnalytics());
    }

    // Real-time analytics endpoints
    @GetMapping("/realtime/events")
    public ResponseEntity<Map<String, Integer>> getCurrentEventCounts() {
        return ResponseEntity.ok(realTimeService.getCurrentEventTypeCounts());
    }

    @GetMapping("/realtime/services")
    public ResponseEntity<Map<String, Integer>> getCurrentServiceUsage() {
        return ResponseEntity.ok(realTimeService.getCurrentServiceUsage());
    }

    @GetMapping("/realtime/users")
    public ResponseEntity<Map<String, Integer>> getCurrentUserActivity() {
        return ResponseEntity.ok(realTimeService.getCurrentUserActivity());
    }

    // New advanced analytics endpoints
    @GetMapping("/users/{userId}/behavior")
    public ResponseEntity<Map> getUserBehaviorPatterns(
            @PathVariable String userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(aggregationService.getUserBehaviorPatterns(userId, start, end));
    }

    @GetMapping("/trends")
    public ResponseEntity<List<Map>> getTrendAnalysis(
            @RequestParam String period,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(aggregationService.getTrendAnalysis(period, start, end));
    }

    @GetMapping("/users/retention")
    public ResponseEntity<List<Map>> getUserRetentionAnalysis(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(aggregationService.getUserRetentionAnalysis(start, end));
    }
} 