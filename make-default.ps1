# BraveOriginFree - Set as Default Browser (Windows)
# Sets Brave Origin as the default browser for HTTP/HTTPS and common file types

$ErrorActionPreference = "SilentlyContinue"

$AppDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BinDir = Join-Path $AppDir "bin"
$DataDir = Join-Path $AppDir "data"
$OriginExe = Join-Path $BinDir "brave.exe"
$AppName = "BraveOriginFree"

if (-not (Test-Path $OriginExe)) {
    Write-Host "[!] Brave Origin not found. Run install.bat first." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Set Brave Origin as Default Browser" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will register Brave Origin as handler for:" -ForegroundColor Gray
Write-Host "  - HTTP and HTTPS protocols" -ForegroundColor Gray
Write-Host "  - .html, .htm files" -ForegroundColor Gray
Write-Host ""
Write-Host "[~] Registering..." -ForegroundColor Yellow

# Create ProgID
$progId = "BraveOriginFreeHTML"
$regPath = "HKCU:\Software\Classes\$progId"
New-Item -Path $regPath -Force | Out-Null
New-ItemProperty -Path $regPath -Name "(Default)" -Value "Brave Origin Free" -PropertyType String -Force | Out-Null
New-Item -Path "$regPath\DefaultIcon" -Force | Out-Null
New-ItemProperty -Path "$regPath\DefaultIcon" -Name "(Default)" -Value "`"$OriginExe`",0" -PropertyType String -Force | Out-Null
New-Item -Path "$regPath\shell\open\command" -Force | Out-Null
New-ItemProperty -Path "$regPath\shell\open\command" -Name "(Default)" -Value "`"$OriginExe`" --user-data-dir=`"$DataDir`" --no-first-run --no-default-browser-check `"%1`"" -PropertyType String -Force | Out-Null

# Register for HTTP/HTTPS
@("http", "https", ".html", ".htm") | ForEach-Object {
    $p = "HKCU:\Software\Classes\$_"
    New-Item -Path $p -Force | Out-Null
    New-ItemProperty -Path $p -Name "(Default)" -Value $progId -PropertyType String -Force | Out-Null
}

# Register in RegisteredApplications
$regApps = "HKCU:\Software\RegisteredApplications"
New-Item -Path $regApps -Force | Out-Null
New-ItemProperty -Path $regApps -Name $AppName -Value "Software\Clients\StartMenuInternet\$AppName\Capabilities" -PropertyType String -Force | Out-Null

# Capabilities
$caps = "HKCU:\Software\Clients\StartMenuInternet\$AppName\Capabilities"
New-Item -Path $caps -Force | Out-Null
New-ItemProperty -Path $caps -Name "ApplicationDescription" -Value "Brave Origin - Free for Windows" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $caps -Name "ApplicationName" -Value "Brave Origin Free" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $caps -Name "ApplicationIcon" -Value "`"$OriginExe`",0" -PropertyType String -Force | Out-Null

New-Item -Path "$caps\URLAssociations" -Force | Out-Null
New-ItemProperty -Path "$caps\URLAssociations" -Name "http" -Value $progId -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$caps\URLAssociations" -Name "https" -Value $progId -PropertyType String -Force | Out-Null

New-Item -Path "$caps\FileAssociations" -Force | Out-Null
New-ItemProperty -Path "$caps\FileAssociations" -Name ".html" -Value $progId -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$caps\FileAssociations" -Name ".htm" -Value $progId -PropertyType String -Force | Out-Null

# Register app
$appReg = "HKCU:\Software\Clients\StartMenuInternet\$AppName"
New-Item -Path $appReg -Force | Out-Null
New-ItemProperty -Path $appReg -Name "(Default)" -Value "Brave Origin Free" -PropertyType String -Force | Out-Null
New-Item -Path "$appReg\DefaultIcon" -Force | Out-Null
New-ItemProperty -Path "$appReg\DefaultIcon" -Name "(Default)" -Value "`"$OriginExe`",0" -PropertyType String -Force | Out-Null
New-Item -Path "$appReg\shell\open\command" -Force | Out-Null
New-ItemProperty -Path "$appReg\shell\open\command" -Name "(Default)" -Value "`"$OriginExe`" --user-data-dir=`"$DataDir`" --no-first-run --no-default-browser-check" -PropertyType String -Force | Out-Null

Write-Host "[O] Registration complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Note: On Windows 10/11, the 'Default Apps' setting may still" -ForegroundColor Yellow
Write-Host "show the system prompt. If it does:" -ForegroundColor Yellow
Write-Host "  1. Open Settings > Apps > Default apps" -ForegroundColor Gray
Write-Host "  2. Search for 'Brave Origin Free'" -ForegroundColor Gray
Write-Host "  3. Set it as default for HTTP/HTTPS" -ForegroundColor Gray
Write-Host ""
Read-Host "Press Enter to exit"
