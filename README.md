# Instructions
## Download a Windows 11 LTSC ISO from a source such as:
- https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-iot-enterprise-ltsc
- windows-11-iot-enterprise-ltsc-2024 from archive.org

## Go through the normal installation steps:
Using local login/password authorization is preferred. This will help avoid ugly `[Name] [Surname]` file paths being created.
> [!CAUTION]
> If you're struggling to find a way to use non-email login, look for a mysteriously named `domain join` button.


## Update Windows:
Press `Win+R` and enter `ms-settings:windowsupdate`, then check and confirm any available updates. 

## Activate Windows:
1. Press the Win key, look up Powershell and open it with administrative privileges.
2. In Powershell, paste in the following: `irm https://get.activated.win | iex` then press enter.
3. In the window that pops up select `[1] HWID` and follow the instructions on screen.
