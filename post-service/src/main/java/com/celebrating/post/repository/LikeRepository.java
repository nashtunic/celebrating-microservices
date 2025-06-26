package com.celebrating.post.repository;

import com.celebrating.post.model.Like;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface LikeRepository extends R2dbcRepository<Like, Long> {
    Mono<Like> findByPostIdAndUserId(Long postId, Long userId);
    Flux<Like> findByPostId(Long postId);
    Mono<Void> deleteByPostIdAndUserId(Long postId, Long userId);
}