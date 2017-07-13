#Requires -RunAsAdministrator

$ComputerName = "hv01"
Invoke-Command -ComputerName $ComputerName -FilePath .\New-VM.ps1
