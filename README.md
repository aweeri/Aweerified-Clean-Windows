# Instructions
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

## 🟥 Activate Windows:
1. Press the Win key, look up Powershell and open it with administrative privileges.
2. In Powershell, paste in the following: `irm https://get.activated.win | iex` then press enter.
3. In the window that pops up select `[1] HWID` and follow the instructions on screen.

## 🟥 Install Windows Store and WinGet:
This one is rather easy, simply follow the instructions from https://github.com/minihub/LTSC-Add-MicrosoftStore/

## 🟧 General UI productivity adjustments
### Make the Taskbar usable:
Search can be initiated from the Start Menu itself therefore the search bar serves zero purpose besides taking up space. We're going to hide it.
We're also going to left-align the taskbar and get rid of useless buttons.
1. Download [taskbar.reg](https://github.com/aweeri/Aweerified-Clean-Windows/blob/main/taskbar.reg).
2. Run the downloaded file and confirm when prompted.

### Fix the Context Menus:
Windows 11 introduced awful "pretty-ified" context menus that require more clicks than what's really needed. We're going to revert to how they normally work while also removing the useless delay. 
1. Download [basics.reg](https://github.com/aweeri/Aweerified-Clean-Windows/blob/main/taskbar.reg).
2. Run the downloaded file and confirm when prompted.

## 🟩 Install Always-On software to enhance the experience
### [NanaZIP](https://github.com/M2Team/NanaZip)
It's a 7-Zip derivative intended for the modern Windows experience.

🔽 To install it, run `winget install -e --id M2Team.NanaZip` in the Command Prompt.
### [WinEnter](https://github.com/aweeri/WinEnter)
This tiny utility hooks your keyboard to open CMD or Powershell whenever you press `Win+Enter`. It sits quietly in the system tray.

🔽 To install it, download `winenter.exe` from the repository, open the Windows Run dialog (press `Win + R`), type `shell:startup`, and move the downloaded executable into that folder.
### [FFpresets](https://github.com/aweeri/FFpresets)
An ULTRA-lightweight video conversion tool built directly into your Windows right-click context menu. It lets you run ffmpeg commands that you most often need without having to mess with filenames and remembering the exact arguments.

🔽 To install it, run the installation script included in the [zip](https://github.com/aweeri/FFpresets/archive/refs/heads/main.zip).
### [Wcap](https://github.com/mmozeiko/wcap)
A small and efficient screen recording utility.

🔽 To install it, download `wcap.exe` from the repository and place it in a directory of choice (For example `C:\Tools`), then press `Win+R` and type `shell:startup`, then throw a shortcut to `wcap.exe` into the startup directory.

---
# Remaining steps are a Work In Progress.
