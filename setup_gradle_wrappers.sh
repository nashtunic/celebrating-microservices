#!/bin/bash

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
        
        # Ensure gradlew script is present
        if [ ! -f "gradlew" ]; then
            echo "gradlew script not found, downloading from original repository..."
            wget "${GITHUB_REPO_RAW_URL}/${service_dir}/gradlew" -O gradlew
            if [ $? -ne 0 ]; then
                echo "Error: Failed to download gradlew for $service_dir."
                cd "$CURRENT_DIR"
                continue
            fi
        fi
        chmod +x gradlew # Ensure it's executable

        # Ensure gradle/wrapper directory exists and gradle-wrapper.properties is present
        mkdir -p gradle/wrapper # Create directory if it doesn't exist

        if [ ! -f "gradle/wrapper/gradle-wrapper.properties" ]; then
            echo "gradle-wrapper.properties not found, downloading from original repository..."
            wget "${GITHUB_REPO_RAW_URL}/${service_dir}/gradle/wrapper/gradle-wrapper.properties" -O gradle/wrapper/gradle-wrapper.properties
            if [ $? -ne 0 ]; then
                echo "Error: Failed to download gradle-wrapper.properties for $service_dir."
                cd "$CURRENT_DIR"
                continue
            fi
        fi

        echo "Running ./gradlew wrapper to ensure full Gradle wrapper setup (will download gradle-wrapper.jar)..."
        # This command should download the full distribution and extract gradle-wrapper.jar
        ./gradlew wrapper
        if [ $? -ne 0 ]; then
            echo "Failed to set up Gradle wrapper for $service_dir."
        else
            echo "Gradle wrapper set up successfully for $service_dir."
        fi
        
        cd "$CURRENT_DIR"
    else
        echo "Directory $service_dir not found, skipping."
    fi
done

echo "\nAll Gradle wrappers processed." 
