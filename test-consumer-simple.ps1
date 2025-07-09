# Simple Consumer Test
Write-Host "Simple Notification Service Consumer Test" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Test 1: Check if notification service is running
Write-Host "`n1. Checking Notification Service Status..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps/NOTIFICATION-SERVICE" -Method GET -TimeoutSec 5
    Write-Host "SUCCESS: Notification service is registered with Eureka" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Notification service is not accessible" -ForegroundColor Red
}

# Test 2: Check current messages in topic
Write-Host "`n2. Checking Current Messages in Topic..." -ForegroundColor Yellow
$offsets = docker exec kafka kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic user-events
Write-Host "Current offsets: $offsets" -ForegroundColor Gray

# Test 3: Send a test message
Write-Host "`n3. Sending Test Message..." -ForegroundColor Yellow
$testMsg = '{"eventId":"final-test-123","eventType":"USER_CREATED","userId":"final-test-user","action":"USER_CREATED","timestamp":"2025-07-05T14:15:00Z","data":{"username":"finaltest","email":"final@test.com","fullName":"Final Test User"}}'
$testMsg | docker exec -i kafka kafka-console-producer --topic user-events --bootstrap-server localhost:9092
Write-Host "SUCCESS: Test message sent" -ForegroundColor Green

# Test 4: Wait and check consumer groups
Write-Host "`n4. Waiting for Consumer Processing..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

$consumerGroups = docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --list
Write-Host "Available consumer groups: $consumerGroups" -ForegroundColor Gray

# Test 5: Check if notification service group exists
Write-Host "`n5. Checking for Notification Service Consumer Group..." -ForegroundColor Yellow
if ($consumerGroups -match "notification-service-group") {
    Write-Host "SUCCESS: Notification service consumer group found!" -ForegroundColor Green
    $groupDetails = docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group notification-service-group
    Write-Host "Group details:" -ForegroundColor Gray
    $groupDetails | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
} else {
    Write-Host "WARNING: Notification service consumer group not found" -ForegroundColor Yellow
    Write-Host "This might mean:" -ForegroundColor Yellow
    Write-Host "  - Notification service is not consuming messages yet" -ForegroundColor Gray
    Write-Host "  - Consumer group name is different" -ForegroundColor Gray
    Write-Host "  - Service needs to be restarted" -ForegroundColor Gray
}

# Test 6: Check updated offsets
Write-Host "`n6. Checking Updated Offsets..." -ForegroundColor Yellow
$newOffsets = docker exec kafka kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic user-events
Write-Host "Updated offsets: $newOffsets" -ForegroundColor Gray

Write-Host "`nTest completed!" -ForegroundColor Cyan 