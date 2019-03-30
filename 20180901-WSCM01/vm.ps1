Get-VM
Get-VMProcessor -VMName ws2019-17744
Get-VMProcessor -VMName ws2019-17744 | fl *
Set-VMProcessor -VMName ws2019-17744 -ExposeVirtualizationExtensions $true
Get-VMProcessor -VMName ws2019-17744 | fl *
