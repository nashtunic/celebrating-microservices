package com.celebrate.search.controller;

import com.celebrate.search.model.SearchablePost;
import com.celebrate.search.repository.PostSearchRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/v1/search")
public class SearchController {

    private final PostSearchRepository searchRepository;

    public SearchController(PostSearchRepository searchRepository) {
        this.searchRepository = searchRepository;
    }

    @GetMapping("/posts")
    public ResponseEntity<List<SearchablePost>> searchPosts(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String category) {
        
        if (query != null && !query.isEmpty()) {
            return ResponseEntity.ok(
                searchRepository.findByTitleContainingOrContentContaining(query, query)
            );
        } else if (category != null && !category.isEmpty()) {
            return ResponseEntity.ok(
                searchRepository.findByCategory(category)
            );
        }
        
        return ResponseEntity.ok(
            List.copyOf(searchRepository.findAll())
        );
    }

    @GetMapping("/posts/user/{userId}")
    public ResponseEntity<List<SearchablePost>> getUserPosts(@PathVariable String userId) {
        return ResponseEntity.ok(
            searchRepository.findByUserId(userId)
        );
    }

    @PostMapping("/posts")
    public ResponseEntity<SearchablePost> indexPost(@RequestBody SearchablePost post) {
        return ResponseEntity.ok(
            searchRepository.save(post)
        );
    }

    @DeleteMapping("/posts/{id}")
    public ResponseEntity<Void> deletePost(@PathVariable String id) {
        searchRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }
} 