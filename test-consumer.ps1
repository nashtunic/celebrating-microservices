# Notification Service Consumer Test
Write-Host "Testing Notification Service Consumer..." -ForegroundColor Cyan

# Test 1: Check service status
Write-Host "`nTesting Notification Service Status..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps/NOTIFICATION-SERVICE" -Method GET -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "SUCCESS: Notification service is registered with Eureka" -ForegroundColor Green
        $serviceRunning = $true
    } else {
        Write-Host "ERROR: Notification service returned status: $($response.StatusCode)" -ForegroundColor Red
        $serviceRunning = $false
    }
} catch {
    Write-Host "ERROR: Notification service is not accessible via Eureka" -ForegroundColor Red
    $serviceRunning = $false
}

# Test 2: Check topic offsets
Write-Host "`nTesting Topic Offsets..." -ForegroundColor Yellow
$offsets = docker exec kafka kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic user-events
if ($offsets) {
    Write-Host "SUCCESS: User events topic has messages" -ForegroundColor Green
    Write-Host "Current offsets: $offsets" -ForegroundColor Gray
    $topicHasMessages = $true
} else {
    Write-Host "WARNING: User events topic is empty" -ForegroundColor Yellow
    $topicHasMessages = $false
}

# Test 3: Send test message
Write-Host "`nTesting Consumer with New Message..." -ForegroundColor Yellow
$testMessage = '{"eventId":"consumer-test-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '","eventType":"USER_CREATED","userId":"test-consumer-' + (Get-Random) + '","action":"USER_CREATED","timestamp":"' + (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ") + '","data":{"username":"testconsumer","email":"consumer@test.com","fullName":"Test Consumer User"}}'

$testMessage | Out-File -FilePath "consumer-test-message.json" -Encoding UTF8

Get-Content "consumer-test-message.json" | docker exec -i kafka kafka-console-producer --topic user-events --bootstrap-server localhost:9092
if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS: Test message sent successfully" -ForegroundColor Green
    $messageSent = $true
} else {
    Write-Host "ERROR: Failed to send test message" -ForegroundColor Red
    $messageSent = $false
}

# Test 4: Wait and check consumer group
Write-Host "`nWaiting for consumer to process message..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

$consumerGroups = docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --list
if ($consumerGroups -match "notification-service-group") {
    Write-Host "SUCCESS: Notification service consumer group exists" -ForegroundColor Green
    $consumerGroupExists = $true
    
    $groupDetails = docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group notification-service-group
    Write-Host "Consumer group details:" -ForegroundColor Gray
    $groupDetails | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
} else {
    Write-Host "WARNING: Notification service consumer group not found" -ForegroundColor Yellow
    Write-Host "Available consumer groups: $consumerGroups" -ForegroundColor Gray
    $consumerGroupExists = $false
}

# Summary
Write-Host "`nConsumer Test Summary:" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan

$tests = @(
    @{Name="Service Running"; Result=$serviceRunning},
    @{Name="Topic Has Messages"; Result=$topicHasMessages},
    @{Name="Message Sent"; Result=$messageSent},
    @{Name="Consumer Group Created"; Result=$consumerGroupExists}
)

$passed = 0
foreach ($test in $tests) {
    if ($test.Result) {
        Write-Host "PASS $($test.Name)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "FAIL $($test.Name)" -ForegroundColor Red
    }
}

Write-Host "`nResults: $passed/$($tests.Count) tests passed" -ForegroundColor Cyan

if ($passed -eq $tests.Count) {
    Write-Host "Notification service consumer is working perfectly!" -ForegroundColor Green
} elseif ($passed -ge 3) {
    Write-Host "Notification service consumer is mostly working" -ForegroundColor Green
} else {
    Write-Host "Notification service consumer needs attention" -ForegroundColor Yellow
}

# Cleanup
if (Test-Path "consumer-test-message.json") {
    Remove-Item "consumer-test-message.json"
} 