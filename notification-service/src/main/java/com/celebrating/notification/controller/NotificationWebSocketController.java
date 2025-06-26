package com.celebrating.notification.controller;

import com.celebrating.notification.model.Notification;
import com.celebrating.notification.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class NotificationWebSocketController {

    private final SimpMessagingTemplate messagingTemplate;
    private final NotificationService notificationService;

    @Autowired
    public NotificationWebSocketController(
            SimpMessagingTemplate messagingTemplate,
            NotificationService notificationService) {
        this.messagingTemplate = messagingTemplate;
        this.notificationService = notificationService;
    }

    @MessageMapping("/notifications.connect")
    public void handleConnect(@Payload String userId) {
        // Subscribe user to their personal notification channel
        String destination = "/user/" + userId + "/queue/notifications";
        messagingTemplate.convertAndSend(destination, "Connected to notifications");
    }

    public void sendNotification(String userId, Notification notification) {
        String destination = "/user/" + userId + "/queue/notifications";
        messagingTemplate.convertAndSend(destination, notification);
    }

    public void sendSystemNotification(String message) {
        messagingTemplate.convertAndSend("/topic/system", message);
    }
} 