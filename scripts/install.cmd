@echo off
setlocal

where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
  exit /b %ERRORLEVEL%
)

where powershell >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
  exit /b %ERRORLEVEL%
)

echo PowerShell is required to run this installer on Windows.
exit /b 1
