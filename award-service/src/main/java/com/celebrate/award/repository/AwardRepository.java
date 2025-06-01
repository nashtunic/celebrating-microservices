package com.celebrate.award.repository;

import com.celebrate.award.model.Award;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AwardRepository extends JpaRepository<Award, Long> {
    boolean existsByName(String name);
} 