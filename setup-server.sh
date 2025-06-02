 #!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Setting up server environment...${NC}"

# Update system packages
echo -e "${YELLOW}Updating system packages...${NC}"
apt-get update
apt-get upgrade -y

# Install required packages
echo -e "${YELLOW}Installing required packages...${NC}"
apt-get install -y \
    openjdk-17-jdk \
    maven \
    git \
    postgresql \
    postgresql-contrib \
    lsof \
    unzip

# Create application directory
APP_DIR="/opt/celebrating-microservices"
echo -e "${YELLOW}Creating application directory at $APP_DIR...${NC}"
mkdir -p $APP_DIR
cd $APP_DIR

# Clone the repository
echo -e "${YELLOW}Cloning the repository...${NC}"
git clone https://github.com/YOUR_USERNAME/celebrating-microservices-main.git .

# Set up PostgreSQL
echo -e "${YELLOW}Setting up PostgreSQL...${NC}"
sudo -u postgres psql -c "CREATE DATABASE celebratedb;"
sudo -u postgres psql -c "CREATE USER celebrate WITH PASSWORD 'celebrate123';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE celebratedb TO celebrate;"

# Build all services
echo -e "${YELLOW}Building all services...${NC}"
services=(
    "config-server"
    "service-registry"
    "api-gateway"
    "auth-service"
    "user-service"
    "post-service"
    "messaging-service"
    "notification-service"
    "search-service"
    "rating-review-service"
    "news-feed-service"
    "award-service"
    "moderation-service"
    "analytics-logging-service"
)

for service in "${services[@]}"; do
    echo -e "${YELLOW}Building $service...${NC}"
    cd $service
    mvn clean package -DskipTests
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Successfully built $service${NC}"
    else
        echo -e "${RED}Failed to build $service${NC}"
        exit 1
    fi
    cd ..
done

# Copy deployment script
cp deploy-services.sh /usr/local/bin/deploy-services
chmod +x /usr/local/bin/deploy-services

echo -e "${GREEN}Server setup completed successfully!${NC}"
echo -e "${YELLOW}Please update the application.yml files in each service with the correct database credentials and other configurations.${NC}"
echo -e "${YELLOW}You can now use 'deploy-services {start|stop|status}' to manage the services.${NC}"