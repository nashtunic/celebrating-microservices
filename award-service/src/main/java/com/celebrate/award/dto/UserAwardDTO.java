package com.celebrate.award.dto;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

public class UserAwardDTO {
    private Long id;
    
    @NotNull(message = "User ID is required")
    private Long userId;
    
    @NotNull(message = "Award ID is required")
    private Long awardId;
    
    private LocalDateTime awardedAt;
    private Long awardedBy;
    private String reason;
    private AwardDTO award;

    // Default constructor
    public UserAwardDTO() {}

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getAwardId() {
        return awardId;
    }

    public void setAwardId(Long awardId) {
        this.awardId = awardId;
    }

    public LocalDateTime getAwardedAt() {
        return awardedAt;
    }

    public void setAwardedAt(LocalDateTime awardedAt) {
        this.awardedAt = awardedAt;
    }

    public Long getAwardedBy() {
        return awardedBy;
    }

    public void setAwardedBy(Long awardedBy) {
        this.awardedBy = awardedBy;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public AwardDTO getAward() {
        return award;
    }

    public void setAward(AwardDTO award) {
        this.award = award;
    }
} 