#Requires -Version 5
#Requires -RunAsAdministrator

Enable-PSRemoting -Force

Get-DscLocalConfigurationManager

Get-DscResource
Get-Module -ListAvailable

Find-Module nx
Install-Module nx

Get-Module -ListAvailable
Get-Module nx -ListAvailable
Get-DscResource
Get-DscResource nx*
