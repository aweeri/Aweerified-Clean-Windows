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

# 0. Select Software GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$AvailableApps = @(
    "M2Team.NanaZip", "Mozilla.Firefox", "Discord.Discord",
    "Microsoft.PowerToys", "voidtools.Everything", "Notepad++.Notepad++",
    "qBittorrent.qBittorrent", "Git.Git", "Microsoft.VisualStudioCode",
    "Python.Python.3.12", "Gyan.FFmpeg", "VideoLAN.VLC", "KiCad.KiCad",
    "Arduino.ArduinoIDE", "ShareX.ShareX", "TimKosse.FileZilla",
    "Mozilla.Thunderbird", "Spotify.Spotify", "Valve.Steam", "Google.Chrome",
    "Custom: winenter", "Custom: wcap", "Custom: FFpresets"
)

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Select Software to Install"
$Form.Size = New-Object System.Drawing.Size(300, 420)
$Form.StartPosition = "CenterScreen"
$Form.Topmost = $true

$CheckedListBox = New-Object System.Windows.Forms.CheckedListBox
$CheckedListBox.Size = New-Object System.Drawing.Size(260, 310)
$CheckedListBox.Location = New-Object System.Drawing.Point(10, 10)
$CheckedListBox.CheckOnClick = $true
foreach ($App in $AvailableApps) {
    $CheckedListBox.Items.Add($App, $false) | Out-Null
}
$Form.Controls.Add($CheckedListBox)

$ButtonOK = New-Object System.Windows.Forms.Button
$ButtonOK.Location = New-Object System.Drawing.Point(100, 335)
$ButtonOK.Size = New-Object System.Drawing.Size(80, 30)
$ButtonOK.Text = "OK"
$ButtonOK.Add_Click({ $Form.Close() })
$Form.Controls.Add($ButtonOK)

$Form.ShowDialog() | Out-Null

$SelectedApps = @()
foreach ($Item in $CheckedListBox.CheckedItems) {
    $SelectedApps += $Item
}

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
Write-Host "Installing Software..." -ForegroundColor Cyan
if ($SelectedApps.Count -gt 0) {
    foreach ($App in $SelectedApps) {
        if ($App -notmatch "^Custom:") {
            Write-Host "Installing $App..." -ForegroundColor Gray
            winget install $App --accept-package-agreements --accept-source-agreements --silent
        }
    }
} else {
    Write-Host "No software selected for installation. Skipping." -ForegroundColor Yellow
}

# 6. Deploy Custom Utilities to Startup
Write-Host "Deploying Utilities..." -ForegroundColor Cyan
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

if ($SelectedApps -contains "Custom: winenter") {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/Resources/winenter.exe" -OutFile "$StartupPath\winenter.exe"
}

if ($SelectedApps -contains "Custom: wcap") {
    $ToolsPath = "C:\Tools"
    if (-not (Test-Path -Path $ToolsPath)) {
        New-Item -ItemType Directory -Force -Path $ToolsPath | Out-Null
    }
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/Resources/wcap-x64.exe" -OutFile "$ToolsPath\wcap.exe"

    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$StartupPath\wcap.lnk")
    $Shortcut.TargetPath = "$ToolsPath\wcap.exe"
    $Shortcut.WorkingDirectory = $ToolsPath
    $Shortcut.Save()
}

if ($SelectedApps -contains "Custom: FFpresets") {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/Resources/FFpresets.zip" -OutFile "$TempDir\ffpresets.zip"
    Expand-Archive -Path "$TempDir\ffpresets.zip" -DestinationPath "$TempDir\ffpresets" -Force
    $InstallBat = Get-ChildItem -Path "$TempDir\ffpresets" -Filter "install.bat" -Recurse | Select-Object -First 1
    Start-Process -FilePath $InstallBat.FullName -Wait
}

# 7. Clean up and Restart Explorer
Write-Host "Cleaning up..." -ForegroundColor Cyan
Remove-Item -Path $TempDir -Recurse -Force
Stop-Process -Name explorer -Force

Write-Host "Setup Complete. You can close this window and run Windows Update manually." -ForegroundColor Green