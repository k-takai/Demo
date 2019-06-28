#Requires -RunAsAdministrator

# Execute on DC.

# check Failover Cluster Manager

Get-Cluster -Name Cluster1
Get-Cluster -Name Cluster2
Get-Cluster -Name Cluster3
Get-Cluster -Name Cluster1 | Get-ClusterNode
Get-Cluster -Name Cluster2 | Get-ClusterNode
Get-Cluster -Name Cluster3 | Get-ClusterNode

$ClusterName = "MgmtCluster"
$ClusterIP = "10.0.0.220"
$ClusterNodes = 1..3 | ForEach-Object {
    "Mgmt$_"
}
Invoke-Command -ComputerName $ClusterNodes -ScriptBlock {
    Install-WindowsFeature -Name "Failover-Clustering"
}
Restart-Computer -ComputerName $ClusterNodes -Protocol WSMan -Wait -For PowerShell
New-Cluster -Name $ClusterName -Node $ClusterNodes -StaticAddress $ClusterIP
