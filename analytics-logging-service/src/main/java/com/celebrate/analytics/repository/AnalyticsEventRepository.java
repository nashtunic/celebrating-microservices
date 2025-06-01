package com.celebrate.analytics.repository;

import com.celebrate.analytics.model.AnalyticsEvent;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AnalyticsEventRepository extends MongoRepository<AnalyticsEvent, String> {
    List<AnalyticsEvent> findByEventType(String eventType);
    List<AnalyticsEvent> findByUserId(String userId);
    List<AnalyticsEvent> findByServiceSource(String serviceSource);
    List<AnalyticsEvent> findByTimestampBetween(LocalDateTime start, LocalDateTime end);
    List<AnalyticsEvent> findByUserIdAndEventType(String userId, String eventType);
} 