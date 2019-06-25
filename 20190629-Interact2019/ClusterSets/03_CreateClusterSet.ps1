#Requires -RunAsAdministrator

# Execute on DC.

$CsMaster = "ClusterSetMaster"
New-ClusterSet -name $CsMaster -NamespaceRoot "CSRoot-SOFS" -CimSession "MgmtCluster" -StaticAddress "10.0.0.221"

Add-ClusterSetMember -ClusterName Cluster1 -CimSession $CsMaster -InfraSOFSName CL1-SOFS
Add-ClusterSetMember -ClusterName Cluster2 -CimSession $CsMaster -InfraSOFSName CL2-SOFS
Add-ClusterSetMember -ClusterName Cluster3 -CimSession $CsMaster -InfraSOFSName CL3-SOFS

# Enable Live migration with kerberos authentication
$Clusters = (Get-ClusterSetMember -CimSession $CsMaster).ClusterName
$Nodes = Get-ClusterSetNode -CimSession $CsMaster
foreach ($Cluster in $Clusters)
{
    $SourceNodes = ($nodes | Where-Object member -eq $Cluster).Name
    $DestinationNodes = ($nodes | Where-Object member -ne $Cluster).Name
    foreach ($DestinationNode in $DestinationNodes)
    {
        $HostName = $DestinationNode
        $HostFQDN = (Resolve-DnsName $HostName).name | Select-Object -First 1
        foreach ($SourceNode in $SourceNodes)
        {
            Get-ADComputer $SourceNode | Set-ADObject -Add @{ "msDS-AllowedToDelegateTo" = "Microsoft Virtual System Migration Service/$HostFQDN", "Microsoft Virtual System Migration Service/$HostName", "cifs/$HostFQDN", "cifs/$HostName" }
        }
    }
}

foreach ($Node in $Nodes)
{
    $GUID = (Get-ADComputer $Node.Name).ObjectGUID
    $c = Get-ADObject -identity $Guid -Properties "userAccountControl"
    $c.userAccountControl = $c.userAccountControl -bor 16777216
    Set-ADObject -Instance $c
}

Set-VMHost -CimSession $Nodes.Name -VirtualMachineMigrationAuthenticationType Kerberos

# add Management cluster computer account to each node local Administrators group
$MgmtClusterterName = (Get-ClusterSet -CimSession $CsMaster).ClusterName
Invoke-Command -ComputerName (Get-ClusterSetNode -CimSession $CsMaster).Name -ScriptBlock {
    Add-LocalGroupMember -Group Administrators -Member "$using:MgmtClusterterName$"
}
 
Invoke-Command -ComputerName (Get-ClusterSetNode -CimSession $CsMaster).Name -ScriptBlock {
    Get-LocalGroupMember -Group Administrators
} | format-table Name,PSComputerName
