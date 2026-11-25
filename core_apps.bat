@echo off
title LTSC Essential Apps Installer

:: Request administrator privileges to run protected commands
net session >nul 2>&1
if not %errorLevel% == 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo Installing LTSC Essential Apps and Media Extensions via WinGet...
echo Note: Frameworks (AppRuntime, UI.Xaml, VCLibs, .NET Native) are resolved automatically.
echo.

:: Microsoft Applications
:: 9WZDNCRFHVN5 - Windows Calculator
:: 9WZDNCRFJBBG - Windows Camera
:: 9WZDNCRFJ3PR - Windows Alarms & Clock
:: 9MSMLRH6LZF3 - Windows Notepad
:: 9WZDNCRFJBH4 - Microsoft Photos
:: 9WZDNCRFJ3PT - Windows Media Player (the modern app, package Microsoft.ZuneMusic)
:: 9MZ95KL8MR0L - Snipping Tool (ScreenSketch)
:: 9N0DX20HK701 - Windows Terminal

:: Media Extensions
:: 9MVZQVXABDWM - AV1 Video Extension
:: 9PMMSR1CGPWG - HEIF Image Extensions
:: 9NCTDW2W1BH8 - Raw Image Extension
:: 9N4D0MV1FCCW - VP9 Video Extensions
:: 9N5TDP8VCMHS - Web Media Extensions
:: 9PG2DK419DRG - Webp Image Extensions

set "APPS=9WZDNCRFHVN5 9WZDNCRFJBBG 9WZDNCRFJ3PR 9MSMLRH6LZF3 9WZDNCRFJBH4 9WZDNCRFJ3PT 9MZ95KL8MR0L 9N0DX20HK701 9MVZQVXABDWM 9PMMSR1CGPWG 9NCTDW2W1BH8 9N4D0MV1FCCW 9N5TDP8VCMHS 9PG2DK419DRG"

for %%A in (%APPS%) do (
    echo ---------------------------------------------------
    echo Installing component ID: %%A
    winget install --id %%A --exact --source msstore --accept-package-agreements --accept-source-agreements
)

echo ---------------------------------------------------
echo All specified applications have been processed.
echo ---------------------------------------------------
echo Pointing common image and video files at Photos and Media Player...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/defaults.ps1 | iex"

echo ---------------------------------------------------
echo Taking ownership and disabling legacy LTSC applications...

:: Only remove the legacy binaries when the Store version actually installed,
:: so a failed download cannot leave the machine without a calculator or notepad.
powershell -NoProfile -Command "if (Get-AppxPackage Microsoft.WindowsCalculator) { exit 0 } else { exit 1 }"
if %errorLevel% == 0 (
    takeown /f C:\Windows\System32\calc.exe /a >nul 2>&1
    icacls C:\Windows\System32\calc.exe /grant Administrators:F >nul
    ren C:\Windows\System32\calc.exe calc.exe.bak
    takeown /f C:\Windows\System32\win32calc.exe /a >nul 2>&1
    icacls C:\Windows\System32\win32calc.exe /grant Administrators:F >nul
    ren C:\Windows\System32\win32calc.exe win32calc.exe.bak
    del /q /f "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Accessories\Calculator.lnk"
) else (
    echo Skipping legacy Calculator removal - the Store version is not installed.
)

powershell -NoProfile -Command "if (Get-AppxPackage Microsoft.WindowsNotepad) { exit 0 } else { exit 1 }"
if %errorLevel% == 0 (
    takeown /f C:\Windows\System32\notepad.exe /a >nul 2>&1
    icacls C:\Windows\System32\notepad.exe /grant Administrators:F >nul
    ren C:\Windows\System32\notepad.exe notepad.exe.bak
) else (
    echo Skipping legacy Notepad removal - the Store version is not installed.
)

echo Legacy applications processed.
