package com.celebrate.award.repository;

import com.celebrate.award.model.UserAward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface UserAwardRepository extends JpaRepository<UserAward, Long> {
    List<UserAward> findByUserId(Long userId);
    List<UserAward> findByAwardId(Long awardId);
    List<UserAward> findByUserIdAndAwardId(Long userId, Long awardId);
} 