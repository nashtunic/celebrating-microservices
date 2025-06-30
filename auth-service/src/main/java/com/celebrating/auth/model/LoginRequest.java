package com.celebrating.auth.model;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {
    private String email;
    private String username;
    
    @NotBlank(message = "Password is required")
    private String password;
    
    private String role;
} 