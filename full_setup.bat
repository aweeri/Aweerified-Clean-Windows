<# :
@echo off
title Aweerified Windows Setup
:: Automatically request Administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
echo Running Aweerified Setup...
:: Execute the embedded PowerShell script below
powershell -NoProfile -ExecutionPolicy Bypass -Command "$script = Get-Content '%~f0' -Raw; Invoke-Expression $script.Substring($script.IndexOf('#' + '>') + 2)"
pause
exit /b
#>

# 1. Activate Windows (Unattended HWID)
Write-Host "Activating Windows..." -ForegroundColor Cyan
iex "& { $(irm https://get.activated.win) } /HWID"

# 2. Install Windows Store & WinGet
Write-Host "Installing Windows Store..." -ForegroundColor Cyan
$TempDir = "$env:TEMP\WinSetup"
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

# wsreset.exe -i is a native command that pulls the Microsoft Store directly from Windows Update
Start-Process -FilePath "wsreset.exe" -ArgumentList "-i" -WindowStyle Hidden

Write-Host "Waiting for Store installation to complete (this may take a few minutes)..." -ForegroundColor Cyan
while (!(Get-AppxPackage -Name "*Microsoft.WindowsStore*")) {
    Start-Sleep -Seconds 5
}

Write-Host "Bootstrapping WinGet..." -ForegroundColor Cyan
$ProgressPreference = 'SilentlyContinue'
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Repair-WinGetPackageManager -AllUsers

# 3. Restore Core Apps
Write-Host "Installing Core Apps..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/core_apps.bat" -OutFile "$TempDir\core_apps.bat"
Start-Process -FilePath "$TempDir\core_apps.bat" -Wait

# 4. Apply UI Registry Tweaks
Write-Host "Applying Registry Tweaks..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/taskbar.reg" -OutFile "$TempDir\taskbar.reg"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/basics.reg" -OutFile "$TempDir\basics.reg"
reg import "$TempDir\taskbar.reg"
reg import "$TempDir\basics.reg"

# Refresh Environment Variables so WinGet is recognized immediately
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# 5. Install Software via WinGet
Write-Host "Installing NanaZip..." -ForegroundColor Cyan
winget install M2Team.NanaZip --accept-package-agreements --accept-source-agreements --silent

# 6. Deploy Custom Utilities to Startup
Write-Host "Deploying Utilities..." -ForegroundColor Cyan
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/Resources/winenter.exe" -OutFile "$StartupPath\winenter.exe"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/Resources/wcap-x64.exe" -OutFile "$StartupPath\wcap.exe"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/Resources/FFpresets.zip" -OutFile "$TempDir\ffpresets.zip"
Expand-Archive -Path "$TempDir\ffpresets.zip" -DestinationPath "$TempDir\ffpresets" -Force
$InstallBat = Get-ChildItem -Path "$TempDir\ffpresets" -Filter "install.bat" -Recurse | Select-Object -First 1
Start-Process -FilePath $InstallBat.FullName -Wait

# 7. Clean up and Restart Explorer
Write-Host "Cleaning up..." -ForegroundColor Cyan
Remove-Item -Path $TempDir -Recurse -Force
Stop-Process -Name explorer -Force

Write-Host "Setup Complete. You can close this window and run Windows Update manually." -ForegroundColor Green