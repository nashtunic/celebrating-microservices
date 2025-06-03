package com.celebrating.messaging.service;

import com.celebrating.messaging.model.Message;
import com.celebrating.messaging.repository.MessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class MessageService {
    private final MessageRepository messageRepository;

    public Mono<Message> sendMessage(Message message) {
        message.setCreatedAt(LocalDateTime.now());
        message.setRead(false);
        return messageRepository.save(message);
    }

    public Flux<Message> getChatMessages(Long chatId) {
        return messageRepository.findByChatId(chatId);
    }

    public Flux<Message> getUserMessages(Long userId) {
        return messageRepository.findByUserId(userId);
    }

    public Flux<Message> getOlderMessages(Long chatId, LocalDateTime timestamp, int limit) {
        return messageRepository.findOlderMessages(chatId, timestamp, limit);
    }

    public Mono<Long> getUnreadMessageCount(Long chatId, Long userId) {
        return messageRepository.countUnreadMessages(chatId, userId);
    }

    public Mono<Void> markMessagesAsRead(Long chatId, Long userId) {
        return messageRepository.markMessagesAsRead(chatId, userId);
    }
}
