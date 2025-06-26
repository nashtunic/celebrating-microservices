#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Function to start a service
start_service() {
    local service_name=$1
    local service_dir=$2
    local log_file="logs/${service_name}.log"
    
    echo "Starting $service_name..."
    cd "$service_dir"
    ./gradlew bootRun > "../$log_file" 2>&1 &
    cd ..
    echo "$service_name started. Logs available at $log_file"
    sleep 10  # Wait for service to initialize
}

# Start services in order
echo "Starting all services..."

# 1. Config Server (must start first)
start_service "config-server" "config-server"

# 2. Service Registry (Eureka)
start_service "service-registry" "service-registry"

# 3. API Gateway
start_service "api-gateway" "api-gateway"

# 4. Core Services
start_service "auth-service" "auth-service"
start_service "user-service" "user-service"
start_service "post-service" "post-service"
start_service "messaging-service" "messaging-service"

# 5. Supporting Services
start_service "notification-service" "notification-service"
start_service "news-feed-service" "news-feed-service"
start_service "search-service" "search-service"
start_service "rating-review-service" "rating-review-service"
start_service "award-service" "award-service"
start_service "moderation-service" "moderation-service"
start_service "analytics-logging-service" "analytics-logging-service"

echo "All services started. Check logs directory for service logs."
echo "To stop all services, run: pkill -f 'java.*jar'" 