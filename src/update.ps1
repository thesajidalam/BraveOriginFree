# BraveOriginFree - Update Checker

param([switch]$CheckOnly)

$AppDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Resolve-Path (Join-Path $AppDir "..")
$BinDir = Join-Path $RootDir "bin"
$DataDir = Join-Path $RootDir "data"
$OriginExe = Join-Path $BinDir "brave.exe"
$VersionFile = Join-Path $RootDir "version.txt"

Write-Host "BraveOriginFree - Update Checker" -ForegroundColor Cyan
Write-Host ""

# Current version
$current = "unknown"
if (Test-Path $VersionFile) {
    $current = (Get-Content $VersionFile -Raw).Trim()
} elseif (Test-Path $OriginExe) {
    try { $current = (Get-Item $OriginExe).VersionInfo.FileVersion } catch {}
}
Write-Host "Installed: v$current" -ForegroundColor Gray

# Latest from GitHub
Write-Host "Checking for updates..." -ForegroundColor Yellow
try {
    $release = Invoke-WebRequest "https://api.github.com/repos/brave/brave-browser/releases/latest" -UseBasicParsing -TimeoutSec 15 | ConvertFrom-Json
    $latest = $release.tag_name -replace '^v', ''
    Write-Host "Latest:    v$latest" -ForegroundColor Gray
} catch {
    Write-Host "Could not reach GitHub. Check your internet." -ForegroundColor Red
    exit 1
}

if ($current -eq $latest) {
    Write-Host "You have the latest version." -ForegroundColor Green
    exit 0
}

if ($current -eq "unknown") {
    Write-Host "New version available: v$latest" -ForegroundColor Yellow
} else {
    Write-Host "Update available: v$current -> v$latest" -ForegroundColor Yellow
}

if ($CheckOnly) { exit 0 }

# Download
$zipUrl = "https://github.com/brave/brave-browser/releases/download/v$latest/brave-origin-v$latest-win32-x64.zip"
$zipPath = Join-Path $RootDir "brave-origin-v$latest.zip"

Write-Host "Downloading v$latest..." -ForegroundColor Yellow
try {
    Invoke-WebRequest $zipUrl -OutFile $zipPath -UseBasicParsing -TimeoutSec 600
} catch {
    Write-Host "Download failed: $_" -ForegroundColor Red
    exit 1
}

# Backup
$backup = Join-Path $RootDir "bin.bak"
if (Test-Path $BinDir) {
    Remove-Item -Recurse -Force $backup -ErrorAction SilentlyContinue
    Move-Item $BinDir $backup -Force
    Write-Host "Backed up old version" -ForegroundColor Gray
}

# Extract
New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
try {
    Expand-Archive $zipPath $BinDir -Force
    Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
    $latest | Out-File $VersionFile -Encoding UTF8 -Force
    Write-Host "Updated to v$latest" -ForegroundColor Green
} catch {
    Write-Host "Extraction failed: $_" -ForegroundColor Red
    if (Test-Path $backup) {
        Remove-Item -Recurse -Force $BinDir -ErrorAction SilentlyContinue
        Move-Item $backup $BinDir -Force
    }
    exit 1
}

# Clean up
Remove-Item -Recurse -Force $backup -ErrorAction SilentlyContinue

# Re-apply bypass
$LocalState = Join-Path $DataDir "Local State"
if (Test-Path $LocalState) {
    try {
        $state = Get-Content $LocalState -Raw | ConvertFrom-Json
        if (-not $state.brave.origin.purchase_validated) {
            $state.brave.origin = @{ purchase_validated = $true }
            $state | ConvertTo-Json -Depth 10 -Compress | Out-File $LocalState -Encoding UTF8 -Force
            Write-Host "Activation re-applied" -ForegroundColor Green
        }
    } catch {}
}

Write-Host ""
Write-Host "Done. Run run.bat to start the updated browser." -ForegroundColor Cyan
