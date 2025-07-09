# Kafka Automated Test Scripts

This directory contains automated scripts to test your Kafka infrastructure and verify that everything is working correctly after restarting servers.

## 📁 Files

- `test-kafka-simple.ps1` - Main PowerShell test script
- `test-kafka.bat` - Windows batch file for easy execution
- `test-kafka-automated.ps1` - Advanced PowerShell script (if needed)

## 🚀 Quick Start

### Option 1: Double-click the batch file
Simply double-click `test-kafka.bat` to run the test.

### Option 2: Run from PowerShell
```powershell
powershell -ExecutionPolicy Bypass -File "test-kafka-simple.ps1"
```

### Option 3: Run from Command Prompt
```cmd
test-kafka.bat
```

## 🧪 What the Script Tests

The automated test script verifies:

### 1. Docker Containers
- ✅ Zookeeper container is running
- ✅ Kafka container is running  
- ✅ Kafka UI container is running

### 2. Kafka Topics
- ✅ user-events
- ✅ notification-events
- ✅ post-events
- ✅ message-events
- ✅ feed-events
- ✅ rating-events
- ✅ award-events
- ✅ moderation-events
- ✅ monitoring-events

### 3. Kafka UI
- ✅ Kafka UI is accessible on http://localhost:8090

### 4. Producer Test
- ✅ Can send messages to user-events topic

## 📊 Expected Output

When everything is working correctly, you should see:

```
🔍 Testing Kafka Infrastructure...

🐳 Testing Docker Containers...
✅ zookeeper is running
✅ kafka is running
✅ kafka-ui is running

📋 Testing Kafka Topics...
✅ Topic 'user-events' exists
✅ Topic 'notification-events' exists
✅ Topic 'post-events' exists
✅ Topic 'message-events' exists
✅ Topic 'feed-events' exists
✅ Topic 'rating-events' exists
✅ Topic 'award-events' exists
✅ Topic 'moderation-events' exists
✅ Topic 'monitoring-events' exists

🖥️ Testing Kafka UI...
✅ Kafka UI is accessible

🔄 Testing Producer...
✅ Test message sent successfully

📊 Test Summary:
=================
✅ PASS Docker Containers
✅ PASS Kafka Topics
✅ PASS Kafka UI
✅ PASS Producer Test

📈 Results: 4/4 tests passed
🎉 All tests passed! Kafka is ready.
```

## 🔧 Troubleshooting

### If Docker containers are not running:
```bash
docker-compose up -d
```

### If topics are missing:
```bash
# Create all topics
docker exec kafka kafka-topics --create --topic user-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
docker exec kafka kafka-topics --create --topic notification-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
# ... (repeat for all topics)
```

### If Kafka UI is not accessible:
- Check if port 8090 is available
- Verify the kafka-ui container is running
- Check Docker logs: `docker logs kafka-ui`

### If producer test fails:
- Verify Kafka broker is running: `docker logs kafka`
- Check if user-events topic exists
- Ensure no network connectivity issues

## 📝 Usage Tips

1. **Run after server restart**: Always run this script after restarting your microservices to verify Kafka is working
2. **Before development**: Run before starting development to ensure infrastructure is ready
3. **Troubleshooting**: Use this script to quickly identify what's broken in your Kafka setup
4. **CI/CD**: This script can be integrated into your CI/CD pipeline for automated testing

## 🔗 Related Links

- Kafka UI: http://localhost:8090
- Kafka Broker: localhost:9092
- Zookeeper: localhost:2181

## 📞 Support

If you encounter issues:
1. Check the error messages in the script output
2. Verify Docker containers are running
3. Check Kafka logs: `docker logs kafka`
4. Ensure all required topics are created 