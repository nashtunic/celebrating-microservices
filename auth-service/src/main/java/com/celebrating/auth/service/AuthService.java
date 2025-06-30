package com.celebrating.auth.service;

import com.celebrating.auth.entity.User;
import com.celebrating.auth.repository.UserRepository;
import com.celebrating.auth.exception.AuthenticationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class AuthService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private LoginAttemptService loginAttemptService;

    @Transactional
    public Map<String, Object> login(String identifier, String password) {
        String ipAddress = getClientIP();
        if (loginAttemptService.isBlocked(ipAddress)) {
            throw new AuthenticationException("Account is temporarily locked due to too many failed attempts. Please try again later.");
        }

        try {
            User user = userRepository.findByEmail(identifier)
                .orElseGet(() -> userRepository.findByUsername(identifier)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found")));

            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(user.getUsername(), password)
            );

            if (authentication.isAuthenticated()) {
                loginAttemptService.loginSucceeded(ipAddress);
                user.setLastLogin(LocalDateTime.now());
                user = userRepository.save(user);

                String accessToken = jwtService.generateToken(user.getUsername());
                String refreshToken = jwtService.generateRefreshToken(user.getUsername());

                Map<String, Object> response = new HashMap<>();
                response.put("accessToken", accessToken);
                response.put("refreshToken", refreshToken);
                response.put("userId", user.getId());
                response.put("username", user.getUsername());
                response.put("email", user.getEmail());
                response.put("role", user.getRole());
                response.put("fullName", user.getFullName());
                response.put("lastLogin", user.getLastLogin());
                response.put("isActive", user.isActive());

                return response;
            }
            loginAttemptService.loginFailed(ipAddress);
            throw new AuthenticationException("Invalid credentials");
        } catch (Exception e) {
            loginAttemptService.loginFailed(ipAddress);
            throw new AuthenticationException("Invalid credentials");
        }
    }

    @Transactional
    public Map<String, Object> refreshToken(String refreshToken) {
        if (!jwtService.validateToken(refreshToken)) {
            throw new AuthenticationException("Invalid refresh token");
        }

        String username = jwtService.extractUsername(refreshToken);
        User user = getUserByUsername(username);

        String newAccessToken = jwtService.generateToken(username);
        String newRefreshToken = jwtService.generateRefreshToken(username);

        Map<String, Object> response = new HashMap<>();
        response.put("accessToken", newAccessToken);
        response.put("refreshToken", newRefreshToken);
        response.put("userId", user.getId());
        response.put("username", user.getUsername());
        return response;
    }

    @Transactional
    public User register(User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new AuthenticationException("Username already exists");
        }
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new AuthenticationException("Email already exists");
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setCreatedAt(LocalDateTime.now());
        user.setActive(true);
        if (user.getRole() == null) {
            user.setRole("USER");
        }
        
        return userRepository.save(user);
    }

    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email)
            .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
    }

    private String getClientIP() {
        // In a real application, you would get this from the HttpServletRequest
        // For now, we'll use a placeholder
        return "127.0.0.1";
    }
} 