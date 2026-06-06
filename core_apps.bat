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
:: 9MZ95KL8MR0L - Snipping Tool (ScreenSketch)
:: 9N0DX20HK701 - Windows Terminal

:: Media Extensions
:: 9MVZQVXABDWM - AV1 Video Extension
:: 9PMMSR1CGPWG - HEIF Image Extensions
:: 9NCTDW2W1BH8 - Raw Image Extension
:: 9N4D0MV1FCCW - VP9 Video Extensions
:: 9N5TDP8VCMHS - Web Media Extensions
:: 9PG2DK419DRG - Webp Image Extensions

set "APPS=9WZDNCRFHVN5 9WZDNCRFJBBG 9WZDNCRFJ3PR 9MSMLRH6LZF3 9WZDNCRFJBH4 9MZ95KL8MR0L 9N0DX20HK701 9MVZQVXABDWM 9PMMSR1CGPWG 9NCTDW2W1BH8 9N4D0MV1FCCW 9N5TDP8VCMHS 9PG2DK419DRG"

for %%A in (%APPS%) do (
    echo ---------------------------------------------------
    echo Installing component ID: %%A
    winget install --id %%A --exact --source msstore --accept-package-agreements --accept-source-agreements
)

echo ---------------------------------------------------
echo All specified applications have been processed.
echo ---------------------------------------------------
echo Taking ownership and disabling legacy LTSC applications...

:: Disable Legacy Calculator
takeown /f C:\Windows\System32\calc.exe /a
icacls C:\Windows\System32\calc.exe /grant Administrators:F
ren C:\Windows\System32\calc.exe calc.exe.bak
takeown /f C:\Windows\System32\win32calc.exe /a
icacls C:\Windows\System32\win32calc.exe /grant Administrators:F
ren C:\Windows\System32\win32calc.exe win32calc.exe.bak
del /q /f "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Accessories\Calculator.lnk"

:: Disable Legacy Notepad
takeown /f C:\Windows\System32\notepad.exe /a
icacls C:\Windows\System32\notepad.exe /grant Administrators:F
ren C:\Windows\System32\notepad.exe notepad.exe.bak

echo Legacy applications disabled.
pause
