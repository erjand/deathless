@echo off
setlocal

echo Generating Lua data from CSV sources...
echo.

set SCRIPT_DIR=%~dp0
set EXIT_CODE=0

call :run_ps1 "generate-amulets.ps1"
call :run_ps1 "generate-armor-slots.ps1"
call :run_ps1 "generate-back.ps1"
call :run_ps1 "generate-ranged.ps1"
call :run_ps1 "generate-rings.ps1"
call :run_ps1 "generate-shields.ps1"
call :run_ps1 "generate-trinkets.ps1"
call :run_ps1 "generate-weapons.ps1"

if %EXIT_CODE% neq 0 (
    echo.
    echo One or more generation steps failed.
    if /I not "%DLS_NO_PAUSE%"=="1" pause
    exit /b %EXIT_CODE%
)

echo.
echo All CSV generation scripts completed successfully.
if /I not "%DLS_NO_PAUSE%"=="1" pause
exit /b 0

:run_ps1
set SCRIPT_NAME=%~1
echo Running %SCRIPT_NAME%...
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_DIR%%SCRIPT_NAME%"
if %errorlevel% neq 0 (
    echo FAILED: %SCRIPT_NAME%
    set EXIT_CODE=%errorlevel%
    goto :eof
)
echo OK: %SCRIPT_NAME%
echo.
goto :eof
