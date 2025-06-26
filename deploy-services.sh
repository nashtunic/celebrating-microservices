#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Service ports
CONFIG_SERVER_PORT=8888
SERVICE_REGISTRY_PORT=8761
API_GATEWAY_PORT=8080
AUTH_SERVICE_PORT=9000
USER_SERVICE_PORT=9001
POST_SERVICE_PORT=9002
MESSAGING_SERVICE_PORT=9003
NOTIFICATION_SERVICE_PORT=9004
SEARCH_SERVICE_PORT=9005
RATING_REVIEW_PORT=9006
NEWS_FEED_PORT=9007
AWARD_SERVICE_PORT=9008
MODERATION_SERVICE_PORT=9009
ANALYTICS_PORT=9010

# Function to check if a port is in use
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        return 0
    else
        return 1
    fi
}

# Function to start a service
start_service() {
    service_name=$1
    port=$2
    
    echo -e "${YELLOW}Starting $service_name on port $port...${NC}"
    
    if check_port $port; then
        echo -e "${RED}Port $port is already in use. Cannot start $service_name${NC}"
        return 1
    fi
    
    # Create logs directory if it doesn't exist
    mkdir -p logs
    
    cd $service_name
    
    # First ensure gradlew is executable
    chmod +x ./gradlew
    
    echo -e "${YELLOW}Building $service_name...${NC}"
    # Run gradle build with --no-daemon to avoid any daemon issues
    ./gradlew clean build -x test --no-daemon
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to build $service_name${NC}"
        cd ..
        return 1
    fi
    
    # Find the correct JAR file (excluding the -plain.jar)
    JAR_PATH="$(pwd)/build/libs/$service_name-0.0.1-SNAPSHOT.jar"
    if [ ! -f "$JAR_PATH" ]; then
        echo -e "${RED}JAR file not found at $JAR_PATH${NC}"
        cd ..
        return 1
    fi
    
    echo -e "${YELLOW}Starting $service_name with JAR: $JAR_PATH${NC}"
    # Run the JAR with proper Java options
    nohup java -jar "$JAR_PATH" --spring.profiles.active=default > ../logs/$service_name.log 2>&1 &
    echo $! > ../logs/$service_name.pid
    cd ..
    
    # Wait for service to start
    sleep 10
    if check_port $port; then
        echo -e "${GREEN}$service_name started successfully on port $port${NC}"
    else
        echo -e "${RED}Failed to start $service_name${NC}"
        return 1
    fi
}

# Function to stop a service
stop_service() {
    service_name=$1
    if [ -f "$service_name/$service_name.pid" ]; then
        pid=$(cat $service_name/$service_name.pid)
        echo -e "${YELLOW}Stopping $service_name (PID: $pid)...${NC}"
        kill $pid
        rm $service_name/$service_name.pid
        echo -e "${GREEN}$service_name stopped${NC}"
    else
        echo -e "${RED}$service_name is not running${NC}"
    fi
}

# Function to check service status
check_status() {
    service_name=$1
    port=$2
    
    if [ -f "$service_name/$service_name.pid" ]; then
        pid=$(cat $service_name/$service_name.pid)
        if ps -p $pid > /dev/null; then
            echo -e "${GREEN}$service_name is running (PID: $pid)${NC}"
        else
            echo -e "${RED}$service_name is not running${NC}"
            rm $service_name/$service_name.pid
        fi
    else
        echo -e "${RED}$service_name is not running${NC}"
    fi
}

case "$1" in
    "start")
        # Start services in order
        start_service "config-server" $CONFIG_SERVER_PORT
        sleep 10
        start_service "service-registry" $SERVICE_REGISTRY_PORT
        sleep 10
        start_service "api-gateway" $API_GATEWAY_PORT
        sleep 10
        start_service "auth-service" $AUTH_SERVICE_PORT
        start_service "user-service" $USER_SERVICE_PORT
        start_service "post-service" $POST_SERVICE_PORT
        start_service "messaging-service" $MESSAGING_SERVICE_PORT
        start_service "notification-service" $NOTIFICATION_SERVICE_PORT
        start_service "search-service" $SEARCH_SERVICE_PORT
        start_service "rating-review-service" $RATING_REVIEW_PORT
        start_service "news-feed-service" $NEWS_FEED_PORT
        start_service "award-service" $AWARD_SERVICE_PORT
        start_service "moderation-service" $MODERATION_SERVICE_PORT
        start_service "analytics-logging-service" $ANALYTICS_PORT
        ;;
        
    "stop")
        # Stop services in reverse order
        stop_service "analytics-logging-service"
        stop_service "moderation-service"
        stop_service "award-service"
        stop_service "news-feed-service"
        stop_service "rating-review-service"
        stop_service "search-service"
        stop_service "notification-service"
        stop_service "messaging-service"
        stop_service "post-service"
        stop_service "user-service"
        stop_service "auth-service"
        stop_service "api-gateway"
        stop_service "service-registry"
        stop_service "config-server"
        ;;
        
    "status")
        # Check status of all services
        check_status "config-server" $CONFIG_SERVER_PORT
        check_status "service-registry" $SERVICE_REGISTRY_PORT
        check_status "api-gateway" $API_GATEWAY_PORT
        check_status "auth-service" $AUTH_SERVICE_PORT
        check_status "user-service" $USER_SERVICE_PORT
        check_status "post-service" $POST_SERVICE_PORT
        check_status "messaging-service" $MESSAGING_SERVICE_PORT
        check_status "notification-service" $NOTIFICATION_SERVICE_PORT
        check_status "search-service" $SEARCH_SERVICE_PORT
        check_status "rating-review-service" $RATING_REVIEW_PORT
        check_status "news-feed-service" $NEWS_FEED_PORT
        check_status "award-service" $AWARD_SERVICE_PORT
        check_status "moderation-service" $MODERATION_SERVICE_PORT
        check_status "analytics-logging-service" $ANALYTICS_PORT
        ;;
        
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac

exit 0 