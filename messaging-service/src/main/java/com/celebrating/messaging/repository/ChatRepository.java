package com.celebrating.messaging.repository;

import com.celebrating.messaging.model.Chat;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import org.springframework.data.r2dbc.repository.R2dbcRepository;

public interface ChatRepository extends R2dbcRepository<Chat, Long> {
    
    @Query("SELECT * FROM chats WHERE (user1_id = :userId OR user2_id = :userId) AND active = true ORDER BY last_message_at DESC")
    Flux<Chat> findByUserId(Long userId);
    
    @Query("SELECT * FROM chats WHERE (user1_id = :user1Id AND user2_id = :user2Id) OR (user1_id = :user2Id AND user2_id = :user1Id) LIMIT 1")
    Mono<Chat> findByUserIds(Long user1Id, Long user2Id);
    
    @Query("UPDATE chats SET last_message_at = CURRENT_TIMESTAMP WHERE id = :chatId")
    Mono<Void> updateLastMessageTime(Long chatId);

    Flux<Chat> findByUser1IdOrUser2IdAndActiveIsTrue(Long user1Id, Long user2Id);
} 