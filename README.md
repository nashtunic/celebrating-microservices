# Celebrating Microservices

A microservices-based application built with Spring Boot and Flutter.

## Service Architecture

The application consists of the following microservices:

1. **Config Server** (Port: 8888)
   - Central configuration management
   - Git-based configuration repository

2. **Service Registry** (Port: 8761)
   - Eureka Server for service discovery
   - Dashboard available at http://localhost:8761

3. **API Gateway** (Port: 8080)
   - Routes all client requests
   - Handles CORS and security
   - JWT token validation
   - Load balancing

4. **Auth Service** (Port: 8081)
   - User authentication and authorization
   - JWT token generation and validation
   - Detailed API Documentation:
     
     a. Register New User
     ```
     POST /api/auth/register
     Host: localhost:8080
     Content-Type: application/json

     {
       "username": "string",
       "password": "string",
       "email": "string",
       "fullName": "string",
       "role": "USER"     // Optional, defaults to "USER"
     }

     Response (200 OK):
     {
       "message": "Registration successful",
       "userId": "number",
       "username": "string",
       "email": "string"
     }
     ```

     b. User Login
     ```
     POST /api/auth/login
     Host: localhost:8080
     Content-Type: application/json

     {
       "username": "string",
       "password": "string"
     }

     Response (200 OK):
     {
       "token": "string",          // JWT access token
       "refreshToken": "string",   // JWT refresh token
       "userId": "number",
       "username": "string",
       "role": "string",
       "lastLogin": "timestamp"
     }
     ```

     c. Validate Token
     ```
     GET /api/auth/validate
     Host: localhost:8080
     Authorization: Bearer {token}

     Response (200 OK):
     {
       "valid": true,
       "username": "string",
       "role": "string"
     }
     ```

     d. Refresh Token
     ```
     POST /api/auth/refresh
     Host: localhost:8080
     Authorization: Bearer {refresh_token}

     Response (200 OK):
     {
       "token": "string",          // New JWT access token
       "refreshToken": "string"    // New JWT refresh token
     }
     ```

   - Important Notes:
     - Passwords are securely hashed using BCrypt before storage
     - Registration and login are separate operations
     - JWT tokens contain user roles and permissions
     - Token validation is performed at the API Gateway level

5. **User Service** (Port: 8082)
   - User profile management
   - Endpoints:
     - GET `/api/users/profile` - Get user profile
     - PUT `/api/users/update` - Update user profile
     - GET `/api/users/{userId}` - Get user by ID
     - GET `/api/users/username/{username}` - Get user by username

6. **Post Service** (Port: 8083)
   - Post management and feed generation
   - Endpoints:
     - POST `/api/posts/create` - Create new post
     - GET `/api/posts/feed` - Get user feed
     - GET `/api/posts/user` - Get user posts
     - GET `/api/posts/{postId}` - Get post by ID

7. **Messaging Service** (Port: 8084)
   - Real-time messaging and chat
   - Endpoints:
     - POST `/api/messages/send` - Send message
     - GET `/api/messages/conversations` - Get user conversations
     - GET `/api/messages/{conversationId}` - Get conversation messages

8. **News Feed Service** (Port: 8085)
   - Personalized news feed generation
   - Endpoints:
     - GET `/api/news-feed/posts` - Get personalized feed
     - GET `/api/news-feed/trending` - Get trending posts

9. **Moderation Service** (Port: 8086)
   - Content moderation and reporting
   - Endpoints:
     - POST `/api/moderation/report` - Report content
     - GET `/api/moderation/status/{contentId}` - Get content status

10. **Notification Service** (Port: 8087)
    - Push notifications and alerts
    - Endpoints:
      - GET `/api/notifications` - Get user notifications
      - PUT `/api/notifications/read` - Mark notifications as read

## Message Broker (Apache Kafka)

### Infrastructure
- Zookeeper (Port: 2181)
- Kafka Broker (Port: 9092)
- Kafka UI (Port: 8090)

### Kafka Topics
1. `user-events` - User-related events (registration, profile updates)
2. `post-events` - Post creation and updates
3. `notification-events` - System notifications
4. `message-events` - Chat messages
5. `feed-events` - News feed updates
6. `rating-events` - Rating and review events
7. `award-events` - User achievements and awards
8. `moderation-events` - Content moderation events
9. `monitoring-events` - System monitoring and metrics

### Starting Kafka
```bash
docker-compose up -d
```

Access Kafka UI at: http://localhost:8090

## Security Configuration

### JWT Authentication

- Access Token Expiration: 24 hours
- Refresh Token Expiration: 7 days
- Token Format: Bearer token
- Required Headers: `Authorization: Bearer <token>`
- Token Payload:
  ```json
  {
    "sub": "username",
    "role": "USER",
    "iat": timestamp,
    "exp": timestamp
  }
  ```

### CORS Configuration

- Allowed Origins: `http://localhost:*`, `http://127.0.0.1:*`
- Allowed Methods: GET, POST, PUT, DELETE, OPTIONS, HEAD
- Allowed Headers: All
- Exposed Headers: Authorization, Content-Type
- Allow Credentials: true
- Max Age: 3600 seconds

## Getting Started

1. Start the Config Server:
    ```bash
   cd config-server
   ./gradlew bootRun
   ```

2. Start the Service Registry:
   ```bash
   cd service-registry
   ./gradlew bootRun
   ```

3. Start the Auth Service:
```bash
   cd auth-service
   ./gradlew bootRun
   ```

4. Start the API Gateway:
   ```bash
   cd api-gateway
   ./gradlew bootRun
   ```

5. Start other services as needed.

## Environment Variables

- `JWT_SECRET` - JWT signing key (min 32 characters)
- `SPRING_PROFILES_ACTIVE` - Active Spring profile
- `CONFIG_SERVER_URL` - Config server URL
- `EUREKA_SERVER_URL` - Eureka server URL

## API Documentation

Swagger UI is available for each service at:
- Gateway: http://localhost:8080/swagger-ui.html
- Auth Service: http://localhost:8081/swagger-ui.html
- User Service: http://localhost:8082/swagger-ui.html
- Other services: http://localhost:{port}/swagger-ui.html

## Monitoring

- Actuator endpoints are enabled for all services
- Access metrics at: http://localhost:{port}/actuator
- Health check at: http://localhost:{port}/actuator/health
