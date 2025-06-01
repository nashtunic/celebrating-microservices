@echo off
echo Starting Microservices...

echo Starting Service Registry (Eureka)...
start "Service Registry" cmd /c "cd service-registry; .\gradlew bootRun"
timeout /t 30



echo Starting Config Server...
cd %BASE_DIR%\config-server
start "Config Server" cmd /k ".\gradlew bootRun"

echo Starting API Gateway...
start "API Gateway" cmd /c "cd api-gateway; .\gradlew bootRun"
timeout /t 15

echo Starting Auth Service...
start "Auth Service" cmd /c "cd auth-service; .\gradlew bootRun"
timeout /t 15

echo Starting User Service...
start "User Service" cmd /c "cd user-service; .\gradlew bootRun"
timeout /t 15

echo Starting Post Service...
start "Post Service" cmd /c "cd post-service; .\gradlew bootRun"
timeout /t 15

echo Starting Messaging Service...
start "Messaging Service" cmd /c "cd messaging-service; .\gradlew bootRun"
timeout /t 15

echo Starting Notification Service...
start "Notification Service" cmd /c "cd notification-service; .\gradlew bootRun"
timeout /t 15

echo Starting News Feed Service...
start "News Feed Service" cmd /c "cd news-feed-service; .\gradlew bootRun"
timeout /t 15

echo Starting Search Service...
start "Search Service" cmd /c "cd search-service; .\gradlew bootRun"
timeout /t 15

echo Starting Rating Review Service...
start "Rating Review Service" cmd /c "cd rating-review-service; .\gradlew bootRun"
timeout /t 15

echo Starting Award Service...
start "Award Service" cmd /c "cd award-service; .\gradlew bootRun"
timeout /t 15

echo All services have been started. Please check individual windows for status.
pause 