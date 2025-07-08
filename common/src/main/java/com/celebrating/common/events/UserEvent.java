package com.celebrating.common.events;

import java.io.Serializable;

public class UserEvent implements Serializable {
    private String eventId;
    private String eventType;
    private String userId;
    private String action;
    private Object data;

    public UserEvent() {
    }

    public UserEvent(String eventType, String userId, String action, Object data) {
        this.eventType = eventType;
        this.userId = userId;
        this.action = action;
        this.data = data;
    }

    // Getters and Setters
    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    // Factory methods
    public static UserEvent userCreated(String userId, Object userData) {
        return new UserEvent("USER_EVENT", userId, "USER_CREATED", userData);
    }

    public static UserEvent userUpdated(String userId, Object userData) {
        return new UserEvent("USER_EVENT", userId, "USER_UPDATED", userData);
    }

    public static UserEvent userDeleted(String userId) {
        return new UserEvent("USER_EVENT", userId, "USER_DELETED", null);
    }
} 