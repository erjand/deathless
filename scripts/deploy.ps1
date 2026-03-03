# Deploy script for Deathless WoW addon
# Copies addon files to WoW Classic Era AddOns directory

$ScriptDir = $PSScriptRoot
$SourceDir = Split-Path -Parent $ScriptDir
$TargetDir = "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\deathless"

Write-Host "Deploying Deathless addon..." -ForegroundColor Green
Write-Host "Source: $SourceDir" -ForegroundColor Cyan
Write-Host "Target: $TargetDir" -ForegroundColor Cyan
Write-Host ""

# Check if source directory exists
if (-not (Test-Path $SourceDir)) {
    Write-Host "Error: Source directory not found!" -ForegroundColor Red
    exit 1
}

# Remove existing addon folder if it exists
if (Test-Path $TargetDir) {
    Write-Host "Removing existing addon folder..." -ForegroundColor Yellow
    Remove-Item -Path $TargetDir -Recurse -Force -ErrorAction Stop
}

# Create target directory
Write-Host "Creating target directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

# Copy .toc and .lua files from root
Write-Host "Copying addon files..." -ForegroundColor Yellow

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
        
        # Create the target directory
        New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
        
        # Copy all files recursively
        Get-ChildItem -Path $SourcePath -Recurse | ForEach-Object {
            $relativePath = $_.FullName.Substring($SourcePath.Length + 1)
            $destPath = Join-Path $TargetPath $relativePath
            
            if ($_.PSIsContainer) {
                New-Item -ItemType Directory -Path $destPath -Force | Out-Null
            } else {
                $destDir = Split-Path $destPath -Parent
                if (-not (Test-Path $destDir)) {
                    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                }
                Copy-Item -Path $_.FullName -Destination $destPath -Force
            }
        }
    }
}

Write-Host ""
Write-Host "Deployment complete!" -ForegroundColor Green

# Verify deployment
$fileCount = (Get-ChildItem -Path $TargetDir -Recurse -File).Count
Write-Host "Files deployed: $fileCount" -ForegroundColor Cyan
Write-Host "Addon installed to: $TargetDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "Reload your UI in WoW (/reload) to test." -ForegroundColor Yellow
