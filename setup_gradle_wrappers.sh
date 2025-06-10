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
        
        echo "Running ./gradlew wrapper to regenerate Gradle files..."
        # Check if gradlew script exists, if not, download it
        if [ ! -f "gradlew" ]; then
            echo "gradlew script not found, downloading..."
            wget https://raw.githubusercontent.com/gradle/gradle/master/gradlew -O gradlew
        fi

        # Ensure gradlew is executable
        chmod +x gradlew

        # Get Gradle distribution URL from properties file
        GRADLE_PROPERTIES="gradle/wrapper/gradle-wrapper.properties"
        if [ ! -f "$GRADLE_PROPERTIES" ]; then
            echo "gradle-wrapper.properties not found, downloading default..."
            wget https://raw.githubusercontent.com/gradle/gradle/master/gradle/wrapper/gradle-wrapper.properties -O "$GRADLE_PROPERTIES"
        fi

        DISTRIBUTION_URL=$(grep "distributionUrl" "$GRADLE_PROPERTIES" | cut -d= -f2 | sed 's/\\//g')
        GRADLE_VERSION=$(echo "$DISTRIBUTION_URL" | grep -o 'gradle-[0-9.]*' | cut -d- -f2)
        GRADLE_WRAPPER_JAR_URL="https://services.gradle.org/distributions/gradle-$GRADLE_VERSION/gradle-$GRADLE_VERSION/lib/gradle-wrapper.jar"

        echo "Downloading gradle-wrapper.jar from $GRADLE_WRAPPER_JAR_URL..."
        wget "$GRADLE_WRAPPER_JAR_URL" -O gradle/wrapper/gradle-wrapper.jar
        
        # Run gradlew wrapper to ensure proper setup and download of gradle-wrapper.jar
        ./gradlew wrapper
        
        if [ $? -eq 0 ]; then
            echo "Successfully set up Gradle wrapper for $service_dir."
        else
            echo "Failed to set up Gradle wrapper for $service_dir."
        fi
        cd "$CURRENT_DIR"
    else
        echo "Directory $service_dir does not exist, skipping."
    fi
done

echo "\nAll Gradle wrappers processed." 
