package com.celebrating.messaging.service;

import com.celebrating.messaging.model.Chat;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ChatService {
    Mono<Chat> createChat(Long user1Id, Long user2Id);
    Flux<Chat> getUserChats(Long userId);
    Mono<Chat> getChat(Long chatId);
    Mono<Void> deactivateChat(Long chatId);
} 