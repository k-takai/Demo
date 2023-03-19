## Preparation : install PowerShell 7.3

$BasePath = "${env:USERPROFILE}\Documents\PowerShell"
if($PSScriptRoot -ne $null -and (Test-Path $PSScriptRoot -ErrorAction SilentlyContinue))
{
    Set-Location $PSScriptRoot
} elseif (Test-Path $BasePath -ErrorAction SilentlyContinue) {
    Set-Location $BasePath
}

Get-Module
Install-Module -Name GuestConfiguration
Install-Module -Name PSDesiredStateConfiguration -AllowPrerelease

Get-Module
Get-Module -ListAvailable | Where-Object { $_.Name -in @("GuestConfiguration","PSDesiredStateConfiguration") }

#Import-Module GuestConfiguration
#Import-Module PSDesiredStateConfiguration
#Get-Module

Get-ChildItem .\

. .\SCUGJWindowsBaseConfiguration.ps1
SCUGJWindowsBaseConfiguration
Get-ChildItem .\SCUGJWindowsBaseConfiguration\

New-GuestConfigurationPackage -Name SCUGJ34WindowsBaseConfig -Configuration .\SCUGJWindowsBaseConfiguration\SCUGJ34WindowsBaseConfig.mof -Type AuditAndSet -Force
Get-ChildItem .\

### Test configuration package
### Require administrator privilege

Get-GuestConfigurationPackageComplianceStatus -Path .\SCUGJ34WindowsBaseConfig.zip
# Get-GuestConfigurationPackageComplianceStatus -Path .\SCUGJ34WindowsBaseConfig.zip -Verbose

Get-ChildItem C:\
if (Test-Path C:\SCUGJ34-Demo.txt) {
    Get-Content C:\SCUGJ34-Demo.txt
} else {
    "Test-Path C:\SCUGJ34-Demo.txt : $(Test-Path C:\SCUGJ34-Demo.txt)"
}

Start-GuestConfigurationPackageRemediation -Path .\SCUGJ34WindowsBaseConfig.zip

Get-ChildItem C:\
if (Test-Path C:\SCUGJ34-Demo.txt) {
    Get-Content C:\SCUGJ34-Demo.txt
} else {
    "Test-Path C:\SCUGJ34-Demo.txt : $(Test-Path C:\SCUGJ34-Demo.txt)"
}

Get-GuestConfigurationPackageComplianceStatus -Path .\SCUGJ34WindowsBaseConfig.zip
