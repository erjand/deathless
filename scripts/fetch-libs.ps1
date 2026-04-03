# Fetch external libraries for local development.
# The CurseForge packager handles this automatically for releases via .pkgmeta externals.
# This script downloads the same libraries from their canonical sources for local/dev builds.

$ScriptDir = $PSScriptRoot
$LibsDir = Join-Path (Split-Path -Parent $ScriptDir) "libs"

$Libraries = @(
    @{
        Name = "LibStub"
        Dir  = "LibStub"
        Files = @(
            @{ Url = "https://repos.curseforge.com/wow/libstub/trunk/LibStub.lua?format=raw"; Out = "LibStub.lua" }
        )
    },
    @{
        Name = "CallbackHandler-1.0"
        Dir  = "CallbackHandler-1.0"
        Files = @(
            @{ Url = "https://repos.curseforge.com/wow/callbackhandler/trunk/CallbackHandler-1.0/CallbackHandler-1.0.lua?format=raw"; Out = "CallbackHandler-1.0.lua" }
        )
    },
    @{
        Name = "LibDataBroker-1.1"
        Dir  = "LibDataBroker-1.1"
        Files = @(
            @{ Url = "https://raw.githubusercontent.com/tekkub/libdatabroker-1-1/master/LibDataBroker-1.1.lua"; Out = "LibDataBroker-1.1.lua" }
        )
    },
    @{
        Name = "LibDBIcon-1.0"
        Dir  = "LibDBIcon-1.0"
        Files = @(
            @{ Url = "https://repos.curseforge.com/wow/libdbicon-1-0/trunk/LibDBIcon-1.0/LibDBIcon-1.0.lua?format=raw"; Out = "LibDBIcon-1.0.lua" }
        )
    }
)

$failed = 0

Write-Host "Fetching libraries for local development..." -ForegroundColor Green
Write-Host "Target: $LibsDir" -ForegroundColor Cyan
Write-Host ""

foreach ($Lib in $Libraries) {
    $TargetDir = Join-Path $LibsDir $Lib.Dir
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    Write-Host "  $($Lib.Name)" -ForegroundColor White
    foreach ($File in $Lib.Files) {
        $OutPath = Join-Path $TargetDir $File.Out
        try {
            Invoke-WebRequest -Uri $File.Url -OutFile $OutPath -UseBasicParsing -ErrorAction Stop
            Write-Host "    OK: $($File.Out)" -ForegroundColor Gray
        } catch {
            Write-Host "    FAILED: $($File.Out) - $_" -ForegroundColor Red
            $failed++
        }
    }
}

Write-Host ""
if ($failed -gt 0) {
    Write-Host "$failed file(s) failed to download." -ForegroundColor Red
    exit 1
} else {
    Write-Host "All libraries fetched successfully." -ForegroundColor Green
}
