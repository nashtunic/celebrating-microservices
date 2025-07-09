@echo off
echo ========================================
echo    Celebrating Microservices Docker
echo ========================================
echo.

powershell -ExecutionPolicy Bypass -File "docker-build-and-run.ps1" %*

echo.
echo ========================================
echo Deployment completed!
echo ========================================
pause 