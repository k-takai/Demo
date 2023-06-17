winget --version
winget --info

winget features
winget settings
# Modify settings.json and enable configuration feature

winget features

[System.Environment]::GetEnvironmentVariable("EVENT_NAME")
# Check Developer Mode
# Check All Apps
winget list
Get-LocalUser
Get-LocalGroupMember Administrators

Set-Location ~
Set-Location .\Desktop
#winget configuration show .\configuration.dsc.yaml
winget configuration .\configuration.dsc.yaml

winget list
Get-LocalUser
Get-LocalGroupMember Administrators

[System.Environment]::SetEnvironmentVariable("ACCEPT_WINGET_CONFIGURATION", "0", "Machine")

# Check Developer Mode
# Check All Apps

### New PS Session
[System.Environment]::GetEnvironmentVariable("EVENT_NAME")

Set-Location ~
Set-Location .\Desktop
winget configuration .\configuration.dsc.yaml
