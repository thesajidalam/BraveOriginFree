# BraveOriginFree - Source files

param(
    [string]$ProfilePath,
    [switch]$Status
)

Write-Host "BraveOriginFree - Standalone Patcher" -ForegroundColor Cyan
Write-Host ""

# Auto-detect paths
$detectedPaths = @(
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Origin\User Data",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Origin-Beta\User Data",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Origin-Nightly\User Data",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser-Beta\User Data",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser-Nightly\User Data"
)

if (-not $ProfilePath) {
    foreach ($p in $detectedPaths) {
        if (Test-Path (Join-Path $p "Local State")) {
            $ProfilePath = $p
            break
        }
    }
}

if (-not $ProfilePath) {
    Write-Host "Could not find a Brave profile." -ForegroundColor Yellow
    Write-Host "Usage:" -ForegroundColor Gray
    Write-Host "  .\src\bypass.ps1                          # Auto-detect"
    Write-Host "  .\src\bypass.ps1 -Status                   # Check status"
    Write-Host "  .\src\bypass.ps1 -ProfilePath `"C:\path\`" # Manual path"
    Write-Host ""
    exit 1
}

$LocalState = Join-Path $ProfilePath "Local State"

if ($Status) {
    try {
        $state = Get-Content $LocalState -Raw | ConvertFrom-Json
        if ($state.brave.origin.purchase_validated -eq $true) {
            Write-Host "Status: ACTIVATED (purchase_validated = true)" -ForegroundColor Green
        } else {
            Write-Host "Status: NOT ACTIVATED" -ForegroundColor Red
        }
    } catch {
        Write-Host "Status: Unknown" -ForegroundColor Yellow
    }
    exit 0
}

Write-Host "Profile: $ProfilePath" -ForegroundColor Gray
Write-Host "Applying activation..." -ForegroundColor Yellow

try {
    $state = Get-Content $LocalState -Raw | ConvertFrom-Json

    if (-not $state.brave) { $state | Add-Member -Name "brave" -Value @{} -MemberType NoteProperty -Force }
    if (-not $state.brave.origin) { $state.brave | Add-Member -Name "origin" -Value @{} -MemberType NoteProperty -Force }
    $state.brave.origin.purchase_validated = $true

    if (-not $state.skus) { $state | Add-Member -Name "skus" -Value @{ state = @{} } -MemberType NoteProperty -Force }
    if (-not $state.skus.state) { $state.skus | Add-Member -Name "state" -Value @{} -MemberType NoteProperty -Force }
    $state.skus.state."67" = '{"credentials":{"items":{"6":"7"}}}'

    $state | ConvertTo-Json -Depth 10 -Compress | Out-File -FilePath $LocalState -Encoding UTF8 -Force
    Write-Host "Activation applied successfully." -ForegroundColor Green
    Write-Host "Restart Brave Origin if it's running." -ForegroundColor Cyan
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
