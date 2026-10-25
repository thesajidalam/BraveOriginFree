@echo off
title Brave Origin Free - Launcher
color 0B

set "APP_DIR=%~dp0"
set "BIN_DIR=%APP_DIR%bin"
set "DATA_DIR=%APP_DIR%data"
set "ORIGIN_EXE=%BIN_DIR%\brave.exe"
set "LOCAL_STATE=%DATA_DIR%\Local State"

if not exist "%ORIGIN_EXE%" (
    echo.
    echo [!] Brave Origin not found. Starting installer...
    echo.
    timeout /t 2 /nobreak >nul
    call "%APP_DIR%install.bat"
    exit /b %ERRORLEVEL%
)

if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%LOCAL_STATE%" (
    > "%LOCAL_STATE%" (
        echo {"brave":{"origin":{"purchase_validated":true}},"skus":{"state":{"67":"{\"credentials\":{\"items\":{\"6\":\"7\"}}}"}}}
    )
)

REM Fast launch without menu
set "FLAGS=--user-data-dir="%DATA_DIR%" --no-first-run --no-default-browser-check --disable-brave-rewards --disable-brave-wallet --disable-brave-leo-ai --disable-brave-news --disable-brave-talk --disable-brave-vpn --disable-brave-tor --disable-brave-update --disable-background-networking --disable-component-update --disable-sync"

start "" "%ORIGIN_EXE%" %FLAGS%
exit /b 0
