# Simple Kafka Test Script
Write-Host "🔍 Testing Kafka Infrastructure..." -ForegroundColor Cyan

# Test 1: Docker Containers
Write-Host "`n🐳 Testing Docker Containers..." -ForegroundColor Yellow
$containers = @("zookeeper", "kafka", "kafka-ui")
$dockerOk = $true

foreach ($container in $containers) {
    $status = docker ps --filter "name=$container" --format "{{.Names}}"
    if ($status -like "*$container*") {
        Write-Host "✅ $container is running" -ForegroundColor Green
    } else {
        Write-Host "❌ $container is not running" -ForegroundColor Red
        $dockerOk = $false
    }
}

# Test 2: Kafka Topics
Write-Host "`n📋 Testing Kafka Topics..." -ForegroundColor Yellow
$requiredTopics = @("user-events", "notification-events", "post-events", "message-events", "feed-events", "rating-events", "award-events", "moderation-events", "monitoring-events")
$existingTopics = docker exec kafka kafka-topics --list --bootstrap-server localhost:9092
$topicsOk = $true

foreach ($topic in $requiredTopics) {
    if ($existingTopics -contains $topic) {
        Write-Host "✅ Topic '$topic' exists" -ForegroundColor Green
    } else {
        Write-Host "❌ Topic '$topic' is missing" -ForegroundColor Red
        $topicsOk = $false
    }
}

# Test 3: Kafka UI
Write-Host "`n🖥️ Testing Kafka UI..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8090" -Method GET -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Kafka UI is accessible" -ForegroundColor Green
        $uiOk = $true
    } else {
        Write-Host "❌ Kafka UI returned status: $($response.StatusCode)" -ForegroundColor Red
        $uiOk = $false
    }
} catch {
    Write-Host "❌ Kafka UI is not accessible" -ForegroundColor Red
    $uiOk = $false
}

# Test 4: Producer Test
Write-Host "`n🔄 Testing Producer..." -ForegroundColor Yellow
$testMessage = '{"eventId":"test-123","eventType":"USER_CREATED","userId":"test-user","action":"USER_CREATED","timestamp":"2025-07-05T10:00:00Z","data":{"username":"test","email":"test@test.com"}}'
$testMessage | docker exec -i kafka kafka-console-producer --topic user-events --bootstrap-server localhost:9092
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Test message sent successfully" -ForegroundColor Green
    $producerOk = $true
} else {
    Write-Host "❌ Failed to send test message" -ForegroundColor Red
    $producerOk = $false
}

# Summary
Write-Host "`n📊 Test Summary:" -ForegroundColor Cyan
Write-Host "=================" -ForegroundColor Cyan

$tests = @(
    @{Name="Docker Containers"; Result=$dockerOk},
    @{Name="Kafka Topics"; Result=$topicsOk},
    @{Name="Kafka UI"; Result=$uiOk},
    @{Name="Producer Test"; Result=$producerOk}
)

$passed = 0
foreach ($test in $tests) {
    if ($test.Result) {
        Write-Host "✅ PASS $($test.Name)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "❌ FAIL $($test.Name)" -ForegroundColor Red
    }
}

Write-Host "`n📈 Results: $passed/$($tests.Count) tests passed" -ForegroundColor Cyan

if ($passed -eq $tests.Count) {
    Write-Host "🎉 All tests passed! Kafka is ready." -ForegroundColor Green
} else {
    Write-Host "⚠️ Some tests failed. Check the output above." -ForegroundColor Yellow
} 