package com.celebrating.auth.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.CacheManager;
import org.springframework.stereotype.Service;

@Service
public class LoginAttemptService {
    private static final int MAX_ATTEMPTS = 5;
    private static final String CACHE_NAME = "loginAttempts";

    @Autowired
    private CacheManager cacheManager;

    public void loginSucceeded(String key) {
        cacheManager.getCache(CACHE_NAME).evict(key);
    }

    public void loginFailed(String key) {
        var cache = cacheManager.getCache(CACHE_NAME);
        int attempts = 0;
        var value = cache.get(key);
        if (value != null) {
            attempts = (Integer) value.get();
        }
        attempts++;
        cache.put(key, attempts);
    }

    public boolean isBlocked(String key) {
        var cache = cacheManager.getCache(CACHE_NAME);
        var value = cache.get(key);
        if (value != null) {
            int attempts = (Integer) value.get();
            return attempts >= MAX_ATTEMPTS;
        }
        return false;
    }
} 