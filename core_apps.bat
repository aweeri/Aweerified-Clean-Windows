@echo off
title LTSC Essential Apps Installer
echo Installing LTSC Essential Apps and Media Extensions via WinGet...
echo Note: Frameworks (AppRuntime, UI.Xaml, VCLibs, .NET Native) are resolved automatically.
echo.

:: Microsoft Applications
:: 9WZDNCRFHVN5 - Windows Calculator
:: 9WZDNCRFJBBG - Windows Camera
:: 9MSMLRH6LZF3 - Windows Notepad
:: 9PCFS5B6T72H - Paint
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

set "APPS=9WZDNCRFHVN5 9WZDNCRFJBBG 9MSMLRH6LZF3 9PCFS5B6T72H 9WZDNCRFJBH4 9MZ95KL8MR0L 9N0DX20HK701 9MVZQVXABDWM 9PMMSR1CGPWG 9NCTDW2W1BH8 9N4D0MV1FCCW 9N5TDP8VCMHS 9PG2DK419DRG"

for %%A in (%APPS%) do (
    echo ---------------------------------------------------
    echo Installing component ID: %%A
    winget install --id %%A --exact --source msstore --accept-package-agreements --accept-source-agreements
)

echo ---------------------------------------------------
echo All specified applications have been processed.
pause
