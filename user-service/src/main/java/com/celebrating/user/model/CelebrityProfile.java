package com.celebrating.user.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@Entity
@Table(name = "celebrity_profiles")
public class CelebrityProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "stage_name")
    private String stageName;

    @Column(name = "professions")
    @ElementCollection
    private List<String> professions;

    @Column(name = "major_achievements")
    @ElementCollection
    private List<String> majorAchievements;

    @Column(name = "notable_projects")
    @ElementCollection
    private List<String> notableProjects;

    @Column(name = "collaborations")
    @ElementCollection
    private List<String> collaborations;

    @Column(name = "net_worth")
    private String netWorth;

    @Column(name = "verified_at")
    private ZonedDateTime verifiedAt;

    @Column(name = "created_at")
    private ZonedDateTime createdAt;

    @Column(name = "updated_at")
    private ZonedDateTime updatedAt;
} 