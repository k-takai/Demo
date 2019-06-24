#Requires -RunAsAdministrator

Get-VM | Start-VM

. "$PSScriptRoot\LabConfig.ps1"
$cred = New-Object System.Management.Automation.PSCredential $LabConfig.DomainAdminName,(ConvertTo-SecureString -String $LabConfig.AdminPassword -AsPlainText -Force)
$s = New-PSSession -VMName Lab-DC -Credential $cred
Copy-Item -Path D:\Lab\ParentDisks\Win2019Core_G2.vhdx -ToSession $s -Destination C:\Win2019Core_G2.vhdx
Remove-PSSession $s
