package com.celebrating.user.service;

import com.celebrating.user.model.User;
import com.celebrating.user.model.CelebrityProfile;
import com.celebrating.user.model.UserStats;
import com.celebrating.user.repository.UserRepository;
import com.celebrating.user.repository.CelebrityProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final CelebrityProfileRepository celebrityProfileRepository;

    @Transactional(readOnly = true)
    public List<User> getAllCelebrities() {
        return userRepository.findAllCelebrities();
    }

    @Transactional(readOnly = true)
    public List<User> searchCelebrities(String query) {
        return userRepository.searchCelebrities(query);
    }

    @Transactional(readOnly = true)
    public Optional<User> getUserById(UUID id) {
        return userRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Transactional
    public User createUser(User user) {
        // Initialize user stats
        UserStats stats = new UserStats();
        stats.setUser(user);
        user.setStats(stats);

        // If user is a celebrity, create celebrity profile
        if ("CELEBRITY".equals(user.getRole())) {
            CelebrityProfile profile = new CelebrityProfile();
            profile.setUser(user);
            user.setCelebrityProfile(profile);
        }

        return userRepository.save(user);
    }

    @Transactional
    public Optional<User> updateUser(UUID id, User userDetails) {
        return userRepository.findById(id)
            .map(user -> {
                user.setFullName(userDetails.getFullName());
                user.setBio(userDetails.getBio());
                user.setLocation(userDetails.getLocation());
                user.setProfileImageUrl(userDetails.getProfileImageUrl());
                user.setPrivate(userDetails.isPrivate());
                return userRepository.save(user);
            });
    }

    @Transactional
    public Optional<CelebrityProfile> updateCelebrityProfile(UUID userId, CelebrityProfile profileDetails) {
        return celebrityProfileRepository.findByUserId(userId)
            .map(profile -> {
                profile.setStageName(profileDetails.getStageName());
                profile.setProfessions(profileDetails.getProfessions());
                profile.setMajorAchievements(profileDetails.getMajorAchievements());
                profile.setNotableProjects(profileDetails.getNotableProjects());
                profile.setCollaborations(profileDetails.getCollaborations());
                profile.setNetWorth(profileDetails.getNetWorth());
                return celebrityProfileRepository.save(profile);
            });
    }

    @Transactional(readOnly = true)
    public Optional<CelebrityProfile> getCelebrityProfile(UUID userId) {
        return celebrityProfileRepository.findByUserId(userId);
    }

    @Transactional(readOnly = true)
    public List<CelebrityProfile> searchCelebrityProfiles(String query) {
        return celebrityProfileRepository.searchCelebrityProfiles(query);
    }
} 