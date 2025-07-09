# Function to start a service and wait for it to be ready
function Start-ServiceAndWait {
    param (
        [string]$serviceName,
        [string]$port
    )
    
    Write-Host "Starting $serviceName..."
    Set-Location $serviceName
    Start-Process powershell -ArgumentList "./gradlew bootRun" -WindowStyle Hidden
    Set-Location ..
    
    # Wait for the service to be ready
    $retries = 30
    while ($retries -gt 0) {
        try {
            $response = Test-NetConnection -ComputerName localhost -Port $port -WarningAction SilentlyContinue
            if ($response.TcpTestSucceeded) {
                Write-Host "$serviceName is ready!"
                return
            }
        } catch {}
        Start-Sleep -Seconds 2
        $retries--
    }
    Write-Host "$serviceName failed to start within timeout"
}

# Start Kafka and dependencies
Write-Host "Starting Kafka and dependencies..."
docker-compose up -d

# Wait for Kafka to be ready
Write-Host "Waiting for Kafka to be ready..."
Start-Sleep -Seconds 30

# Start Config Server
Write-Host "Starting Config Server..."
Start-Process powershell -ArgumentList "cd config-server; ./gradlew bootRun"
Start-Sleep -Seconds 20

# Start Service Registry
Write-Host "Starting Service Registry..."
Start-Process powershell -ArgumentList "cd service-registry; ./gradlew bootRun"
Start-Sleep -Seconds 20

# Start Auth Service
Write-Host "Starting Auth Service..."
Start-Process powershell -ArgumentList "cd auth-service; ./gradlew bootRun"
Start-Sleep -Seconds 20

# Start API Gateway
Write-Host "Starting API Gateway..."
Start-Process powershell -ArgumentList "cd api-gateway; ./gradlew bootRun"
Start-Sleep -Seconds 20

# Start other services
$services = @(
    "user-service",
    "post-service",
    "notification-service",
    "messaging-service",
    "news-feed-service",
    "rating-review-service",
    "award-service",
    "moderation-service",
    "monitoring-service"
)

foreach ($service in $services) {
    Write-Host "Starting $service..."
    Start-Process powershell -ArgumentList "cd $service; ./gradlew bootRun"
    Start-Sleep -Seconds 10
}

Write-Host "All services started!" 
Write-Host "Kafka UI available at: http://localhost:8090"
Write-Host "Service Registry UI available at: http://localhost:8761"
Write-Host "API Gateway available at: http://localhost:8080" 