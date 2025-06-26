#!/bin/bash

# This script stops a running microservice by its name.

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

if [ -z "$1" ]; then
    echo "Usage: $0 <service_name>"
    echo "Available services:"
    for entry in "${SERVICE_PORTS[@]}"; do
        SERVICE_NAME="${entry%:*}"
        echo "  - $SERVICE_NAME"
    done
    exit 1
fi

SERVICE_NAME="$1"
PORT=""

for entry in "${SERVICE_PORTS[@]}"; do
    if [[ "${entry%:*}" == "$SERVICE_NAME" ]]; then
        PORT="${entry#*:}"
        break
    fi
done

if [ -z "$PORT" ]; then
    echo "Error: Service '$SERVICE_NAME' not found in the list of known services."
    echo "Available services:"
    for entry in "${SERVICE_PORTS[@]}"; do
        SERVICE_NAME_LIST="${entry%:*}"
        echo "  - $SERVICE_NAME_LIST"
    done
    exit 1
fi

echo "Attempting to stop $SERVICE_NAME (port: $PORT)..."

# Find all PIDs listening on the port and kill them
PIDS=$(sudo lsof -t -i:"$PORT")

if [ -z "$PIDS" ]; then
    echo "No process found running on port $PORT for $SERVICE_NAME."
else
    echo "Found processes with PIDs: $PIDS on port $PORT. Killing processes..."
    for PID in $PIDS; do
        sudo kill -9 "$PID"
        if [ $? -eq 0 ]; then
            echo "$SERVICE_NAME (PID $PID) stopped successfully."
        else
            echo "Error: Failed to stop $SERVICE_NAME (PID $PID)."
        fi
    done
fi 