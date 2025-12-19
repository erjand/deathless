# Deploy script for Deathless WoW addon
# Copies addon files to WoW Classic Era AddOns directory

$SourceDir = $PSScriptRoot
$TargetDir = "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\deathless"

# Files and directories to exclude
$ExcludeItems = @(
    ".git",
    ".cursor",
    ".gitignore",
    "README.md",
    "deploy.ps1",
    "*.ps1",
    "*.md"
)

Write-Host "Deploying Deathless addon..." -ForegroundColor Green
Write-Host "Source: $SourceDir" -ForegroundColor Cyan
Write-Host "Target: $TargetDir" -ForegroundColor Cyan
Write-Host ""

# Check if source directory exists
if (-not (Test-Path $SourceDir)) {
    Write-Host "Error: Source directory not found!" -ForegroundColor Red
    exit 1
}

# Create target directory if it doesn't exist
if (-not (Test-Path $TargetDir)) {
    Write-Host "Creating target directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

# Copy files, excluding development files
Write-Host "Copying addon files..." -ForegroundColor Yellow

# Copy .toc and .lua files from root
Get-ChildItem -Path $SourceDir -Filter "*.toc" | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $TargetDir -Force
    Write-Host "  Copied: $($_.Name)" -ForegroundColor Gray
}

Get-ChildItem -Path $SourceDir -Filter "*.lua" | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $TargetDir -Force
    Write-Host "  Copied: $($_.Name)" -ForegroundColor Gray
}

# Copy directories (core, modules, ui, data, utils)
$DirectoriesToCopy = @("core", "modules", "ui", "data", "utils")

foreach ($Dir in $DirectoriesToCopy) {
    $SourcePath = Join-Path $SourceDir $Dir
    $TargetPath = Join-Path $TargetDir $Dir
    
    if (Test-Path $SourcePath) {
        Write-Host "  Copying directory: $Dir" -ForegroundColor Gray
        Copy-Item -Path $SourcePath -Destination $TargetPath -Recurse -Force
    }
}

Write-Host ""
Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host "Addon installed to: $TargetDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now test the addon in WoW Classic Era." -ForegroundColor Yellow

