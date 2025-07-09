# Kafka Automated Test Script
# This script tests Kafka infrastructure and producer/consumer functionality
# Run this script after restarting servers to verify everything is working

param(
    [switch]$Verbose
)

Write-Host "🔍 Starting Kafka Automated Test..." -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

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

# Function to test Docker containers
function Test-DockerContainers {
    Write-Host "`n🐳 Testing Docker Containers..." -ForegroundColor Yellow
    
    $containers = @("zookeeper", "kafka", "kafka-ui")
    $allRunning = $true
    
    foreach ($container in $containers) {
        try {
            $status = docker ps --filter "name=$container" --format "table {{.Names}}\t{{.Status}}"
            if ($status -like "*$container*") {
                Write-Status "Container $container is running" "SUCCESS"
                if ($Verbose) { Write-Host "   $status" -ForegroundColor Gray }
            } else {
                Write-Status "Container $container is not running" "ERROR"
                $allRunning = $false
            }
        } catch {
            Write-Status "Failed to check container $container" "ERROR"
            $allRunning = $false
        }
    }
    
    return $allRunning
}

# Function to test Kafka connectivity
function Test-KafkaConnectivity {
    Write-Host "`n🔌 Testing Kafka Connectivity..." -ForegroundColor Yellow
    
    try {
        # Test if Kafka is responding
        $topics = docker exec kafka kafka-topics --list --bootstrap-server localhost:9092 2>$null
        if ($topics) {
            Write-Status "Kafka broker is responding" "SUCCESS"
            if ($Verbose) { Write-Host "   Available topics: $($topics -join ', ')" -ForegroundColor Gray }
            return $true
        } else {
            Write-Status "Kafka broker is not responding" "ERROR"
            return $false
        }
    } catch {
        Write-Status "Failed to connect to Kafka" "ERROR"
        return $false
    }
}

# Function to verify all required topics exist
function Test-KafkaTopics {
    Write-Host "`n📋 Testing Kafka Topics..." -ForegroundColor Yellow
    
    $requiredTopics = @(
        "user-events",
        "notification-events", 
        "post-events",
        "message-events",
        "feed-events",
        "rating-events",
        "award-events",
        "moderation-events",
        "monitoring-events"
    )
    
    try {
        $existingTopics = docker exec kafka kafka-topics --list --bootstrap-server localhost:9092 2>$null
        $missingTopics = @()
        
        foreach ($topic in $requiredTopics) {
            if ($existingTopics -contains $topic) {
                Write-Status "Topic '$topic' exists" "SUCCESS"
            } else {
                Write-Status "Topic '$topic' is missing" "ERROR"
                $missingTopics += $topic
            }
        }
        
        if ($missingTopics.Count -eq 0) {
            Write-Status "All required topics are present" "SUCCESS"
            return $true
        } else {
            Write-Status "Missing topics: $($missingTopics -join ', ')" "ERROR"
            return $false
        }
    } catch {
        Write-Status "Failed to check topics" "ERROR"
        return $false
    }
}

# Function to test Kafka UI
function Test-KafkaUI {
    Write-Host "`n🖥️ Testing Kafka UI..." -ForegroundColor Yellow
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8090" -Method GET -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Status "Kafka UI is accessible" "SUCCESS"
            return $true
        } else {
            Write-Status "Kafka UI returned status: $($response.StatusCode)" "ERROR"
            return $false
        }
    } catch {
        Write-Status "Kafka UI is not accessible" "ERROR"
        return $false
    }
}

# Function to test producer/consumer flow
function Test-KafkaProducerConsumer {
    Write-Host "`n🔄 Testing Producer/Consumer Flow..." -ForegroundColor Yellow
    
    $testTopic = "user-events"
    $testMessage = @{
        eventId = "automated-test-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        eventType = "USER_CREATED"
        userId = "test-user-$(Get-Random)"
        action = "USER_CREATED"
        timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
        data = @{
            username = "automated-test"
            email = "test@automated.com"
            fullName = "Automated Test User"
        }
    } | ConvertTo-Json -Depth 3
    
    try {
        # Send test message
        Write-Host "   Sending test message..." -ForegroundColor Gray
        $testMessage | docker exec -i kafka kafka-console-producer --topic $testTopic --bootstrap-server localhost:9092 2>$null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Status "Test message sent successfully" "SUCCESS"
            
            # Wait a moment for message to be processed
            Start-Sleep -Seconds 2
            
            # Check if message was received (check offset)
            $offsets = docker exec kafka kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic $testTopic 2>$null
            if ($offsets -match "user-events:1:\d+") {
                Write-Status "Message appears to be in topic" "SUCCESS"
                if ($Verbose) { Write-Host "   Offsets: $offsets" -ForegroundColor Gray }
                return $true
            } else {
                Write-Status "Message may not have been sent properly" "WARNING"
                return $false
            }
        } else {
            Write-Status "Failed to send test message" "ERROR"
            return $false
        }
    } catch {
        Write-Status "Failed to test producer/consumer flow" "ERROR"
        return $false
    }
}

# Function to test consumer groups
function Test-ConsumerGroups {
    Write-Host "`n👥 Testing Consumer Groups..." -ForegroundColor Yellow
    
    try {
        $groups = docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --list 2>$null
        
        if ($groups) {
            Write-Status "Consumer groups found: $($groups.Count)" "SUCCESS"
            if ($Verbose) { 
                foreach ($group in $groups) {
                    Write-Host "   - $group" -ForegroundColor Gray
                }
            }
            return $true
        } else {
            Write-Status "No consumer groups found (this is normal if no services are consuming)" "WARNING"
            return $true
        }
    } catch {
        Write-Status "Failed to check consumer groups" "ERROR"
        return $false
    }
}

# Function to test microservices connectivity
function Test-MicroservicesConnectivity {
    Write-Host "`n🔗 Testing Microservices Connectivity..." -ForegroundColor Yellow
    
    $services = @(
        @{Name="API Gateway"; Port=8080; Path="/actuator/health"},
        @{Name="User Service"; Port=8082; Path="/actuator/health"},
        @{Name="Notification Service"; Port=0; Path="/actuator/health"} # Dynamic port
    )
    
    $allHealthy = $true
    
    foreach ($service in $services) {
        try {
            if ($service.Port -eq 0) {
                # For dynamic port services, just check if they're registered in Eureka
                Write-Status "$($service.Name) has dynamic port (check Eureka)" "WARNING"
            } else {
                $response = Invoke-WebRequest -Uri "http://localhost:$($service.Port)$($service.Path)" -Method GET -TimeoutSec 5
                if ($response.StatusCode -eq 200) {
                    Write-Status "$($service.Name) is healthy" "SUCCESS"
                } else {
                    Write-Status "$($service.Name) returned status: $($response.StatusCode)" "ERROR"
                    $allHealthy = $false
                }
            }
        } catch {
            Write-Status "$($service.Name) is not accessible" "ERROR"
            $allHealthy = $false
        }
    }
    
    return $allHealthy
}

# Main test execution
function Start-KafkaTest {
    $results = @{}
    
    # Test 1: Docker Containers
    $results.DockerContainers = Test-DockerContainers
    
    # Test 2: Kafka Connectivity
    $results.KafkaConnectivity = Test-KafkaConnectivity
    
    # Test 3: Kafka Topics
    $results.KafkaTopics = Test-KafkaTopics
    
    # Test 4: Kafka UI
    $results.KafkaUI = Test-KafkaUI
    
    # Test 5: Producer/Consumer Flow
    $results.ProducerConsumer = Test-KafkaProducerConsumer
    
    # Test 6: Consumer Groups
    $results.ConsumerGroups = Test-ConsumerGroups
    
    # Test 7: Microservices Connectivity
    $results.Microservices = Test-MicroservicesConnectivity
    
    # Summary
    Write-Host "`n📊 Test Summary:" -ForegroundColor Cyan
    Write-Host "=================" -ForegroundColor Cyan
    
    $passed = 0
    $total = $results.Count
    
    foreach ($test in $results.GetEnumerator()) {
        $status = if ($test.Value) { "✅ PASS" } else { "❌ FAIL" }
        $color = if ($test.Value) { "Green" } else { "Red" }
        Write-Host "$status $($test.Key)" -ForegroundColor $color
        
        if ($test.Value) { $passed++ }
    }
    
    Write-Host "`n📈 Results: $passed/$total tests passed" -ForegroundColor Cyan
    
    if ($passed -eq $total) {
        Write-Host "🎉 All Kafka tests passed! Your infrastructure is ready." -ForegroundColor Green
        return 0
    } else {
        Write-Host "⚠️ Some tests failed. Check the output above for details." -ForegroundColor Yellow
        return 1
    }
}

# Execute the test
try {
    $exitCode = Start-KafkaTest
    exit $exitCode
} catch {
    Write-Host "❌ Test script failed with error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} 