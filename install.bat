@echo off
setlocal enabledelayedexpansion
title BraveOriginFree - Ultimate Installer
color 0B

:: Check admin - we don't need it, but let users know
net session >nul 2>&1
if %errorlevel% equ 0 (
    echo [!] Warning: Running as admin is not required.
    echo [!] BraveOriginFree works without admin rights.
    echo.
)

:: Welcome
echo.
echo  ============================================
echo     Brave Origin for Windows - Absolutely Free
echo     by Sajid Alam
echo     https://github.com/thesajidalam/BraveOriginFree
echo  ============================================
echo.
echo  Brave Origin costs $60 on Windows.
echo  On Linux it's free. This fixes that.
echo.
echo  What this installer will do:
echo    1. Download the official Brave Origin (signed by Brave)
echo    2. Apply the free activation bypass
echo    3. Create a shortcut on your desktop
echo    4. Launch your new browser
echo.
echo  No installation required. No admin rights. No registry changes.
echo  Works from USB drives. Takes 2 minutes.
echo.

set "APP_DIR=%~dp0"
set "APP_DIR=%APP_DIR:\=/%"
set "BIN_DIR=%APP_DIR%bin"
set "DATA_DIR=%APP_DIR%data"
set "LOCAL_STATE=%DATA_DIR%\Local State"
set "ORIGIN_EXE=%BIN_DIR%\brave.exe"

:: Check if already installed
if exist "%ORIGIN_EXE%" (
    echo [O] Brave Origin is already downloaded.
    set "VERSION=unknown"
    for /f "usebackq tokens=*" %%a in (`powershell -NoProfile -Command "try { (Get-Item '%ORIGIN_EXE%').VersionInfo.FileVersion } catch { 'unknown' }" 2^>nul`) do set "VERSION=%%a"
    goto :apply
)

:: Detect latest version
echo [.] Checking for the latest Brave Origin...
set "VERSION=1.91.175"
for /f "usebackq tokens=*" %%a in (`powershell -NoProfile -Command "try { $r = Invoke-WebRequest 'https://api.github.com/repos/brave/brave-browser/releases/latest' -UseBasicParsing -TimeoutSec 10 ^| ConvertFrom-Json; ($r.tag_name -replace '^v','') } catch { '' }" 2^>nul`) do if not "%%a"=="" set "VERSION=%%a"
echo [V] Latest version: v%VERSION%

:: Download
set "ZIP_URL=https://github.com/brave/brave-browser/releases/download/v%VERSION%/brave-origin-v%VERSION%-win32-x64.zip"
set "ZIP_FILE=%APP_DIR%brave-origin-v%VERSION%.zip"

echo [~] Downloading Brave Origin v%VERSION% (150 MB)...
echo     This may take a minute depending on your internet speed.
powershell -NoProfile -Command "try { $wc = New-Object System.Net.WebClient; Write-Host 'Downloading...'; $wc.DownloadFile('%ZIP_URL%', '%ZIP_FILE%'); Write-Host 'Done' } catch { Write-Host 'ERROR: ' + $_.Exception.Message; exit 1 }"
if errorlevel 1 (
    echo [!] Download failed. Check your internet connection.
    echo     Alternative: Download manually from:
    echo     https://github.com/brave/brave-browser/releases
    pause
    exit /b 1
)
echo [O] Download complete!

:: Extract
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
echo [.] Extracting...
powershell -NoProfile -Command "try { Expand-Archive -LiteralPath '%ZIP_FILE%' -DestinationPath '%BIN_DIR%' -Force; Write-Host 'Done' } catch { Write-Host 'ERROR: ' + $_.Exception.Message; exit 1 }"
if errorlevel 1 (
    echo [!] Extraction failed.
    pause
    exit /b 1
)
del "%ZIP_FILE%" 2>nul
echo [O] Extracted successfully!

:apply
:: Apply bypass
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%LOCAL_STATE%" (
    echo [.] Applying free activation...
    > "%LOCAL_STATE%" (
        echo {"brave":{"origin":{"purchase_validated":true}},"skus":{"state":{"67":"{\"credentials\":{\"items\":{\"6\":\"7\"}}}"}}}
    )
    echo [O] Activation applied successfully!
) else (
    echo [O] Activation already in place.
)

:: Create desktop shortcut
set "SHORTCUT=%USERPROFILE%\Desktop\Brave Origin (Free).lnk"
if not exist "%SHORTCUT%" (
    echo [.] Adding desktop shortcut...
    powershell -NoProfile -Command ^
        "$ws = New-Object -ComObject WScript.Shell; " ^
        "$sc = $ws.CreateShortcut('%SHORTCUT%'); " ^
        "$sc.TargetPath = '%APP_DIR%run.bat'; " ^
        "$sc.IconLocation = '%ORIGIN_EXE%, 0'; " ^
        "$sc.WorkingDirectory = '%APP_DIR%'; " ^
        "$sc.Description = 'Brave Origin - Free for Windows'; " ^
        "$sc.Save()" 2>nul
    if exist "%SHORTCUT%" ( echo [O] Shortcut created ) else ( echo [~] Shortcut skipped (run as normal user) )
) else ( echo [O] Shortcut already exists )

:: Done
echo.
echo  ============================================
echo     All done! You're ready to go.
echo  ============================================
echo.
echo  Brave Origin v%VERSION% is now free on your PC.
echo.
echo  - A shortcut was added to your desktop
echo  - Or run: run.bat
echo  - The browser is portable - copy the folder anywhere
echo.

:: Launch prompt
choice /C YN /M "Launch Brave Origin now"
if errorlevel 2 exit /b 0

:: Build flags
set "FLAGS=--user-data-dir="%DATA_DIR%""
set "FLAGS=%FLAGS% --no-first-run"
set "FLAGS=%FLAGS% --no-default-browser-check"
set "FLAGS=%FLAGS% --disable-brave-rewards"
set "FLAGS=%FLAGS% --disable-brave-wallet"
set "FLAGS=%FLAGS% --disable-brave-leo-ai"
set "FLAGS=%FLAGS% --disable-brave-news"
set "FLAGS=%FLAGS% --disable-brave-talk"
set "FLAGS=%FLAGS% --disable-brave-vpn"
set "FLAGS=%FLAGS% --disable-brave-tor"
set "FLAGS=%FLAGS% --disable-brave-update"
set "FLAGS=%FLAGS% --disable-background-networking"
set "FLAGS=%FLAGS% --disable-component-update"
set "FLAGS=%FLAGS% --disable-sync"
set "FLAGS=%FLAGS% --disable-features=BraveRewards,BraveWallet,BraveLeoAI,BraveNews,BraveTalk,BraveVPN,BraveTor,BraveP3A,BraveAds,Playlist,CryptoWallets,NativeBraveWallet,BraveNTPBrandedWallpaper,BraveTogether,BraveSpeedreader"

start "" "%ORIGIN_EXE%" %FLAGS%
exit /b 0
