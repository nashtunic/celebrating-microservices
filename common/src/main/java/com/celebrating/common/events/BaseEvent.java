package com.celebrating.common.events;

import java.time.LocalDateTime;
import java.util.UUID;
import java.io.Serializable;

public abstract class BaseEvent implements Serializable {
    private final String eventId;
    private final String eventType;
    private final LocalDateTime timestamp;

    protected BaseEvent(String eventType) {
        this.eventId = UUID.randomUUID().toString();
        this.eventType = eventType;
        this.timestamp = LocalDateTime.now();
    }

    public String getEventId() {
        return eventId;
    }

    public String getEventType() {
        return eventType;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }
} 