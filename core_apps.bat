@echo off
echo 1. Initializing WinGet...
powershell -Command "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"

echo.
echo 2. Bypassing Microsoft Store certificate pinning...
winget settings --enable BypassCertificatePinningForMicrosoftStore

echo.
echo 3. Updating AppInstaller...
winget upgrade Microsoft.AppInstaller --source msstore --accept-source-agreements --accept-package-agreements

echo.
echo 4. Installing Core Apps...
winget install Microsoft.WindowsNotepad --source msstore --accept-package-agreements --accept-source-agreements
winget install Microsoft.Paint --source msstore --accept-package-agreements --accept-source-agreements
winget install Microsoft.WindowsCalculator --source msstore --accept-package-agreements --accept-source-agreements
winget install Microsoft.WindowsCamera --source msstore --accept-package-agreements --accept-source-agreements
winget install Microsoft.WindowsPhotos --source msstore --accept-package-agreements --accept-source-agreements
winget install Microsoft.ScreenSketch --source msstore --accept-package-agreements --accept-source-agreements
winget install Microsoft.WindowsTerminal --source msstore --accept-package-agreements --accept-source-agreements

echo.
echo 5. Installing Media Extensions...
winget install 9MVZQVXJBQ9V --source msstore --accept-package-agreements --accept-source-agreements
winget install 9PMMSR1CGPWG --source msstore --accept-package-agreements --accept-source-agreements
winget install 9NCTDW2W1BH8 --source msstore --accept-package-agreements --accept-source-agreements
winget install 9N4D0MSV0403 --source msstore --accept-package-agreements --accept-source-agreements
winget install 9N5TDP8VCMHS --source msstore --accept-package-agreements --accept-source-agreements
winget install 9PG2DK419DRG --source msstore --accept-package-agreements --accept-source-agreements

echo.
echo 6. Restoring security pinning...
winget settings --disable BypassCertificatePinningForMicrosoftStore

echo.
echo ==========================================
echo Installation Complete!
echo ==========================================
pause
