# Celebrating Microservices

A comprehensive celebrity management platform built with microservices architecture and Flutter mobile application.

## System Architecture

### Backend Services

1. **Service Registry (Eureka)** - Port 8761
   - Service discovery and registration
   - Health monitoring
   - Load balancing support
   - Dashboard: http://localhost:8761

2. **Config Server** - Port 8888
   - Centralized configuration management
   - Git-based config repository
   - Dynamic configuration updates
   - Supports multiple environments

3. **API Gateway** - Port 8080
   - Request routing and load balancing
   - Global CORS configuration
   - Authentication and authorization
   - Rate limiting and circuit breaking
   - Swagger UI: http://localhost:8080/swagger-ui.html

4. **Auth Service** - Port 8081
   - User authentication and authorization
   - JWT token management
   - Role-based access control (CELEBRITY/USER)
   - Password encryption using BCrypt
   - Secure token storage

5. **User Service** - Port 8082
   - User profile management
   - Celebrity profile management
   - Account settings and preferences
   - Profile verification system

6. **Post Service** - Port 8083
   - Create and manage posts
   - Media handling (images/videos)
   - Post interactions (likes/comments)
   - Content sharing functionality

7. **Messaging Service** - Port 8084
   - Real-time messaging system
   - Private conversations
   - Message status tracking
   - Read receipts

8. **News Feed Service** - Port 8085
   - Personalized feed generation
   - Content aggregation
   - Feed preferences
   - Trending content algorithm

9. **Moderation Service** - Port 8086
   - Content moderation
   - Report handling
   - Community guidelines enforcement
   - Automated content filtering

10. **Notification Service** - Port 8087
    - Push notifications
    - Email notifications
    - In-app notifications
    - Notification preferences

11. **Search Service** - Port 8088
    - Full-text search
    - Advanced filtering
    - Search analytics
    - Celebrity discovery

12. **Award Service** - Port 8089
    - Achievement management
    - Badge system
    - Rewards tracking
    - Recognition programs

13. **Rating & Review Service** - Port 8090
    - User ratings
    - Review management
    - Reputation system
    - Feedback analysis

14. **Analytics & Logging Service** - Port 8091
    - User analytics
    - System metrics
    - Audit logging
    - Performance monitoring

### Mobile Application (Flutter)

The mobile application is built using Flutter and provides:

1. **Authentication**
   - User registration with role selection
   - Secure login system
   - Password recovery
   - Session management

2. **Celebrity Profiles**
   - Comprehensive profile management
   - Multiple information sections
   - Media gallery
   - Career highlights

3. **Feed System**
   - Celebrity content feed
   - Post interactions
   - Content sharing
   - Media support

4. **Notifications**
   - Real-time notifications
   - Multiple notification types
   - Read status tracking
   - Notification management

5. **Messaging**
   - Direct messaging
   - Real-time chat
   - Message status
   - Media sharing

## Prerequisites

### Backend Requirements
- Java 17 or higher
- PostgreSQL 15+
- Gradle 7.x
- Docker (optional)

### Mobile App Requirements
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code
- iOS development tools (for iOS builds)

## Database Setup

1. Install PostgreSQL 15 or higher

2. Create and configure the database:
```bash
# Run the database setup script
./setup_database.bat  # Windows
./setup_database.sh   # Linux/Mac
```

The script will:
- Create the celebratedb database
- Set up all necessary tables
- Create indexes for optimization
- Configure permissions
- Set up triggers for timestamps

### Database Schema

The system uses a single database (celebratedb) with the following key tables:

1. **users**
   - Basic user information
   - Authentication details
   - Role management

2. **celebrity_profiles**
   - Detailed celebrity information
   - Career and personal details
   - Verification status

3. **posts**
   - User-generated content
   - Media attachments
   - Interaction metrics

4. **comments**
   - Post interactions
   - User engagement
   - Nested discussions

5. **likes**
   - Content appreciation
   - Engagement tracking
   - Analytics support

6. **followers**
   - User relationships
   - Following system
   - Fan management

7. **notifications**
   - System notifications
   - User alerts
   - Event tracking

8. **messages**
   - Direct communication
   - Chat history
   - Message status

## Service Startup

### Using Scripts
```bash
# Windows
start-services.bat

# Linux/Mac
./start-services.sh
```

### Manual Startup Sequence

1. Start core infrastructure:
   ```bash
# 1. Service Registry
cd service-registry && ./gradlew bootRun

# 2. Config Server
cd config-server && ./gradlew bootRun

# 3. API Gateway
cd api-gateway && ./gradlew bootRun
   ```

2. Start essential services:
```bash
# Auth Service
cd auth-service && ./gradlew bootRun

# User Service
cd user-service && ./gradlew bootRun

# Post Service
cd post-service && ./gradlew bootRun
```

3. Start supporting services (any order):
```bash
cd notification-service && ./gradlew bootRun
cd messaging-service && ./gradlew bootRun
cd search-service && ./gradlew bootRun
# ... start other services as needed
```

## Mobile App Setup

1. Clone the repository
2. Install dependencies:
```bash
cd celebrate
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Configuration

### API Gateway Routes
All requests are routed through port 8080:
- Authentication: /api/auth/**
- User management: /api/users/**
- Posts: /api/posts/**
- Messages: /api/messages/**
- Notifications: /api/notifications/**

### Security
- JWT-based authentication
- Role-based access control
- Secure password storage
- API key management
- Rate limiting

### Monitoring
- Eureka Dashboard: http://localhost:8761
- Spring Boot Admin: http://localhost:8080/admin
- Actuator endpoints on each service
- Logging and analytics dashboard

## Docker Support

Build and run with Docker:
   ```bash
# Build all services
docker-compose build

# Run the stack
docker-compose up -d
```

## Kubernetes Support

Deploy to Kubernetes:
```bash
# Apply configurations
kubectl apply -f k8s/

# Monitor deployments
kubectl get pods -n celebrate
```

## Testing

1. **Backend Testing**
   - Unit tests for each service
   - Integration tests
   - API tests (Postman collections)
   - Load testing scripts

2. **Mobile App Testing**
   - Widget tests
   - Integration tests
   - End-to-end tests
   - Performance testing

## Troubleshooting

1. **Service Registration Issues**
   - Verify Eureka server is running
   - Check service configurations
   - Validate network connectivity

2. **Database Connectivity**
   - Verify PostgreSQL is running
   - Check connection strings
   - Validate credentials

3. **Mobile App Issues**
   - Clear cache: `flutter clean`
   - Update dependencies: `flutter pub get`
   - Rebuild: `flutter run --release`

## Contributing

Please read CONTRIBUTING.md for contribution guidelines.

## License

This project is licensed under the MIT License - see LICENSE for details.
