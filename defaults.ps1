# Points common image/video/audio extensions at Photos and Media Player.
# Windows 11 hash-protects the per-user UserChoice keys, so they are cleared
# rather than written, and HKCU\Software\Classes\<ext> is pointed at the app's
# AppX ProgId instead. That is what makes double-clicking a file open it.

$ErrorActionPreference = 'Continue'

$PhotosPfn  = 'Microsoft.Windows.Photos_8wekyb3d8bbwe'
$MediaPfn   = 'Microsoft.ZuneMusic_8wekyb3d8bbwe'
$NotepadPfn = 'Microsoft.WindowsNotepad_8wekyb3d8bbwe'

$Map = [ordered]@{
    '.jpg'  = $PhotosPfn; '.jpeg' = $PhotosPfn; '.png'  = $PhotosPfn
    '.gif'  = $PhotosPfn; '.bmp'  = $PhotosPfn; '.tif'  = $PhotosPfn
    '.tiff' = $PhotosPfn; '.heic' = $PhotosPfn; '.heif' = $PhotosPfn
    '.webp' = $PhotosPfn; '.avif' = $PhotosPfn
    '.mp4'  = $MediaPfn;  '.m4v'  = $MediaPfn;  '.mov'  = $MediaPfn
    '.avi'  = $MediaPfn;  '.mkv'  = $MediaPfn;  '.webm' = $MediaPfn
    '.wmv'  = $MediaPfn;  '.mp3'  = $MediaPfn;  '.m4a'  = $MediaPfn
    '.aac'  = $MediaPfn;  '.flac' = $MediaPfn;  '.wav'  = $MediaPfn
    '.ogg'  = $MediaPfn;  '.wma'  = $MediaPfn
    '.txt'  = $NotepadPfn; '.log' = $NotepadPfn; '.ini' = $NotepadPfn
}

# AppX ProgIds carry their package family name in the AppUserModelID, so a
# ProgId belongs to an app when that value starts with the family name.
function Test-ProgIdBelongsTo {
    param([string]$ProgId, [string]$Pfn)
    $key = "Registry::HKEY_CLASSES_ROOT\$ProgId\Application"
    $aumid = (Get-ItemProperty -LiteralPath $key -Name 'AppUserModelID' -ErrorAction SilentlyContinue).AppUserModelID
    if (-not $aumid) { return $false }
    return $aumid.StartsWith($Pfn, [StringComparison]::OrdinalIgnoreCase)
}

# The extension itself knows which handlers are registered for it.
function Get-ProgIdFromExtension {
    param([string]$Extension, [string]$Pfn)
    $owp = "Registry::HKEY_CLASSES_ROOT\$Extension\OpenWithProgids"
    if (-not (Test-Path -LiteralPath $owp)) { return $null }
    foreach ($name in (Get-Item -LiteralPath $owp).GetValueNames()) {
        if ($name -notlike 'AppX*') { continue }
        if (Test-ProgIdBelongsTo -ProgId $name -Pfn $Pfn) { return $name }
    }
    return $null
}

# Fallback: walk every AppX ProgId registered machine-wide.
function Get-AppxProgIds {
    $found = @{}
    $root = [Microsoft.Win32.Registry]::ClassesRoot
    foreach ($name in $root.GetSubKeyNames()) {
        if ($name -notlike 'AppX*') { continue }
        $appKey = $root.OpenSubKey("$name\Application")
        if ($null -eq $appKey) { continue }
        $aumid = $appKey.GetValue('AppUserModelID')
        $appKey.Close()
        if (-not $aumid) { continue }
        $pfn = ($aumid -split '!')[0]
        if (-not $found.ContainsKey($pfn)) { $found[$pfn] = $name }
    }
    return $found
}

Write-Host 'Registering default apps for media files...' -ForegroundColor Cyan

$fallback = $null
$missing = @()
foreach ($pfn in @($PhotosPfn, $MediaPfn, $NotepadPfn)) {
    if (-not (Get-AppxPackage -Name ($pfn -split '_')[0] -ErrorAction SilentlyContinue)) {
        $missing += $pfn
        Write-Host "  $pfn is not installed, skipping its extensions." -ForegroundColor Yellow
    }
}

$set = 0
$skipped = 0
foreach ($ext in $Map.Keys) {
    $pfn = $Map[$ext]
    if ($missing -contains $pfn) { $skipped++; continue }

    $progId = Get-ProgIdFromExtension -Extension $ext -Pfn $pfn
    if (-not $progId) {
        if ($null -eq $fallback) { $fallback = Get-AppxProgIds }
        if ($fallback.ContainsKey($pfn)) { $progId = $fallback[$pfn] }
    }
    if (-not $progId) {
        Write-Host "  no handler found for $ext, leaving it alone." -ForegroundColor Yellow
        $skipped++
        continue
    }

    $userChoice = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$ext\UserChoice"
    if (Test-Path -LiteralPath $userChoice) {
        Remove-Item -LiteralPath $userChoice -Recurse -Force -ErrorAction SilentlyContinue
    }

    $extKey = "HKCU:\Software\Classes\$ext"
    try {
        if (-not (Test-Path -LiteralPath $extKey)) {
            New-Item -Path $extKey -Force -ErrorAction Stop | Out-Null
        }
        Set-ItemProperty -LiteralPath $extKey -Name '(default)' -Value $progId -ErrorAction Stop
        $set++
    } catch {
        Write-Host "  could not set $ext : $($_.Exception.Message)" -ForegroundColor Yellow
        $skipped++
    }
}

Write-Host "Done: $set extensions now open with Photos / Media Player, $skipped skipped." -ForegroundColor Green
if ($set -lt $Map.Count) {
    Write-Host 'Anything skipped can be set by hand once in ms-settings:defaultapps.' -ForegroundColor Gray
}
