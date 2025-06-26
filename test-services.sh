#!/bin/bash

# For Ubuntu/Debian
#sudo apt-get install jq

# For Mac
#brew install jq
# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\n${GREEN}=== Testing Config Server ===${NC}"
if response=$(curl -s "http://localhost:8888/auth-service/default"); then
    echo -e "${GREEN}Config Server is running and responding${NC}"
    echo "Sample config: $response"
else
    echo -e "${RED}Config Server error: Failed to connect${NC}"
fi

echo -e "\n${GREEN}=== Testing Eureka Server ===${NC}"
if response=$(curl -s "http://localhost:8761/eureka/apps"); then
    echo -e "${GREEN}Eureka Server is running and responding${NC}"
    echo "Response received from Eureka"
else
    echo -e "${RED}Eureka Server error: Failed to connect${NC}"
fi

echo -e "\n${GREEN}=== Testing Auth Service ===${NC}"
# Register a test user
random_num=$RANDOM
register_data="{\"username\":\"testuser_$random_num\",\"email\":\"testuser_$random_num@example.com\",\"password\":\"password123\",\"fullName\":\"Test User\",\"role\":\"USER\"}"

echo -e "${YELLOW}Registering new user...${NC}"
if register_response=$(curl -s -X POST "http://localhost:8081/api/auth/register" \
    -H "Content-Type: application/json" \
    -d "$register_data"); then
    echo -e "${GREEN}Registration successful${NC}"
    username=$(echo $register_response | jq -r '.username')
    echo "Username: $username"

    # Login with registered user
    login_data="{\"username\":\"$username\",\"password\":\"password123\"}"
    echo -e "${YELLOW}Logging in...${NC}"
    if login_response=$(curl -s -X POST "http://localhost:8081/api/auth/login" \
        -H "Content-Type: application/json" \
        -d "$login_data"); then
        echo -e "${GREEN}Login successful${NC}"
        token=$(echo $login_response | jq -r '.token')
    else
        echo -e "${RED}Login failed${NC}"
        exit 1
    fi
else
    echo -e "${RED}Registration failed${NC}"
    exit 1
fi

echo -e "\n${GREEN}=== Testing Search Service ===${NC}"
# Index a test post
post_data="{\"title\":\"Test Post $random_num\",\"content\":\"This is a test post content\",\"userId\":\"1\",\"category\":\"TEST\"}"

echo -e "${YELLOW}Creating test post...${NC}"
if index_response=$(curl -s -X POST "http://localhost:8091/api/v1/search/posts" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $token" \
    -d "$post_data"); then
    echo -e "${GREEN}Post indexed successfully${NC}"

    # Search for posts
    echo -e "${YELLOW}Searching posts...${NC}"
    if search_response=$(curl -s "http://localhost:8091/api/v1/search/posts?query=test" \
        -H "Authorization: Bearer $token"); then
        echo -e "${GREEN}Search successful${NC}"
        posts_count=$(echo $search_response | jq '. | length')
        echo "Found $posts_count posts"
    else
        echo -e "${RED}Search failed${NC}"
    fi
else
    echo -e "${RED}Post indexing failed${NC}"
fi

echo -e "\n${GREEN}=== Testing News Feed Service ===${NC}"
# Create a test feed post
feed_post_data="{\"title\":\"Feed Test Post $random_num\",\"content\":\"This is a test feed post content\",\"userId\":\"1\"}"

echo -e "${YELLOW}Creating feed post...${NC}"
if feed_response=$(curl -s -X POST "http://localhost:8085/api/v1/feed/posts" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $token" \
    -d "$feed_post_data"); then
    echo -e "${GREEN}Feed post created successfully${NC}"

    # Get feed
    echo -e "${YELLOW}Fetching feed...${NC}"
    if get_feed_response=$(curl -s "http://localhost:8085/api/v1/feed" \
        -H "Authorization: Bearer $token"); then
        echo -e "${GREEN}Feed fetched successfully${NC}"
        feed_count=$(echo $get_feed_response | jq '. | length')
        echo "Found $feed_count items in feed"
    else
        echo -e "${RED}Feed fetch failed${NC}"
    fi
else
    echo -e "${RED}Feed post creation failed${NC}"
fi

echo -e "\n${GREEN}=== Testing User Service ===${NC}"
echo -e "${YELLOW}Fetching user profile...${NC}"
if user_response=$(curl -s "http://localhost:8082/api/users/profile" \
    -H "Authorization: Bearer $token"); then
    echo -e "${GREEN}User profile fetched successfully${NC}"

    # Update user profile
    update_profile_data="{\"fullName\":\"Updated Test User\",\"bio\":\"This is a test bio\"}"
    if update_response=$(curl -s -X PUT "http://localhost:8082/api/users/profile" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $token" \
        -d "$update_profile_data"); then
        echo -e "${GREEN}Profile updated successfully${NC}"
    else
        echo -e "${RED}Profile update failed${NC}"
    fi
else
    echo -e "${RED}User profile fetch failed${NC}"
fi

echo -e "\n${GREEN}=== Testing Post Service ===${NC}"
# Create a new post
post_create_data="{\"title\":\"Test Post from Post Service $random_num\",\"content\":\"This is a test post content\",\"category\":\"TEST\"}"

echo -e "${YELLOW}Creating post...${NC}"
if post_response=$(curl -s -X POST "http://localhost:8083/api/v1/posts" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $token" \
    -d "$post_create_data"); then
    echo -e "${GREEN}Post created successfully${NC}"

    # Get posts
    if posts_response=$(curl -s "http://localhost:8083/api/v1/posts" \
        -H "Authorization: Bearer $token"); then
        echo -e "${GREEN}Posts fetched successfully${NC}"
    else
        echo -e "${RED}Posts fetch failed${NC}"
    fi
else
    echo -e "${RED}Post creation failed${NC}"
fi

echo -e "\n${GREEN}=== Testing Rating & Review Service ===${NC}"
# Create a review
review_data="{\"postId\":\"1\",\"rating\":5,\"comment\":\"This is a test review\"}"

echo -e "${YELLOW}Creating review...${NC}"
if review_response=$(curl -s -X POST "http://localhost:8084/api/v1/reviews" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $token" \
    -d "$review_data"); then
    echo -e "${GREEN}Review created successfully${NC}"

    # Get reviews for a post
    if reviews_response=$(curl -s "http://localhost:8084/api/v1/reviews/post/1" \
        -H "Authorization: Bearer $token"); then
        echo -e "${GREEN}Reviews fetched successfully${NC}"
    else
        echo -e "${RED}Reviews fetch failed${NC}"
    fi
else
    echo -e "${RED}Review creation failed${NC}"
fi

echo -e "\n${GREEN}=== Testing Messaging Service ===${NC}"
# Send a message
message_data="{\"recipientId\":\"2\",\"content\":\"This is a test message\"}"

echo -e "${YELLOW}Sending message...${NC}"
if message_response=$(curl -s -X POST "http://localhost:8084/api/messages" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $token" \
    -d "$message_data"); then
    echo -e "${GREEN}Message sent successfully${NC}"

    # Get conversations
    if conversations_response=$(curl -s "http://localhost:8084/api/messages/conversations" \
        -H "Authorization: Bearer $token"); then
        echo -e "${GREEN}Conversations fetched successfully${NC}"
    else
        echo -e "${RED}Conversations fetch failed${NC}"
    fi
else
    echo -e "${RED}Message sending failed${NC}"
fi

echo -e "\n${GREEN}=== Testing Notifications Service ===${NC}"
echo -e "${YELLOW}Fetching notifications...${NC}"
if notifications_response=$(curl -s "http://localhost:8087/api/v1/notifications" \
    -H "Authorization: Bearer $token"); then
    echo -e "${GREEN}Notifications fetched successfully${NC}"

    # Mark notification as read
    if mark_read_response=$(curl -s -X PUT "http://localhost:8087/api/v1/notifications/1/read" \
        -H "Authorization: Bearer $token"); then
        echo -e "${GREEN}Notification marked as read${NC}"
    else
        echo -e "${RED}Failed to mark notification as read${NC}"
    fi
else
    echo -e "${RED}Notifications fetch failed${NC}"
fi

echo -e "\n${GREEN}=== Testing Moderation Service ===${NC}"
# Report content
report_data="{\"contentId\":\"1\",\"contentType\":\"POST\",\"reason\":\"TEST_REPORT\",\"description\":\"This is a test report\"}"

echo -e "${YELLOW}Reporting content...${NC}"
if report_response=$(curl -s -X POST "http://localhost:8088/api/v1/moderation/reports" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $token" \
    -d "$report_data"); then
    echo -e "${GREEN}Content reported successfully${NC}"
else
    echo -e "${RED}Content reporting failed${NC}"
fi

echo -e "\n${GREEN}=== Testing Awards Service ===${NC}"
echo -e "${YELLOW}Fetching achievements...${NC}"
if achievements_response=$(curl -s "http://localhost:8089/api/v1/awards/achievements" \
    -H "Authorization: Bearer $token"); then
    echo -e "${GREEN}Achievements fetched successfully${NC}"

    # Get leaderboard
    if leaderboard_response=$(curl -s "http://localhost:8089/api/v1/awards/leaderboard" \
        -H "Authorization: Bearer $token"); then
        echo -e "${GREEN}Leaderboard fetched successfully${NC}"
    else
        echo -e "${RED}Leaderboard fetch failed${NC}"
    fi
else
    echo -e "${RED}Achievements fetch failed${NC}"
fi

echo -e "\n${GREEN}=== Testing Monitoring Service ===${NC}"
echo -e "${YELLOW}Fetching system metrics...${NC}"
if metrics_response=$(curl -s "http://localhost:8090/api/v1/monitoring/metrics" \
    -H "Authorization: Bearer $token"); then
    echo -e "${GREEN}System metrics fetched successfully${NC}"

    # Get service health
    if health_response=$(curl -s "http://localhost:8090/api/v1/monitoring/health" \
        -H "Authorization: Bearer $token"); then
        echo -e "${GREEN}Service health status fetched successfully${NC}"
    else
        echo -e "${RED}Service health status fetch failed${NC}"
    fi
else
    echo -e "${RED}System metrics fetch failed${NC}"
fi

echo -e "\n${GREEN}=== All Tests Completed ===${NC}" 