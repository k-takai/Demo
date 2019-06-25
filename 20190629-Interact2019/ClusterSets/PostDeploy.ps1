#Requires -RunAsAdministrator

Get-VM | Start-VM

. "$PSScriptRoot\LabConfig.ps1"
$cred = New-Object System.Management.Automation.PSCredential ($LabConfig.DomainNetbiosName + "\" + $LabConfig.DomainAdminName),(ConvertTo-SecureString -String $LabConfig.AdminPassword -AsPlainText -Force)
$s = New-PSSession -VMName Lab-DC -Credential $cred
Copy-Item -Path $PSScriptRoot\PrepCluster.ps1 -ToSession $s -Destination C:\Users\$LabConfig.DomainAdminName\Desktop\PrepCluster.ps1
Copy-Item -Path $PSScriptRoot\ParentDisks\Win2019Core_G2.vhdx -ToSession $s -Destination C:\Users\$LabConfig.DomainAdminName\Desktop\Win2019Core_G2.vhdx
Remove-PSSession $s
