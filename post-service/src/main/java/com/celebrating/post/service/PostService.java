package com.celebrating.post.service;

import com.celebrating.post.model.Post;
import com.celebrating.post.model.Comment;
import com.celebrating.post.model.Like;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface PostService {
    Mono<Post> createPost(Post post);
    Mono<Post> updatePost(Long id, Post post);
    Mono<Post> getPost(Long id);
    Mono<Void> deletePost(Long id);
    Flux<Post> getUserPosts(Long userId);
    Flux<Post> getRecentPosts(int page, int size);
    Flux<Post> getPostsByCelebrationType(String celebrationType);
    
    Mono<Comment> addComment(Comment comment);
    Mono<Void> deleteComment(Long commentId);
    Flux<Comment> getPostComments(Long postId);
    
    Mono<Like> likePost(Long postId, Long userId);
    Mono<Void> unlikePost(Long postId, Long userId);
    Flux<Like> getPostLikes(Long postId);
}
