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

    public Flux<Message> getConversation(Long userId1, Long userId2) {
        return messageRepository.findByUserId(userId1)
            .filter(message -> 
                (message.getSenderId().equals(userId1) && message.getReceiverId().equals(userId2)) ||
                (message.getSenderId().equals(userId2) && message.getReceiverId().equals(userId1))
            )
            .sort((m1, m2) -> m2.getCreatedAt().compareTo(m1.getCreatedAt()));
    }

    public Flux<Message> getUnreadMessages(Long receiverId) {
        return messageRepository.findByUserId(receiverId)
            .filter(message -> 
                message.getReceiverId().equals(receiverId) && !message.isRead()
            );
    }

    public Mono<Void> markConversationAsRead(Long receiverId, Long senderId) {
        return messageRepository.findByUserId(receiverId)
            .filter(message -> 
                message.getReceiverId().equals(receiverId) && 
                message.getSenderId().equals(senderId) && 
                !message.isRead()
            )
            .flatMap(message -> {
                message.setRead(true);
                return messageRepository.save(message);
            })
            .then();
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