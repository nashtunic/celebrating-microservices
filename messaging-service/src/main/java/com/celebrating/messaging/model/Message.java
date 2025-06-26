package com.celebrating.messaging.model;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import java.time.LocalDateTime;

@Data
@Getter
@Setter
@Table("messages")
public class Message {
    @Id
    private Long id;
    private Long chatId;
    private Long senderId;
    private Long receiverId;
    private String content;
    private boolean read;
    private LocalDateTime createdAt;
    private String mediaUrl;
}