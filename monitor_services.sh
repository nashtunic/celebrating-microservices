#!/bin/bash

# This script monitors the status of all microservices.

SERVICE_PORTS=(
    "service-registry:8761"
    "config-server:8888"
    "api-gateway:8080"
    "auth-service:8081"
    "user-service:8082"
    "post-service:8083"
    "messaging-service:8084"
    "news-feed-service:8085"
    "moderation-service:8086"
    "notification-service:8087"
    "search-service:8088"
    "award-service:8089"
    "rating-review-service:8090"
    "analytics-logging-service:8091"
)

echo "Monitoring Microservices Status:"
echo "-----------------------------------"

for entry in "${SERVICE_PORTS[@]}"; do
    SERVICE_NAME="${entry%:*}"
    PORT="${entry#*:}"

    # Check if a process is listening on the port
    PID=$(sudo lsof -t -i:"$PORT")

    if [ -z "$PID" ]; then
        echo "[ ✖ ] $SERVICE_NAME (Port: $PORT) - NOT RUNNING. Consider checking logs in the service directory for errors."
    else
        echo "[ ✔ ] $SERVICE_NAME (Port: $PORT) - RUNNING (PID: $PID)"
    fi
done

echo "-----------------------------------" 