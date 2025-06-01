 

import com.celebrating.messaging.model.Message;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.data.r2dbc.repository.Query;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface MessageRepository extends R2dbcRepository<Message, Long> {
    Flux<Message> findBySenderIdAndReceiverId(Long senderId, Long receiverId);
    
    @Query("SELECT * FROM messages WHERE (sender_id = :userId1 AND receiver_id = :userId2) OR (sender_id = :userId2 AND receiver_id = :userId1) ORDER BY created_at DESC")
    Flux<Message> findConversation(Long userId1, Long userId2);
    
    Flux<Message> findByReceiverIdAndIsReadFalse(Long receiverId);
    
    @Query("UPDATE messages SET is_read = true WHERE receiver_id = :receiverId AND sender_id = :senderId")
    Mono<Void> markConversationAsRead(Long receiverId, Long senderId);
}