## Preparation : install PowerShell 7.3

$BasePath = "${env:USERPROFILE}\Documents\PowerShell"
if($PSScriptRoot -ne $null -and (Test-Path $PSScriptRoot -ErrorAction SilentlyContinue))
{
    Set-Location $PSScriptRoot
} elseif (Test-Path $BasePath -ErrorAction SilentlyContinue) {
    Set-Location $BasePath
}

#Get-Module
#Install-Module -Name GuestConfiguration
#Install-Module -Name PSDesiredStateConfiguration -AllowPrerelease

Get-Module
Get-Module -ListAvailable | Where-Object { $_.Name -in @("GuestConfiguration","PSDesiredStateConfiguration") }

#Import-Module GuestConfiguration
#Import-Module PSDesiredStateConfiguration
#Get-Module

Get-ChildItem .\
. .\SCUGJLinuxBaseConfiguration.ps1
SCUGJLinuxBaseConfiguration
Get-ChildItem .\SCUGJLinuxBaseConfiguration\

New-GuestConfigurationPackage -Name SCUGJ34LinuxBaseConfig -Configuration .\SCUGJLinuxBaseConfiguration\SCUGJ34LinuxBaseConfig.mof -Type AuditAndSet -Force
Get-ChildItem .\

### Copy configuration package to Linux (Ubuntu 18.04 LTS) host

Get-ChildItem $env:USERPROFILE\.ssh\
scp -i $env:USERPROFILE\.ssh\id_rsa .\SCUGJ34LinuxBaseConfig.zip ubuntu18-dev:~/

#ssh -i .\.ssh\id_rsa takai@ubuntu18-dev

### Next: SCUGJ34-Demo02-02-Test-Linux-Guest-Configuration.ps1
