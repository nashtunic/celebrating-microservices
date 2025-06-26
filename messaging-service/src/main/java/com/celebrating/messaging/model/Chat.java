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
@Table("chats")
public class Chat {
    @Id
    private Long id;
    private Long user1Id;
    private Long user2Id;
    private LocalDateTime createdAt;
    private LocalDateTime lastMessageAt;
    private boolean active;
} 