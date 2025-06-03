package com.celebrating.post.repository;

import com.celebrating.post.model.Post;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.data.r2dbc.repository.Query;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface PostRepository extends R2dbcRepository<Post, Long> {
    Flux<Post> findByUserId(Long userId);
    
    @Query("SELECT * FROM posts WHERE status = 'ACTIVE' ORDER BY created_at DESC LIMIT :size OFFSET :page * :size")
    Flux<Post> findRecentPosts(int page, int size);
    
    @Query("SELECT * FROM posts WHERE celebration_type = :celebrationType AND status = 'ACTIVE' ORDER BY created_at DESC")
    Flux<Post> findByCelebrationType(String celebrationType);
    
    @Query("UPDATE posts SET likes_count = likes_count + :increment WHERE id = :postId")
    Mono<Void> updateLikesCount(Long postId, int increment);
    
    @Query("UPDATE posts SET comments_count = comments_count + :increment WHERE id = :postId")
    Mono<Void> updateCommentsCount(Long postId, int increment);
}
