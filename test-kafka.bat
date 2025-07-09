@echo off
echo ========================================
echo    Kafka Infrastructure Test Script
echo ========================================
echo.

powershell -ExecutionPolicy Bypass -File "test-kafka-simple.ps1"

echo.
echo ========================================
echo Test completed. Check the results above.
echo ========================================
pause 