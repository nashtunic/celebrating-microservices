package com.celebrating.auth.controller;

import com.celebrating.auth.entity.User;
import com.celebrating.auth.service.AuthService;
import com.celebrating.auth.service.JwtService;
import com.celebrating.auth.model.LoginRequest;
import com.celebrating.auth.exception.AuthenticationException;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@CrossOrigin(origins = {
    "http://localhost:3000",
    "http://localhost:8080",
    "http://127.0.0.1:3000",
    "http://localhost",
    "http://localhost:58138",
    "http://127.0.0.1:58138",
    "app://celebrate"
}, allowCredentials = "true")
public class AuthController {
    @Autowired
    private AuthService authService;

    @Autowired
    private JwtService jwtService;

    @PostMapping({"/api/auth/login", "/login"})
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            String identifier = loginRequest.getEmail() != null ? loginRequest.getEmail() : loginRequest.getUsername();
            Map<String, Object> response = authService.login(identifier, loginRequest.getPassword());
            return ResponseEntity.ok(response);
        } catch (AuthenticationException e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.status(401).body(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "An unexpected error occurred");
            return ResponseEntity.status(500).body(response);
        }
    }

    @PostMapping({"/api/auth/register", "/register"})
    public ResponseEntity<?> register(@Valid @RequestBody User user) {
        try {
            if (user.getRole() == null || user.getRole().isEmpty()) {
                user.setRole("USER");
            }
            
            User registeredUser = authService.register(user);
            Map<String, Object> response = authService.login(registeredUser.getUsername(), user.getPassword());
            return ResponseEntity.ok(response);
        } catch (AuthenticationException e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.status(400).body(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "An unexpected error occurred");
            return ResponseEntity.status(500).body(response);
        }
    }

    @PostMapping({"/api/auth/refresh", "/refresh"})
    public ResponseEntity<?> refreshToken(@RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7); // Remove "Bearer " prefix
            Map<String, Object> response = authService.refreshToken(token);
            return ResponseEntity.ok(response);
        } catch (AuthenticationException e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.status(401).body(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "An unexpected error occurred");
            return ResponseEntity.status(500).body(response);
        }
    }

    @PostMapping({"/api/auth/password/reset-request", "/password/reset-request"})
    public ResponseEntity<?> requestPasswordReset(@RequestParam String email) {
        try {
            // TODO: Implement password reset request functionality
            // This should:
            // 1. Generate a password reset token
            // 2. Send an email with the reset link
            // 3. Store the token with an expiration time
            Map<String, String> response = new HashMap<>();
            response.put("message", "Password reset instructions have been sent to your email");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "Failed to process password reset request");
            return ResponseEntity.status(500).body(response);
        }
    }

    @PostMapping({"/api/auth/password/reset", "/password/reset"})
    public ResponseEntity<?> resetPassword(@RequestParam String token, @RequestParam String newPassword) {
        try {
            // TODO: Implement password reset functionality
            // This should:
            // 1. Validate the reset token
            // 2. Update the password if token is valid
            // 3. Invalidate the token after use
            Map<String, String> response = new HashMap<>();
            response.put("message", "Password has been reset successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "Failed to reset password");
            return ResponseEntity.status(500).body(response);
        }
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<?> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        Map<String, Object> response = new HashMap<>();
        response.put("error", "Validation failed");
        response.put("details", errors);
        return ResponseEntity.badRequest().body(response);
    }
} 