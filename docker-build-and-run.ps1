# Docker Build and Run Script for Celebrating Microservices
# This script builds all JARs, creates Docker images, and starts all services

param(
    [switch]$SkipBuild,
    [switch]$SkipDocker,
    [switch]$ForceRebuild,
    [switch]$StopOnly
)

Write-Host "🚀 Celebrating Microservices Docker Deployment" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Function to write colored output
function Write-Status {
    param($Message, $Status)
    if ($Status -eq "SUCCESS") {
        Write-Host "✅ $Message" -ForegroundColor Green
    } elseif ($Status -eq "ERROR") {
        Write-Host "❌ $Message" -ForegroundColor Red
    } elseif ($Status -eq "WARNING") {
        Write-Host "⚠️ $Message" -ForegroundColor Yellow
    } else {
        Write-Host "ℹ️ $Message" -ForegroundColor Blue
    }
}

# Function to check if service directory exists
function Test-ServiceExists {
    param($ServiceName)
    return Test-Path $ServiceName
}

# Function to build JAR for a service
function Build-ServiceJar {
    param($ServiceName)
    
    if (-not (Test-ServiceExists $ServiceName)) {
        Write-Status "Service $ServiceName not found, skipping" "WARNING"
        return $false
    }
    
    try {
        Write-Host "Building $ServiceName..." -ForegroundColor Yellow
        Push-Location $ServiceName
        & ./gradlew bootJar --no-daemon
        if ($LASTEXITCODE -eq 0) {
            Write-Status "$ServiceName JAR built successfully" "SUCCESS"
            Pop-Location
            return $true
        } else {
            Write-Status "Failed to build $ServiceName JAR" "ERROR"
            Pop-Location
            return $false
        }
    } catch {
        Write-Status "Error building $ServiceName: $($_.Exception.Message)" "ERROR"
        Pop-Location
        return $false
    }
}

# Function to create Dockerfile for a service
function Create-ServiceDockerfile {
    param($ServiceName)
    
    if (-not (Test-ServiceExists $ServiceName)) {
        return $false
    }
    
    $dockerfilePath = "$ServiceName/Dockerfile"
    
    # Check if Dockerfile already exists
    if (Test-Path $dockerfilePath) {
        Write-Status "Dockerfile already exists for $ServiceName" "SUCCESS"
        return $true
    }
    
    try {
        Copy-Item "Dockerfile.template" $dockerfilePath
        Write-Status "Created Dockerfile for $ServiceName" "SUCCESS"
        return $true
    } catch {
        Write-Status "Failed to create Dockerfile for $ServiceName" "ERROR"
        return $false
    }
}

# List of all microservices
$services = @(
    "service-registry",
    "config-server", 
    "api-gateway",
    "auth-service",
    "user-service",
    "post-service",
    "messaging-service",
    "notification-service",
    "news-feed-service",
    "analytics-logging-service",
    "monitoring-service",
    "award-service",
    "moderation-service",
    "rating-review-service",
    "search-service"
)

# Stop all services if requested
if ($StopOnly) {
    Write-Host "`n🛑 Stopping all Docker services..." -ForegroundColor Yellow
    docker-compose -f docker-compose-full.yml down
    Write-Status "All services stopped" "SUCCESS"
    exit 0
}

# Step 1: Build all JARs
if (-not $SkipBuild) {
    Write-Host "`n🔨 Building all microservice JARs..." -ForegroundColor Yellow
    
    $buildSuccess = 0
    $buildTotal = 0
    
    foreach ($service in $services) {
        $buildTotal++
        if (Build-ServiceJar $service) {
            $buildSuccess++
        }
    }
    
    Write-Host "`n📊 JAR Build Summary: $buildSuccess/$buildTotal successful" -ForegroundColor Cyan
    
    if ($buildSuccess -eq 0) {
        Write-Status "No services built successfully. Exiting." "ERROR"
        exit 1
    }
}

# Step 2: Create Dockerfiles
Write-Host "`n🐳 Creating Dockerfiles..." -ForegroundColor Yellow

$dockerfileSuccess = 0
foreach ($service in $services) {
    if (Create-ServiceDockerfile $service) {
        $dockerfileSuccess++
    }
}

Write-Status "Created $dockerfileSuccess Dockerfiles" "SUCCESS"

# Step 3: Build Docker images
if (-not $SkipDocker) {
    Write-Host "`n🔨 Building Docker images..." -ForegroundColor Yellow
    
    $buildArgs = @("-f", "docker-compose-full.yml", "build")
    
    if ($ForceRebuild) {
        $buildArgs += "--no-cache"
    }
    
    try {
        & docker-compose @buildArgs
        if ($LASTEXITCODE -eq 0) {
            Write-Status "Docker images built successfully" "SUCCESS"
        } else {
            Write-Status "Failed to build Docker images" "ERROR"
            exit 1
        }
    } catch {
        Write-Status "Error building Docker images: $($_.Exception.Message)" "ERROR"
        exit 1
    }
}

# Step 4: Start all services
Write-Host "`n🚀 Starting all microservices..." -ForegroundColor Yellow

try {
    # Stop any existing containers first
    Write-Host "Stopping existing containers..." -ForegroundColor Gray
    docker-compose -f docker-compose-full.yml down
    
    # Start all services
    Write-Host "Starting all services..." -ForegroundColor Gray
    docker-compose -f docker-compose-full.yml up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Status "All services started successfully" "SUCCESS"
    } else {
        Write-Status "Failed to start services" "ERROR"
        exit 1
    }
} catch {
    Write-Status "Error starting services: $($_.Exception.Message)" "ERROR"
    exit 1
}

# Step 5: Wait for services to be ready
Write-Host "`n⏳ Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Step 6: Check service status
Write-Host "`n📊 Checking service status..." -ForegroundColor Yellow

try {
    $status = docker-compose -f docker-compose-full.yml ps
    Write-Host $status -ForegroundColor Gray
} catch {
    Write-Status "Could not get service status" "WARNING"
}

# Step 7: Display access information
Write-Host "`n🌐 Service Access Information:" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "API Gateway:     http://localhost:8080" -ForegroundColor Green
Write-Host "Eureka Registry: http://localhost:8761" -ForegroundColor Green
Write-Host "Config Server:   http://localhost:8888" -ForegroundColor Green
Write-Host "Kafka UI:        http://localhost:8090" -ForegroundColor Green
Write-Host "PostgreSQL:      localhost:5432" -ForegroundColor Green
Write-Host "Kafka:           localhost:9092" -ForegroundColor Green

Write-Host "`n📋 Individual Services:" -ForegroundColor Cyan
Write-Host "Auth Service:    http://localhost:8081" -ForegroundColor Gray
Write-Host "User Service:    http://localhost:8082" -ForegroundColor Gray
Write-Host "Post Service:    http://localhost:8084" -ForegroundColor Gray
Write-Host "News Feed:       http://localhost:8085" -ForegroundColor Gray
Write-Host "Messaging:       http://localhost:8086" -ForegroundColor Gray
Write-Host "Notifications:   http://localhost:8087" -ForegroundColor Gray
Write-Host "Analytics:       http://localhost:8088" -ForegroundColor Gray
Write-Host "Monitoring:      http://localhost:8089" -ForegroundColor Gray

Write-Host "`n🎉 Deployment completed successfully!" -ForegroundColor Green
Write-Host "Use 'docker-compose -f docker-compose-full.yml logs -f' to view logs" -ForegroundColor Yellow
Write-Host "Use 'docker-compose -f docker-compose-full.yml down' to stop all services" -ForegroundColor Yellow 