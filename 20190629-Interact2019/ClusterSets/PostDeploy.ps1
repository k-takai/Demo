#Requires -RunAsAdministrator

Get-VM | Start-VM

. "$PSScriptRoot\LabConfig.ps1"
$cred = New-Object System.Management.Automation.PSCredential ($LabConfig.DomainNetbiosName + "\" + $LabConfig.DomainAdminName),(ConvertTo-SecureString -String $LabConfig.AdminPassword -AsPlainText -Force)
$s = New-PSSession -VMName Lab-DC -Credential $cred
Copy-Item -Path $PSScriptRoot\01_PrepCluster.ps1 -ToSession $s -Destination C:\Users\$($LabConfig.DomainAdminName)\Desktop\01_PrepCluster.ps1
Copy-Item -Path $PSScriptRoot\02_CreateMgmtCluster.ps1 -ToSession $s -Destination C:\Users\$($LabConfig.DomainAdminName)\Desktop\02_CreateMgmtCluster.ps1
Copy-Item -Path $PSScriptRoot\03_CreateClusterSet.ps1 -ToSession $s -Destination C:\Users\$($LabConfig.DomainAdminName)\Desktop\03_CreateClusterSet.ps1
Copy-Item -Path $PSScriptRoot\04_OperateClusterSet.ps1 -ToSession $s -Destination C:\Users\$($LabConfig.DomainAdminName)\Desktop\04_OperateClusterSet.ps1
Copy-Item -Path $PSScriptRoot\ParentDisks\Win2019Core_G2.vhdx -ToSession $s -Destination C:\Users\$($LabConfig.DomainAdminName)\Documents\Win2019Core_G2.vhdx
Copy-Item -Path $PSScriptRoot\WindowsAdminCenter.msi -ToSession $s -Destination C:\Users\$($LabConfig.DomainAdminName)\Downloads\WindowsAdminCenter.msi
Remove-PSSession $s
