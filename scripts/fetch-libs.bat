@echo off
REM Fetch external libraries for local development

echo Fetching external libraries...
echo.

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0fetch-libs.ps1"

pause
