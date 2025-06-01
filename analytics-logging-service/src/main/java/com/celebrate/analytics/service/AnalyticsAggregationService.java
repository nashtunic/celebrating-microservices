package com.celebrate.analytics.service;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.EnableCaching;
import org.bson.Document;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
@EnableCaching
public class AnalyticsAggregationService {
    private final MongoTemplate mongoTemplate;

    public AnalyticsAggregationService(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    @Cacheable(value = "eventCountsCache", key = "#start.toString() + #end.toString()")
    public List<Map> getEventCountsByType(LocalDateTime start, LocalDateTime end) {
        AggregationOperation matchOperation = Aggregation.match(
            Criteria.where("timestamp").gte(start).lte(end)
        );
        
        AggregationOperation groupOperation = Aggregation.group("eventType")
            .count().as("count");
            
        AggregationOperation projectOperation = Aggregation.project()
            .and("_id").as("eventType")
            .and("count").as("count");

        Aggregation aggregation = Aggregation.newAggregation(
            matchOperation,
            groupOperation,
            projectOperation
        );

        return mongoTemplate.aggregate(aggregation, "analytics_events", Map.class)
                .getMappedResults();
    }

    @Cacheable(value = "topUsersCache", key = "#limit")
    public List<Map> getTopActiveUsers(int limit) {
        AggregationOperation groupOperation = Aggregation.group("userId")
            .count().as("activityCount");
            
        AggregationOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "activityCount");
        
        AggregationOperation limitOperation = Aggregation.limit(limit);
        
        AggregationOperation projectOperation = Aggregation.project()
            .and("_id").as("userId")
            .and("activityCount").as("count");

        Aggregation aggregation = Aggregation.newAggregation(
            groupOperation,
            sortOperation,
            limitOperation,
            projectOperation
        );

        return mongoTemplate.aggregate(aggregation, "analytics_events", Map.class)
                .getMappedResults();
    }

    @Cacheable(value = "serviceUsageCache", key = "#start.toString() + #end.toString()")
    public List<Map> getServiceUsageStats(LocalDateTime start, LocalDateTime end) {
        AggregationOperation matchOperation = Aggregation.match(
            Criteria.where("timestamp").gte(start).lte(end)
        );
        
        AggregationOperation groupOperation = Aggregation.group("serviceSource")
            .count().as("totalRequests")
            .addToSet("userId").as("uniqueUsers");
            
        AggregationOperation projectOperation = Aggregation.project()
            .and("_id").as("service")
            .and("totalRequests").as("requests")
            .and("uniqueUsers").size().as("userCount");

        Aggregation aggregation = Aggregation.newAggregation(
            matchOperation,
            groupOperation,
            projectOperation
        );

        return mongoTemplate.aggregate(aggregation, "analytics_events", Map.class)
                .getMappedResults();
    }

    @Cacheable(value = "hourlyDistributionCache", key = "#eventType")
    public List<Map> getHourlyActivityDistribution(String eventType) {
        AggregationOperation matchOperation = Aggregation.match(
            Criteria.where("eventType").is(eventType)
        );
        
        AggregationOperation projectHourOperation = Aggregation.project()
            .and("timestamp").extractHour().as("hour");
            
        AggregationOperation groupOperation = Aggregation.group("hour")
            .count().as("count");
            
        AggregationOperation sortOperation = Aggregation.sort(Sort.Direction.ASC, "_id");
        
        AggregationOperation projectOperation = Aggregation.project()
            .and("_id").as("hour")
            .and("count").as("count");

        Aggregation aggregation = Aggregation.newAggregation(
            matchOperation,
            projectHourOperation,
            groupOperation,
            sortOperation,
            projectOperation
        );

        return mongoTemplate.aggregate(aggregation, "analytics_events", Map.class)
                .getMappedResults();
    }

    @Cacheable(value = "sessionAnalyticsCache")
    public List<Map> getUserSessionAnalytics() {
        AggregationOperation groupOperation = Aggregation.group("sessionId")
            .first("timestamp").as("sessionStart")
            .last("timestamp").as("sessionEnd")
            .first("userId").as("userId")
            .count().as("eventCount");
            
        AggregationOperation projectOperation = Aggregation.project()
            .and("userId").as("userId")
            .and("sessionStart").as("startTime")
            .and("sessionEnd").as("endTime")
            .and("eventCount").as("activities");

        Aggregation aggregation = Aggregation.newAggregation(
            groupOperation,
            projectOperation
        );

        return mongoTemplate.aggregate(aggregation, "analytics_events", Map.class)
                .getMappedResults();
    }

    @Cacheable(value = "userBehaviorPatternsCache", key = "#userId")
    public Map getUserBehaviorPatterns(String userId, LocalDateTime start, LocalDateTime end) {
        AggregationOperation matchOperation = Aggregation.match(
            Criteria.where("userId").is(userId)
                .and("timestamp").gte(start).lte(end)
        );
        
        Document eventDoc = new Document("eventType", "$eventType")
            .append("timestamp", "$timestamp");
            
        AggregationOperation groupOperation = Aggregation.group("userId")
            .push(eventDoc).as("events");
            
        AggregationOperation projectOperation = Aggregation.project()
            .and("events").as("eventSequence")
            .and("events").size().as("totalEvents");

        Aggregation aggregation = Aggregation.newAggregation(
            matchOperation,
            groupOperation,
            projectOperation
        );

        return mongoTemplate.aggregate(aggregation, "analytics_events", Map.class)
                .getUniqueMappedResult();
    }

    @Cacheable(value = "trendAnalysisCache", key = "#period")
    public List<Map> getTrendAnalysis(String period, LocalDateTime start, LocalDateTime end) {
        AggregationOperation matchOperation = Aggregation.match(
            Criteria.where("timestamp").gte(start).lte(end)
        );
        
        AggregationOperation projectOperation = Aggregation.project()
            .and("eventType").as("eventType")
            .and("timestamp").as("timestamp");
            
        AggregationOperation periodGroupOperation = getPeriodGrouping(period);
        
        AggregationOperation groupOperation = Aggregation.group("period", "eventType")
            .count().as("count");
            
        AggregationOperation sortOperation = Aggregation.sort(Sort.Direction.ASC, "_id.period");
        
        AggregationOperation finalProjectOperation = Aggregation.project()
            .and("_id.period").as("period")
            .and("_id.eventType").as("eventType")
            .and("count").as("count");

        Aggregation aggregation = Aggregation.newAggregation(
            matchOperation,
            projectOperation,
            periodGroupOperation,
            groupOperation,
            sortOperation,
            finalProjectOperation
        );

        return mongoTemplate.aggregate(aggregation, "analytics_events", Map.class)
                .getMappedResults();
    }

    @Cacheable(value = "userRetentionCache")
    public List<Map> getUserRetentionAnalysis(LocalDateTime start, LocalDateTime end) {
        AggregationOperation matchOperation = Aggregation.match(
            Criteria.where("timestamp").gte(start).lte(end)
        );
        
        AggregationOperation groupOperation = Aggregation.group("userId")
            .min("timestamp").as("firstSeen")
            .max("timestamp").as("lastSeen")
            .count().as("totalEvents");
            
        Document dateDiffDoc = new Document("$dateDiff", 
            new Document("startDate", "$firstSeen")
                .append("endDate", "$lastSeen")
                .append("unit", "day"));
                
        AggregationOperation projectOperation = Aggregation.project()
            .and("firstSeen").as("firstSeen")
            .and("lastSeen").as("lastSeen")
            .and("totalEvents").as("totalEvents")
            .andExpression("dateDiff(firstSeen, lastSeen, 'day')").as("retentionDays");

        Aggregation aggregation = Aggregation.newAggregation(
            matchOperation,
            groupOperation,
            projectOperation
        );

        return mongoTemplate.aggregate(aggregation, "analytics_events", Map.class)
                .getMappedResults();
    }

    private ProjectionOperation getPeriodGrouping(String period) {
        switch (period.toLowerCase()) {
            case "hour":
                return Aggregation.project()
                    .and("eventType").as("eventType")
                    .and("timestamp").extractHour().as("period");
            case "day":
                return Aggregation.project()
                    .and("eventType").as("eventType")
                    .and("timestamp").extractDayOfMonth().as("period");
            case "month":
                return Aggregation.project()
                    .and("eventType").as("eventType")
                    .and("timestamp").extractMonth().as("period");
            default:
                throw new IllegalArgumentException("Unsupported period: " + period);
        }
    }
} 