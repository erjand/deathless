@echo off
setlocal

echo Generating data and deploying Deathless addon...
echo.

set SCRIPT_DIR=%~dp0

echo Step 1/2: Generating Lua from CSV...
set DLS_NO_PAUSE=1
call "%SCRIPT_DIR%generate-all-csv.bat"
if %errorlevel% neq 0 (
    echo.
    echo Generation failed. Deployment was not started.
    pause
    exit /b %errorlevel%
)

echo.
echo Step 2/2: Deploying addon...
call "%SCRIPT_DIR%deploy.bat"
if %errorlevel% neq 0 (
    echo.
    echo Deploy failed.
    pause
    exit /b %errorlevel%
)

echo.
echo Generate + deploy completed successfully.
pause
exit /b 0
