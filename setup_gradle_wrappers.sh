#!/bin/bash

# GitHub repository raw URL
GITHUB_REPO_RAW_URL="https://raw.githubusercontent.com/nashtunic/celebrating-microservices/main"

# Array of service directories
SERVICE_DIRS=(
    "api-gateway"
    "auth-service"
    "user-service"
    "post-service"
    "messaging-service"
    "notification-service"
    "news-feed-service"
    "search-service"
    "rating-review-service"
    "award-service"
    "moderation-service"
    "analytics-logging-service"
    "config-server"
    "service-registry"
    "monitoring-service"
    # Add any other service directories here if they use Gradle
)

CURRENT_DIR=$(pwd)

for service_dir in "${SERVICE_DIRS[@]}"; do
    echo "\nProcessing $service_dir..."
    if [ -d "$service_dir" ]; then
        cd "$service_dir" || { echo "Failed to change directory to $service_dir"; continue; }
        
        echo "Cleaning up existing Gradle wrapper files..."
        rm -rf .gradle gradle/wrapper
        mkdir -p gradle/wrapper
        
        # Download gradlew script
        echo "Downloading gradlew script..."
        wget "${GITHUB_REPO_RAW_URL}/${service_dir}/gradlew" -O gradlew
        if [ $? -ne 0 ]; then
            echo "Error: Failed to download gradlew for $service_dir."
            cd "$CURRENT_DIR"
            continue
        fi
        chmod +x gradlew

        # Download gradle-wrapper.properties
        echo "Downloading gradle-wrapper.properties..."
        wget "${GITHUB_REPO_RAW_URL}/${service_dir}/gradle/wrapper/gradle-wrapper.properties" -O gradle/wrapper/gradle-wrapper.properties
        if [ $? -ne 0 ]; then
            echo "Error: Failed to download gradle-wrapper.properties for $service_dir."
            cd "$CURRENT_DIR"
            continue
        fi

        # Generate gradle-wrapper.jar using gradle wrapper command
        echo "Generating gradle-wrapper.jar..."
        gradle wrapper
        if [ $? -ne 0 ]; then
            echo "Error: Failed to generate gradle-wrapper.jar for $service_dir."
            cd "$CURRENT_DIR"
            continue
        fi

        echo "Gradle wrapper set up successfully for $service_dir."
        cd "$CURRENT_DIR"
    else
        echo "Directory $service_dir not found, skipping."
    fi
done

echo "\nAll Gradle wrappers processed." 