# WatchAtlas Windows Build & Package Script
# Prerequisites:
#   - Flutter SDK
#   - Inno Setup 6+ (https://jrsoftware.org/isinfo.php) added to PATH
#
# Usage:
#   .\windows\installer\build_installer.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot | Split-Path -Parent
$releaseDir = Join-Path $root "build\windows\x64\runner\Release"
$installerDir = Join-Path $root "build\installer"
$issFile = Join-Path $PSScriptRoot "watch_atlas.iss"

Write-Host "=== WatchAtlas Windows Installer Build ===" -ForegroundColor Cyan

# 1. Build Flutter release
Write-Host "`n[1/3] Building Flutter Windows release..." -ForegroundColor Yellow
Push-Location $root
flutter build windows --release
if ($LASTEXITCODE -ne 0) { throw "Flutter build failed" }
Pop-Location

# 2. Verify build output
if (-not (Test-Path (Join-Path $releaseDir "watch_atlas.exe"))) {
    throw "Build output not found at $releaseDir"
}
Write-Host "  Build output verified." -ForegroundColor Green

# 3. Package with Inno Setup
$iscc = Get-Command iscc -ErrorAction SilentlyContinue
if (-not $iscc) {
    Write-Host "`n[!] Inno Setup (iscc.exe) not found in PATH." -ForegroundColor Red
    Write-Host "    Install from: https://jrsoftware.org/isinfo.php" -ForegroundColor Yellow
    Write-Host "    Or manually open the .iss file in Inno Setup Compiler." -ForegroundColor Yellow
    exit 0
}

Write-Host "`n[2/3] Packaging installer with Inno Setup..." -ForegroundColor Yellow
& iscc $issFile
if ($LASTEXITCODE -ne 0) { throw "Inno Setup build failed" }

# 4. Report
$setupExe = Get-ChildItem $installerDir -Filter "*.exe" | Select-Object -First 1
if ($setupExe) {
    $sizeMB = [math]::Round($setupExe.Length / 1MB, 1)
    Write-Host "`n[3/3] Installer created:" -ForegroundColor Green
    Write-Host "  $($setupExe.FullName) ($sizeMB MB)" -ForegroundColor White
} else {
    Write-Host "`n  Installer created in $installerDir" -ForegroundColor Green
}

Write-Host "`n=== Done ===" -ForegroundColor Cyan
