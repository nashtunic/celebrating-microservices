# Test services PowerShell script

# Helper function to make HTTP requests with error handling
function Invoke-ServiceRequest {
    param (
        [string]$Uri,
        [string]$Method = "GET",
        [string]$Body = $null,
        [string]$ContentType = "application/json",
        [string]$AuthToken = $null,
        [string]$ServiceName = "Service"
    )

    $headers = @{}
    if ($AuthToken) {
        $headers["Authorization"] = "Bearer $AuthToken"
    }

    try {
        if ($Body) {
            $response = Invoke-WebRequest -Uri $Uri -Method $Method -Body $Body -ContentType $ContentType -Headers $headers
        } else {
            $response = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $headers
        }
        
        Write-Host "$ServiceName request successful!" -ForegroundColor Green
        Write-Host "Response:" -ForegroundColor Cyan
        $response.Content | ConvertFrom-Json | Format-List
        return $response
    } catch {
        Write-Host "$ServiceName request failed!" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd()
            Write-Host "Response body: $responseBody" -ForegroundColor Red
        }
        return $null
    }
}

# Test Service Registry (Eureka)
Write-Host "`n=== Testing Service Registry (Eureka) ===" -ForegroundColor Green
Write-Host "`nChecking Eureka status..." -ForegroundColor Yellow
$eurekaResponse = Invoke-ServiceRequest -Uri "http://localhost:8761/eureka/apps" `
    -ServiceName "Eureka"

# Test Config Server
Write-Host "`n=== Testing Config Server ===" -ForegroundColor Green
Write-Host "`nChecking auth-service config..." -ForegroundColor Yellow
$configResponse = Invoke-ServiceRequest -Uri "http://localhost:8888/auth-service/default" `
    -ServiceName "Config Server"

# Test Auth Service
Write-Host "`n=== Testing Auth Service ===" -ForegroundColor Green

# Generate random username and email to avoid conflicts
$random = Get-Random
$username = "testuser_$random"
$email = "testuser_$random@example.com"

# Test user registration
$registrationBody = @{
    username = $username
    email = $email
    password = "Test123!"
    fullName = "Test User"
} | ConvertTo-Json

Write-Host "`nTesting registration endpoint..." -ForegroundColor Yellow
Write-Host "Using test credentials:" -ForegroundColor Gray
Write-Host "Username: $username" -ForegroundColor Gray
Write-Host "Email: $email" -ForegroundColor Gray
Write-Host "Password: Test123!" -ForegroundColor Gray

$registrationResponse = Invoke-ServiceRequest -Uri "http://localhost:8080/api/auth/register" `
    -Method "Post" `
    -Body $registrationBody `
    -ServiceName "Registration"

if ($registrationResponse) {
    # Test user login
    $loginBody = @{
        username = $username
        password = "Test123!"
    } | ConvertTo-Json

    Write-Host "`nTesting login endpoint..." -ForegroundColor Yellow
    $loginResponse = Invoke-ServiceRequest -Uri "http://localhost:8080/api/auth/login" `
        -Method "Post" `
        -Body $loginBody `
        -ServiceName "Login"

    if ($loginResponse) {
        $token = ($loginResponse.Content | ConvertFrom-Json).token
        Write-Host "`nJWT Token:" -ForegroundColor Yellow
        Write-Host $token -ForegroundColor Gray
    }
}

Write-Host "`nTests completed!" -ForegroundColor Cyan

Write-Host "`n=== Testing User Service ===" -ForegroundColor Green
try {
    # Create user in User Service first
    $currentTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    $createUserBody = @{
        username = $registerResponse.username
        email = $registerResponse.email
        password = "password123"
        fullName = "Test User"
        role = "USER"
        isPrivate = $false
        isVerified = $false
        createdAt = $currentTime
        updatedAt = $currentTime
        stats = @{
            postsCount = 0
            followersCount = 0
            followingCount = 0
            updatedAt = $currentTime
        }
    } | ConvertTo-Json -Depth 10

    Write-Host "Creating user in User Service..." -ForegroundColor Yellow
    $createUserResponse = Invoke-RestMethod -Method Post -Uri "http://localhost:8082/api/api/users" `
        -Headers $headers -Body $createUserBody -ContentType 'application/json'
    Write-Host "User created successfully in User Service" -ForegroundColor Green

    Start-Sleep -Seconds 2  # Add a small delay to ensure the user is created

    # Now fetch the user profile
    Write-Host "Fetching user profile..." -ForegroundColor Yellow
    $userResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8082/api/api/users/username/$($registerResponse.username)" `
        -Headers $headers
    Write-Host "User profile fetched successfully" -ForegroundColor Green
    Write-Host "User ID: $($userResponse.id)" -ForegroundColor Yellow

    # Update user profile with all required fields
    $currentTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    $updateProfileBody = @{
        username = $registerResponse.username
        email = $registerResponse.email
        fullName = "Updated Test User"
        bio = "This is a test bio"
        location = "Test Location"
        profileImageUrl = "https://example.com/test.jpg"
        role = "USER"
        isPrivate = $false
        isVerified = $false
        password = "password123"
        createdAt = $userResponse.createdAt
        updatedAt = $currentTime
    } | ConvertTo-Json

    Write-Host "Updating profile..." -ForegroundColor Yellow
    $updateResponse = Invoke-RestMethod -Method Put -Uri "http://localhost:8082/api/api/users/$($userResponse.id)" `
        -Headers $headers -Body $updateProfileBody
    Write-Host "Profile updated successfully" -ForegroundColor Green
    Write-Host "Updated profile details: $($updateResponse | ConvertTo-Json)" -ForegroundColor Green

    # Test getting celebrity profiles
    Write-Host "Testing celebrity profile endpoints..." -ForegroundColor Yellow
    $celebritiesResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8082/api/api/users/celebrities" `
        -Headers $headers
    Write-Host "Found $($celebritiesResponse.Count) celebrity profiles" -ForegroundColor Green

} catch {
    Write-Host "User Service error: $_" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response details: $($_.Exception.Response.StatusCode.value__) - $responseBody" -ForegroundColor Red
    }
}

Write-Host "`n=== Testing Post Service ===" -ForegroundColor Green
try {
    # Create a new post
    $createPostBody = @{
        title = "Test Post from Post Service $(Get-Random)"
        content = "This is a test post content"
        category = "TEST"
    } | ConvertTo-Json

    Write-Host "Creating post..." -ForegroundColor Yellow
    $postResponse = Invoke-RestMethod -Method Post -Uri "http://localhost:8083/api/v1/posts" `
        -Headers $headers -Body $createPostBody
    Write-Host "Post created successfully" -ForegroundColor Green

    # Get posts
    $postsResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8083/api/v1/posts" `
        -Headers $headers
    Write-Host "Posts fetched successfully" -ForegroundColor Green
} catch {
    Write-Host "Post Service error: $_" -ForegroundColor Red
}

Write-Host "`n=== Testing Rating & Review Service ===" -ForegroundColor Green
try {
    # Create a review
    $reviewBody = @{
        postId = "1"
        rating = 5
        comment = "This is a test review"
    } | ConvertTo-Json

    Write-Host "Creating review..." -ForegroundColor Yellow
    $reviewResponse = Invoke-RestMethod -Method Post -Uri "http://localhost:8088/api/reviews" `
        -Headers $headers -Body $reviewBody
    Write-Host "Review created successfully" -ForegroundColor Green

    # Get reviews for a post
    $getReviewsResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8088/api/reviews/post/1" `
        -Headers $headers
    Write-Host "Reviews fetched successfully" -ForegroundColor Green
} catch {
    Write-Host "Rating & Review Service error: $_" -ForegroundColor Red
}

Write-Host "`n=== Testing Messaging Service ===" -ForegroundColor Green
try {
    # Send a message
    $messageBody = @{
        recipientId = "2"
        content = "This is a test message"
    } | ConvertTo-Json

    Write-Host "Sending message..." -ForegroundColor Yellow
    $messageResponse = Invoke-RestMethod -Method Post -Uri "http://localhost:8086/api/v1/messages" `
        -Headers $headers -Body $messageBody
    Write-Host "Message sent successfully" -ForegroundColor Green

    # Get conversations
    $conversationsResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8086/api/v1/messages/conversations" `
        -Headers $headers
    Write-Host "Conversations fetched successfully" -ForegroundColor Green
} catch {
    Write-Host "Messaging Service error: $_" -ForegroundColor Red
}

Write-Host "`n=== Testing Notifications Service ===" -ForegroundColor Green
try {
    Write-Host "Fetching notifications..." -ForegroundColor Yellow
    $notificationsResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8087/api/v1/notifications" `
        -Headers $headers
    Write-Host "Notifications fetched successfully" -ForegroundColor Green

    # Mark notification as read
    $markReadResponse = Invoke-RestMethod -Method Put -Uri "http://localhost:8087/api/v1/notifications/1/read" `
        -Headers $headers
    Write-Host "Notification marked as read" -ForegroundColor Green
} catch {
    Write-Host "Notifications Service error: $_" -ForegroundColor Red
}

Write-Host "`n=== Testing Moderation Service ===" -ForegroundColor Green
try {
    # Report content
    $reportBody = @{
        contentId = "1"
        contentType = "POST"
        reason = "TEST_REPORT"
        description = "This is a test report"
    } | ConvertTo-Json

    Write-Host "Reporting content..." -ForegroundColor Yellow
    $reportResponse = Invoke-RestMethod -Method Post -Uri "http://localhost:8089/api/moderation/reports" `
        -Headers $headers -Body $reportBody
    Write-Host "Content reported successfully" -ForegroundColor Green

    # Get reports
    $getReportsResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8089/api/moderation/reports" `
        -Headers $headers
    Write-Host "Reports fetched successfully" -ForegroundColor Green
} catch {
    Write-Host "Moderation Service error: $_" -ForegroundColor Red
}

Write-Host "`n=== Testing Awards Service ===" -ForegroundColor Green
try {
    Write-Host "Fetching achievements..." -ForegroundColor Yellow
    $achievementsResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8090/api/awards/achievements" `
        -Headers $headers
    Write-Host "Achievements fetched successfully" -ForegroundColor Green

    # Get user awards
    $userAwardsResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8090/api/awards/user/1" `
        -Headers $headers
    Write-Host "User awards fetched successfully" -ForegroundColor Green
} catch {
    Write-Host "Awards Service error: $_" -ForegroundColor Red
}

Write-Host "`n=== Testing Monitoring Service ===" -ForegroundColor Green
try {
    Write-Host "Fetching system metrics..." -ForegroundColor Yellow
    $metricsResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8091/actuator/metrics" `
        -Headers $headers
    Write-Host "System metrics fetched successfully" -ForegroundColor Green

    # Get health status
    $healthResponse = Invoke-RestMethod -Method Get -Uri "http://localhost:8091/actuator/health" `
        -Headers $headers
    Write-Host "Health status fetched successfully" -ForegroundColor Green
} catch {
    Write-Host "Monitoring Service error: $_" -ForegroundColor Red
}

Write-Host "`n=== All Tests Completed ===" -ForegroundColor Green 