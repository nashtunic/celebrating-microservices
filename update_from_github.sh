#!/bin/bash

# GitHub repository URL
GITHUB_REPO="https://github.com/nashtunic/celebrating-microservices.git"

echo "Updating repository from GitHub..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Not in a git repository. Cloning fresh copy..."
    cd ..
    rm -rf celebrating-microservices
    git clone "$GITHUB_REPO" celebrating-microservices
    cd celebrating-microservices
else
    echo "Fetching latest changes from GitHub..."
    git fetch origin

    echo "Resetting to match remote state..."
    git reset --hard origin/main

    echo "Cleaning up untracked files..."
    git clean -fd

    echo "Pulling latest changes..."
    git pull origin main
fi

echo "Repository updated successfully!"

# Make the gradle wrapper script executable
chmod +x setup_gradle_wrappers.sh

echo "Running Gradle wrapper setup..."
./setup_gradle_wrappers.sh 