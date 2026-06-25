@echo off
setlocal enabledelayedexpansion
title Brave Origin Free
color 0B

set "APP_DIR=%~dp0"
set "BIN_DIR=%APP_DIR%bin"
set "DATA_DIR=%APP_DIR%data"
set "ORIGIN_EXE=%BIN_DIR%\brave.exe"
set "LOCAL_STATE=%DATA_DIR%\Local State"

:: Check if installed
if not exist "%ORIGIN_EXE%" (
    echo.
    echo  Brave Origin is not downloaded yet.
    echo  Run install.bat first - it does everything automatically.
    echo.
    pause
    exit /b 1
)

:: Apply bypass if needed
if not exist "%LOCAL_STATE%" (
    if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
    > "%LOCAL_STATE%" (
        echo {"brave":{"origin":{"purchase_validated":true}},"skus":{"state":{"67":"{\"credentials\":{\"items\":{\"6\":\"7\"}}}"}}}
    )
)

:: Build flags (mirrors Linux Origin compile-time settings)
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

:: Detect version
for /f "usebackq tokens=*" %%a in (`powershell -NoProfile -Command "try { (Get-Item '%ORIGIN_EXE%').VersionInfo.FileVersion } catch { '?' }" 2^>nul`) do set "VERSION=%%a"

cls
echo.
echo  ============================================
echo     Brave Origin v%VERSION% - Free for Windows
echo     by Sajid Alam
echo  ============================================
echo.
echo  [Active] Purchase bypass engaged
echo.
echo  Brave Shields: ON    Passwords: ON
echo  Rewards: OFF         Wallet: OFF
echo  Leo AI: OFF          News: OFF
echo  VPN: OFF             Tor: OFF
echo.
echo  Close this window when you're done, or
echo  press Ctrl+Shift+Q to quit the browser.
echo.

start "" "%ORIGIN_EXE%" %FLAGS%
exit /b 0
