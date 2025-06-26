package com.celebrating.messaging.service;

import com.celebrating.messaging.model.Chat;
import com.celebrating.messaging.repository.ChatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {
    private final ChatRepository chatRepository;

    @Override
    public Mono<Chat> createChat(Long user1Id, Long user2Id) {
        Chat chat = new Chat();
        chat.setUser1Id(user1Id);
        chat.setUser2Id(user2Id);
        chat.setCreatedAt(LocalDateTime.now());
        chat.setLastMessageAt(LocalDateTime.now());
        chat.setActive(true);
        return chatRepository.save(chat);
    }

    @Override
    public Flux<Chat> getUserChats(Long userId) {
        return chatRepository.findByUser1IdOrUser2IdAndActiveIsTrue(userId, userId);
    }

    @Override
    public Mono<Chat> getChat(Long chatId) {
        return chatRepository.findById(chatId);
    }

    @Override
    public Mono<Void> deactivateChat(Long chatId) {
        return chatRepository.findById(chatId)
                .flatMap(chat -> {
                    chat.setActive(false);
                    return chatRepository.save(chat);
                })
                .then();
    }
} 