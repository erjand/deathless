@echo off
REM Deploy script wrapper for Deathless WoW addon
REM Allows double-click execution without PowerShell execution policy issues

echo Deploying Deathless addon...
echo.

REM Run the PowerShell script with bypass execution policy
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0deploy.ps1"

REM Pause so user can see the output
pause

