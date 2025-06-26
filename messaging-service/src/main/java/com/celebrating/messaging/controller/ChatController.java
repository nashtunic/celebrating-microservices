package com.celebrating.messaging.controller;

import com.celebrating.messaging.model.Chat;
import com.celebrating.messaging.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/chats")
@RequiredArgsConstructor
public class ChatController {
    private final ChatService chatService;

    @PostMapping
    public Mono<Chat> createChat(
            @RequestParam Long user1Id,
            @RequestParam Long user2Id) {
        return chatService.createChat(user1Id, user2Id);
    }

    @GetMapping("/user/{userId}")
    public Flux<Chat> getUserChats(@PathVariable Long userId) {
        return chatService.getUserChats(userId);
    }

    @GetMapping("/{chatId}")
    public Mono<Chat> getChat(@PathVariable Long chatId) {
        return chatService.getChat(chatId);
    }

    @PostMapping("/{chatId}/deactivate")
    public Mono<Void> deactivateChat(@PathVariable Long chatId) {
        return chatService.deactivateChat(chatId);
    }
} 