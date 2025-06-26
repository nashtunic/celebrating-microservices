package com.celebrating.messaging.controller;

import com.celebrating.messaging.model.Message;
import com.celebrating.messaging.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/messages")
@RequiredArgsConstructor
public class MessageController {
    private final MessageService messageService;

    @PostMapping
    public Mono<Message> sendMessage(@RequestBody Message message) {
        return messageService.sendMessage(message);
    }

    @GetMapping("/chat/{chatId}")
    public Flux<Message> getChatMessages(@PathVariable Long chatId) {
        return messageService.getChatMessages(chatId);
    }

    @GetMapping("/user/{userId}")
    public Flux<Message> getUserMessages(@PathVariable Long userId) {
        return messageService.getUserMessages(userId);
    }

    @GetMapping("/chat/{chatId}/older")
    public Flux<Message> getOlderMessages(
            @PathVariable Long chatId,
            @RequestParam LocalDateTime timestamp,
            @RequestParam(defaultValue = "20") int limit) {
        return messageService.getOlderMessages(chatId, timestamp, limit);
    }

    @GetMapping("/chat/{chatId}/unread/count")
    public Mono<Long> getUnreadMessageCount(
            @PathVariable Long chatId,
            @RequestParam Long userId) {
        return messageService.getUnreadMessageCount(chatId, userId);
    }

    @PostMapping("/chat/{chatId}/read")
    public Mono<Void> markMessagesAsRead(
            @PathVariable Long chatId,
            @RequestParam Long userId) {
        return messageService.markMessagesAsRead(chatId, userId);
    }
}