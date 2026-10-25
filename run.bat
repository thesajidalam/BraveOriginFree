@echo off
setlocal enabledelayedexpansion
title Brave Origin Free
color 0B

set "APP_DIR=%~dp0"
set "BIN_DIR=%APP_DIR%bin"
set "DATA_DIR=%APP_DIR%data"
set "ORIGIN_EXE=%BIN_DIR%\brave.exe"
set "LOCAL_STATE=%DATA_DIR%\Local State"

if not exist "%ORIGIN_EXE%" (
    echo.
    echo [!] Brave Origin not installed.
    echo [~] Launching installer in 2 seconds...
    echo.
    timeout /t 2 /nobreak >nul
    call "%APP_DIR%install.bat"
    exit /b %ERRORLEVEL%
)

if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%LOCAL_STATE%" (
    echo {"brave":{"origin":{"purchase_validated":true}},"skus":{"state":{"67":"{\"credentials\":{\"items\":{\"6\":\"7\"}}}"}}} > "%LOCAL_STATE%"
)

REM Launch immediately - no delay
set "FLAGS=--user-data-dir="%DATA_DIR%" --no-first-run --no-default-browser-check --disable-brave-rewards --disable-brave-wallet --disable-brave-leo-ai --disable-brave-news --disable-brave-talk --disable-brave-vpn --disable-brave-tor --disable-brave-update --disable-background-networking --disable-component-update --disable-sync --disable-features=BraveRewards,BraveWallet,BraveLeoAI,BraveNews,BraveTalk,BraveVPN,BraveTor,BraveP3A,BraveAds,Playlist,CryptoWallets,NativeBraveWallet,BraveNTPBrandedWallpaper,BraveTogether,BraveSpeedreader"

start "" "%ORIGIN_EXE%" %FLAGS%
exit /b 0
