# Why?
I've never exactly enjoyed the usual consumer Windows experience. I tred to use Debian with KDE Plasma and Arch with Hyprland on my main desktop machine, but my engineering workflows are essentially entirely incompatible with Linux.
This is a step-by-step writeup on how to make windows feel professional, complete, bloat-free, and most importantly, __intentional__.

# Color coding
I've organized the importance of each step as follows:

🟥 - Critical. Skipping these steps will ruin your experience and may make following further steps impossible.

🟧 - Highly advised. If you don't want to do these, you're free to, but I'll consider you weird.

🟩 - Very useful; You are however absolutely free to skip these if you want, I don't care.

<br>

---

# 🤖 Automatic Installation
## 🟥 Install Windows 11 LTSC
This version of Windows is a stripped-down, stable version built for professional, "set-and-forget" hardware (like ATMs or medical devices). It lacks bloatware and forced feature updates.
### Download a Windows 11 LTSC ISO:
- Use a search engine to look for `windows-11-iot-enterprise-ltsc-2024 site:archive.org`

### Go through the normal installation steps:
Using local login/password authorization is preferred. This will help avoid ugly `[Name] [Surname]` file paths being created.
> [!CAUTION]
> If you're struggling to find a way to use non-email login, look for a mysteriously named `domain join` button.

## 🟥 Run the automated script in Powershell
This will go through all of the steps described in the [Manual Installation Steps](https://github.com/aweeri/Aweerified-Clean-Windows#manual-installation-steps) section
```powershell
iwr -useb [https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/full_setup.bat](https://raw.githubusercontent.com/aweeri/Aweerified-Clean-Windows/main/full_setup.bat) `
    -outfile $env:TEMP\aweerified.bat; & $env:TEMP\aweerified.bat
```
## 🟥 Update Windows:
Press `Win+R` and enter `ms-settings:windowsupdate`, then check and confirm any available updates. 

## 🟥 Done!
Enjoy your Windows!

<br>

---

# 👷 Manual Installation Steps
## 🟥 Install Windows 11 LTSC
This version of Windows is a stripped-down, stable version built for professional, "set-and-forget" hardware (like ATMs or medical devices). It lacks bloatware and forced feature updates.
### Download a Windows 11 LTSC ISO:
- Use a search engine to look for `windows-11-iot-enterprise-ltsc-2024 site:archive.org`

### Go through the normal installation steps:
Using local login/password authorization is preferred. This will help avoid ugly `[Name] [Surname]` file paths being created.
> [!CAUTION]
> If you're struggling to find a way to use non-email login, look for a mysteriously named `domain join` button.


## 🟥 Update Windows:
Press `Win+R` and enter `ms-settings:windowsupdate`, then check and confirm any available updates. 

## 🟧 Activate Windows:
1. Press the Win key, look up Powershell and open it with administrative privileges.
2. In Powershell, paste in the following: `irm https://get.activated.win | iex` then press enter.
3. In the window that pops up select `[1] HWID` and follow the instructions on screen.

## 🟥 Install Windows Store and WinGet:
This one is rather easy, simply follow the instructions from https://github.com/minihub/LTSC-Add-MicrosoftStore/

## 🟥 Bring Back the essentials, normally not present on LTSC
Download and run [core_apps.bat](https://github.com/aweeri/Aweerified-Clean-Windows/blob/main/core_apps.bat); it will download and update the following:

| Apps | Extensions |
| :--- | :--- |
| Windows Calculator | AV1 Video Extension |
| Windows Camera | HEIF Image Extensions |
| Windows Alarms & Clock | Raw Image Extension |
| Windows Notepad | VP9 Video Extensions |
| Microsoft Photos | Web Media Extensions |
| Snipping Tool | Webp Image Extensions |
| Windows Terminal | |

## 🟧 General UI productivity adjustments
### Make the Taskbar usable:
<img width="391" height="48" alt="image (2)" src="https://github.com/user-attachments/assets/f9b62d2a-e7c9-4ea8-b3b8-b8e63cec5123" />

Search can be initiated from the Start Menu itself therefore the search bar serves zero purpose besides taking up space. We're going to hide it.
We're also going to left-align the taskbar and get rid of useless buttons.
1. Download [taskbar.reg](https://github.com/aweeri/Aweerified-Clean-Windows/blob/main/taskbar.reg).
2. Run the downloaded file and confirm when prompted.

### Fix the Context Menus:
Windows 11 introduced awful "pretty-ified" context menus that require more clicks than what's really needed. We're going to revert to how they normally work while also removing the useless delay. 
1. Download [basics.reg](https://github.com/aweeri/Aweerified-Clean-Windows/blob/main/taskbar.reg).
2. Run the downloaded file and confirm when prompted.

## 🟩 Install additional software to enhance the experience

| Software | Description | Installation |
| :--- | :--- | :--- |
| **[NanaZIP](https://github.com/M2Team/NanaZip)** | It's a 7-Zip derivative intended for the modern Windows experience. | Run `winget install M2Team.NanaZip --source winget` in the Command Prompt. |
| **[WinEnter](https://github.com/aweeri/WinEnter)** | This tiny utility hooks your keyboard to open CMD or Powershell whenever you press `Win+Enter`. It sits quietly in the system tray. | Download `winenter.exe` from the repository, press `Win + R`, type `shell:startup`, and move the executable into that folder. |
| **[FFpresets](https://github.com/aweeri/FFpresets)** | An ULTRA-lightweight video conversion tool built directly into your Windows right-click context menu. It lets you run ffmpeg commands that you most often need without having to mess with filenames or arguments. | Run the installation script included in the [zip](https://github.com/aweeri/FFpresets/archive/refs/heads/main.zip). |
| **[Wcap](https://github.com/mmozeiko/wcap)** | A small and efficient screen recording utility. | Download `wcap.exe` to a directory of choice (e.g., `C:\Tools`), press `Win+R` and type `shell:startup`, then throw a shortcut to `wcap.exe` into the startup directory. |

## 🟥 Done!
Enjoy your Windows!
