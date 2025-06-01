package com.celebrating.post.controller;

import com.celebrating.post.model.Post;
import com.celebrating.post.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<Post> createPost(@Valid @RequestBody Post post) {
        return postService.createPost(post);
    }

    @PutMapping("/{id}")
    public Mono<Post> updatePost(@PathVariable Long id, @Valid @RequestBody Post post) {
        return postService.updatePost(id, post);
    }

    @GetMapping("/{id}")
    public Mono<Post> getPost(@PathVariable Long id) {
        return postService.getPost(id);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> deletePost(@PathVariable Long id) {
        return postService.deletePost(id);
    }

    @GetMapping("/user/{userId}")
    public Flux<Post> getUserPosts(@PathVariable Long userId) {
        return postService.getUserPosts(userId);
    }

    @GetMapping
    public Flux<Post> getRecentPosts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return postService.getRecentPosts(page, size);
    }

    @GetMapping("/type/{celebrationType}")
    public Flux<Post> getPostsByCelebrationType(@PathVariable String celebrationType) {
        return postService.getPostsByCelebrationType(celebrationType);
    }
} 
        return postService.unlikePost(postId, userId);
    }

    @GetMapping("/{postId}/likes")
    public Flux<Like> getPostLikes(@PathVariable Long postId) {
        return postService.getPostLikes(postId);
    }
}