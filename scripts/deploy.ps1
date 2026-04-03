# Deploy script for Deathless WoW addon (local dev build)
# Deploys to "deathless-dev" so the CurseForge-managed "deathless" folder is untouched.
# Only enable one of the two in-game at a time (they share the same global namespace).

$ScriptDir = $PSScriptRoot
$SourceDir = Split-Path -Parent $ScriptDir
$AddOnsDir = "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns"
$TargetDir = Join-Path $AddOnsDir "deathless-dev"

Write-Host "Deploying Deathless (Dev) addon..." -ForegroundColor Green
Write-Host "Source: $SourceDir" -ForegroundColor Cyan
Write-Host "Target: $TargetDir" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $SourceDir)) {
    Write-Host "Error: Source directory not found!" -ForegroundColor Red
    exit 1
}

if (Test-Path $TargetDir) {
    Write-Host "Removing existing dev addon folder..." -ForegroundColor Yellow
    Remove-Item -Path $TargetDir -Recurse -Force -ErrorAction Stop
}

Write-Host "Creating target directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

Write-Host "Copying addon files..." -ForegroundColor Yellow

# Generate deathless-dev.toc from deathless.toc with dev-specific overrides
$TocSource = Join-Path $SourceDir "deathless.toc"
$TocTarget = Join-Path $TargetDir "deathless-dev.toc"
(Get-Content $TocSource -Raw) `
    -replace '## Title: Deathless', '## Title: Deathless (Dev)' `
    -replace '@project-version@', 'dev' |
    Set-Content $TocTarget -NoNewline
Write-Host "  Generated: deathless-dev.toc" -ForegroundColor Gray

# Copy root .lua files (replacing version token)
Get-ChildItem -Path $SourceDir -Filter "*.lua" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content -replace '@project-version@', 'dev'
    Set-Content -Path (Join-Path $TargetDir $_.Name) -Value $content -NoNewline
    Write-Host "  Copied: $($_.Name)" -ForegroundColor Gray
}

# Copy directories (core, modules, ui, data, utils)
$DirectoriesToCopy = @("core", "data", "modules", "textures", "ui", "utils")

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
Write-Host "Remember: disable 'Deathless' (CurseForge) and enable 'Deathless (Dev)' in the addon list." -ForegroundColor Yellow
Write-Host "Reload your UI in WoW (/reload) to test." -ForegroundColor Yellow
