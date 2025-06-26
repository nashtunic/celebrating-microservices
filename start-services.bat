@echo off
echo Starting Microservices...

REM Set base directory
set BASE_DIR=%~dp0

REM Create logs directory if it doesn't exist
if not exist "%BASE_DIR%\logs" mkdir "%BASE_DIR%\logs"

echo Starting Service Registry (Eureka)...
cd "%BASE_DIR%\service-registry"
start "Service Registry" cmd /c "gradlew bootRun > ..\logs\service-registry.log 2>&1"
timeout /t 30 /nobreak
cd "%BASE_DIR%"

echo Starting Config Server...
cd "%BASE_DIR%\config-server"
start "Config Server" cmd /c "gradlew bootRun > ..\logs\config-server.log 2>&1"
timeout /t 20 /nobreak
cd "%BASE_DIR%"

echo Starting API Gateway...
cd "%BASE_DIR%\api-gateway"
start "API Gateway" cmd /c "gradlew bootRun > ..\logs\api-gateway.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting Auth Service...
cd "%BASE_DIR%\auth-service"
start "Auth Service" cmd /c "gradlew bootRun > ..\logs\auth-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting User Service...
cd "%BASE_DIR%\user-service"
start "User Service" cmd /c "gradlew bootRun > ..\logs\user-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting Post Service...
cd "%BASE_DIR%\post-service"
start "Post Service" cmd /c "gradlew bootRun > ..\logs\post-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting Messaging Service...
cd "%BASE_DIR%\messaging-service"
start "Messaging Service" cmd /c "gradlew bootRun > ..\logs\messaging-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting Notification Service...
cd "%BASE_DIR%\notification-service"
start "Notification Service" cmd /c "gradlew bootRun > ..\logs\notification-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting News Feed Service...
cd "%BASE_DIR%\news-feed-service"
start "News Feed Service" cmd /c "gradlew bootRun > ..\logs\news-feed-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting Search Service...
cd "%BASE_DIR%\search-service"
start "Search Service" cmd /c "gradlew bootRun > ..\logs\search-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting Rating Review Service...
cd "%BASE_DIR%\rating-review-service"
start "Rating Review Service" cmd /c "gradlew bootRun > ..\logs\rating-review-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting Moderation Service...
cd "%BASE_DIR%\moderation-service"
start "Moderation Service" cmd /c "gradlew bootRun > ..\logs\moderation-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting Award Service...
cd "%BASE_DIR%\award-service"
start "Award Service" cmd /c "gradlew bootRun > ..\logs\award-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo Starting Monitoring Service...
cd "%BASE_DIR%\monitoring-service"
start "Monitoring Service" cmd /c "gradlew bootRun > ..\logs\monitoring-service.log 2>&1"
timeout /t 15 /nobreak
cd "%BASE_DIR%"

echo.
echo All services have been started. Service logs can be found in the logs directory.
echo Service ports:
echo - Service Registry: 8761
echo - Config Server: 8888
echo - API Gateway: 8080
echo - Auth Service: 8081
echo - User Service: 8082
echo - Post Service: 8083
echo - Messaging Service: 8084
echo - News Feed Service: 8085
echo - Moderation Service: 8086
echo - Notification Service: 8087
echo - Search Service: 8091
echo - Rating Review Service: 8090
echo - Award Service: 8089
echo - Monitoring Service: 8092

echo.
echo Press any key to exit...
pause > nul 