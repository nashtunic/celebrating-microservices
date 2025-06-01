package com.celebrating.user.repository;

import com.celebrating.user.model.CelebrityProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface CelebrityProfileRepository extends JpaRepository<CelebrityProfile, UUID> {
    Optional<CelebrityProfile> findByUserId(UUID userId);
    
    @Query("SELECT cp FROM CelebrityProfile cp WHERE " +
           "LOWER(cp.stageName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "EXISTS (SELECT 1 FROM cp.professions p WHERE LOWER(p) LIKE LOWER(CONCAT('%', :query, '%')))")
    List<CelebrityProfile> searchCelebrityProfiles(String query);
} 