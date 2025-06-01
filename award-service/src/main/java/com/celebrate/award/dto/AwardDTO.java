package com.celebrate.award.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;

public class AwardDTO {
    private Long id;
    
    @NotBlank(message = "Award name is required")
    private String name;
    
    @NotBlank(message = "Award description is required")
    private String description;
    
    private String iconUrl;
    
    @NotNull(message = "Points value is required")
    @Min(value = 0, message = "Points value must be non-negative")
    private Integer pointsValue;

    // Default constructor
    public AwardDTO() {}

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public Integer getPointsValue() {
        return pointsValue;
    }

    public void setPointsValue(Integer pointsValue) {
        this.pointsValue = pointsValue;
    }
} 