#Requires -RunAsAdministrator

# Execute on DC.

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
