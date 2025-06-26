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

# Start Config Server first (port 8888)
Start-ServiceAndWait -serviceName "config-server" -port 8888

# Start Eureka Server (port 8761)
Start-ServiceAndWait -serviceName "eureka-server" -port 8761

# Start Auth Service (port 8081)
Start-ServiceAndWait -serviceName "auth-service" -port 8081

# Start other services
$services = @(
    @{name="api-gateway"; port=8080},
    @{name="user-service"; port=8082},
    @{name="post-service"; port=8083},
    @{name="search-service"; port=8084},
    @{name="news-feed-service"; port=8085},
    @{name="messaging-service"; port=8086},
    @{name="notification-service"; port=8087},
    @{name="rating-review-service"; port=8088},
    @{name="moderation-service"; port=8089},
    @{name="awards-service"; port=8090},
    @{name="monitoring-service"; port=8091}
)

foreach ($service in $services) {
    Start-ServiceAndWait -serviceName $service.name -port $service.port
}

Write-Host "All services started!" 