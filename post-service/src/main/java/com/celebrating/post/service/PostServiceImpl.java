package com.celebrating.post.service;

import com.celebrating.post.model.Post;
import com.celebrating.post.model.Comment;
import com.celebrating.post.model.Like;
import com.celebrating.post.repository.PostRepository;
import com.celebrating.post.repository.CommentRepository;
import com.celebrating.post.repository.LikeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class PostServiceImpl implements PostService {
    private final PostRepository postRepository;
    private final CommentRepository commentRepository;
    private final LikeRepository likeRepository;

    @Override
    public Mono<Post> createPost(Post post) {
        post.setCreatedAt(LocalDateTime.now());
        post.setUpdatedAt(LocalDateTime.now());
        post.setStatus(PostStatus.ACTIVE);
        post.setLikesCount(0);
        post.setCommentsCount(0);
        return postRepository.save(post);
    }

    @Override
    public Mono<Post> updatePost(Long id, Post post) {
        return postRepository.findById(id)
                .flatMap(existingPost -> {
                    existingPost.setTitle(post.getTitle());
                    existingPost.setContent(post.getContent());
                    existingPost.setCelebrationType(post.getCelebrationType());
                    existingPost.setMediaUrls(post.getMediaUrls());
                    existingPost.setUpdatedAt(LocalDateTime.now());
                    return postRepository.save(existingPost);
                });
    }

    @Override
    public Mono<Post> getPost(Long id) {
        return postRepository.findById(id);
    }

    @Override
    public Mono<Void> deletePost(Long id) {
        return postRepository.findById(id)
                .flatMap(post -> {
                    post.setStatus(PostStatus.DELETED);
                    return postRepository.save(post);
                })
                .then();
    }

    @Override
    public Flux<Post> getUserPosts(Long userId) {
        return postRepository.findByUserId(userId);
    }

    @Override
    public Flux<Post> getRecentPosts(int page, int size) {
        return postRepository.findRecentPosts(page, size);
    }

    @Override
    public Flux<Post> getPostsByCelebrationType(String celebrationType) {
        return postRepository.findByCelebrationType(celebrationType);
    }

    @Override
    public Mono<Comment> addComment(Comment comment) {
        comment.setCreatedAt(LocalDateTime.now());
        comment.setUpdatedAt(LocalDateTime.now());
        return commentRepository.save(comment)
                .flatMap(savedComment -> 
                    postRepository.updateCommentsCount(comment.getPostId(), 1)
                        .thenReturn(savedComment)
                );
    }

    @Override
    public Mono<Void> deleteComment(Long commentId) {
        return commentRepository.findById(commentId)
                .flatMap(comment -> 
                    commentRepository.delete(comment)
                        .then(postRepository.updateCommentsCount(comment.getPostId(), -1))
                );
    }

    @Override
    public Flux<Comment> getPostComments(Long postId) {
        return commentRepository.findByPostId(postId);
    }

    @Override
    public Mono<Like> likePost(Long postId, Long userId) {
        Like like = new Like();
        like.setPostId(postId);
        like.setUserId(userId);
        like.setCreatedAt(LocalDateTime.now());
        
        return likeRepository.findByPostIdAndUserId(like.getPostId(), like.getUserId())
                .flatMap(existingLike -> Mono.just(existingLike))
                .switchIfEmpty(
                    likeRepository.save(like)
                        .flatMap(savedLike -> 
                            postRepository.updateLikesCount(like.getPostId(), 1)
                                .thenReturn(savedLike)
                        )
                );
    }

    @Override
    public Mono<Void> unlikePost(Long postId, Long userId) {
        return likeRepository.deleteByPostIdAndUserId(postId, userId)
                .then(postRepository.updateLikesCount(postId, -1));
    }

    @Override
    public Flux<Like> getPostLikes(Long postId) {
        return likeRepository.findByPostId(postId);
    }
}
