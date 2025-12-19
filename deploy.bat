@echo off
REM Deploy script wrapper for Deathless WoW addon
REM Runs with admin privileges to write to Program Files

echo Deploying Deathless addon...
echo.

REM Check for admin rights and request if needed
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

REM Run the PowerShell script with bypass execution policy
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0deploy.ps1"

REM Pause so user can see the output
pause
