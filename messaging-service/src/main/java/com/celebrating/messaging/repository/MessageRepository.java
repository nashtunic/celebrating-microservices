package com.celebrating.messaging.repository;

import com.celebrating.messaging.model.Message;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.time.LocalDateTime;

public interface MessageRepository extends ReactiveCrudRepository<Message, Long> {
    
    @Query("SELECT * FROM messages WHERE chat_id = :chatId ORDER BY created_at DESC")
    Flux<Message> findByChatId(Long chatId);
    
    @Query("SELECT * FROM messages WHERE sender_id = :userId OR receiver_id = :userId ORDER BY created_at DESC")
    Flux<Message> findByUserId(Long userId);
    
    @Query("SELECT * FROM messages WHERE chat_id = :chatId AND created_at < :timestamp ORDER BY created_at DESC LIMIT :limit")
    Flux<Message> findOlderMessages(Long chatId, LocalDateTime timestamp, int limit);
    
    @Query("SELECT COUNT(*) FROM messages WHERE chat_id = :chatId AND receiver_id = :userId AND read = false")
    Mono<Long> countUnreadMessages(Long chatId, Long userId);
    
    @Query("UPDATE messages SET read = true WHERE chat_id = :chatId AND receiver_id = :userId AND read = false")
    Mono<Void> markMessagesAsRead(Long chatId, Long userId);
}