package com.celebrating.user.controller;

import com.celebrating.user.model.User;
import com.celebrating.user.model.CelebrityProfile;
import com.celebrating.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @GetMapping("/celebrities")
    public ResponseEntity<List<User>> getAllCelebrities() {
        return ResponseEntity.ok(userService.getAllCelebrities());
    }

    @GetMapping("/celebrities/search")
    public ResponseEntity<List<User>> searchCelebrities(@RequestParam String query) {
        return ResponseEntity.ok(userService.searchCelebrities(query));
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable UUID id) {
        return userService.getUserById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/username/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        return userService.getUserByUsername(username)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody User user) {
        return ResponseEntity.ok(userService.createUser(user));
    }

    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable UUID id, @RequestBody User userDetails) {
        return userService.updateUser(id, userDetails)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{userId}/celebrity-profile")
    public ResponseEntity<CelebrityProfile> getCelebrityProfile(@PathVariable UUID userId) {
        return userService.getCelebrityProfile(userId)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{userId}/celebrity-profile")
    public ResponseEntity<CelebrityProfile> updateCelebrityProfile(
            @PathVariable UUID userId,
            @RequestBody CelebrityProfile profileDetails) {
        return userService.updateCelebrityProfile(userId, profileDetails)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/celebrity-profiles/search")
    public ResponseEntity<List<CelebrityProfile>> searchCelebrityProfiles(@RequestParam String query) {
        return ResponseEntity.ok(userService.searchCelebrityProfiles(query));
    }
} 