package com.celebrate.award.controller;

import com.celebrate.award.dto.UserAwardDTO;
import com.celebrate.award.service.UserAwardService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/v1/user-awards")
public class UserAwardController {
    private final UserAwardService userAwardService;

    public UserAwardController(UserAwardService userAwardService) {
        this.userAwardService = userAwardService;
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<UserAwardDTO>> getUserAwards(@PathVariable Long userId) {
        return ResponseEntity.ok(userAwardService.getUserAwards(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserAwardDTO> getUserAwardById(@PathVariable Long id) {
        return ResponseEntity.ok(userAwardService.getUserAwardById(id));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'MODERATOR')")
    public ResponseEntity<UserAwardDTO> grantAward(@Valid @RequestBody UserAwardDTO userAwardDTO) {
        return new ResponseEntity<>(userAwardService.grantAward(userAwardDTO), HttpStatus.CREATED);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MODERATOR')")
    public ResponseEntity<Void> revokeAward(@PathVariable Long id) {
        userAwardService.revokeAward(id);
        return ResponseEntity.noContent().build();
    }
} 