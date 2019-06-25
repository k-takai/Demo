#Requires -RunAsAdministrator

# Execute on DC.

$CsMaster = "ClusterSetMaster"
$RootSOFS = "\\CSRoot-SOFS"

# List all cluster set nodes
Get-ClusterSet -CimSession $CsMaster | Get-Cluster | Get-ClusterNode

# Get all cluster set member nodes
Get-ClusterSetNode -CimSession $CsMaster

# Get all cluster members
Get-ClusterSetMember -CimSession $CsMaster

# Move all VMs to Cluster Set namespace
$VMs = Get-VM -CimSession (Get-ClusterSetNode -CimSession $CsMaster).Name
$VMs | Stop-VM

# Remove VMs from cluster resources
foreach ($VM in $VMs)
{
    Remove-ClusterGroup -Cluster $VM.ComputerName -Name $VM.name -RemoveResources -Force
}

# Remove VMs and keep VM config
foreach ($VM in $VMs)
{
    Invoke-Command -ComputerName $VM.ComputerName -ScriptBlock {
        $path = $using:VM.Path
        Copy-Item -Path "$path\Virtual Machines" -Destination "$path\Virtual Machines Bak" -Recurse
        Get-VM -Id $Using:VM.id | Remove-VM -force
        Copy-Item -Path "$path\Virtual Machines Bak\*" -Destination "$path\Virtual Machines" -Recurse
        Remove-Item -Path "$path\Virtual Machines Bak" -Recurse
    }
}

# Import again, but replace path to \\CSRoot-SOFS
Invoke-Command -ComputerName (Get-ClusterSetMemberber -CimSession $CsMaster).ClusterName -ScriptBlock {
    Get-ChildItem C:\ClusterStorage -Recurse | Where-Object {
        ($_.extension -eq '.vmcx' -and $_.directory -like '*Virtual Machines*') -or ($_.extension -eq '.xml' -and $_.directory -like '*Virtual Machines*')
    } | ForEach-Object -Process {
        $Path = $_.FullName.Replace("C:\ClusterStorage", $using:RootSOFS)
        Import-VM -Path $Path
    }
}

# Add VMs as Highly available and Start
$ClusterSetNodes = Get-ClusterSetNode -CimSession $CsMaster
foreach ($ClusterSetNode in $ClusterSetNodes)
{
    $VMs = Get-VM -CimSession $ClusterSetNode.Name
    if ($VMs)
    {
        $VMs.Name | ForEach-Object { Add-ClusterVirtualMachineRole -VMName $_ -Cluster $ClusterSetNode.Member }
        $VMs | Start-VM
    }
}

# Register all existing VMs
Get-ClusterSetMember -CimSession $CsMaster | Register-ClusterSetVM -RegisterAll

# Create fault domains
New-ClusterSetFaultDomain -Name FD1 -FdType Logical -CimSession $CsMaster -MemberCluster CLUSTER1,CLUSTER2 -Description "fault domain 1 - Cluster1 and Cluster2"
New-ClusterSetFaultDomain -Name FD2 -FdType Logical -CimSession $CsMaster -MemberCluster CLUSTER3 -Description "fault domain 2 - Cluster3"

# Create Availability Set
$AvailabilitySetName = "AvailabilitySet"
$FaultDomainNames = (Get-ClusterSetFaultDomain -CimSession $CsMaster).FDName
New-ClusterSetAvailabilitySet -Name $AvailabilitySetName -FdType Logical -CimSession $CsMaster -ParticipantName $FaultDomainNames

# Add Availability Set to existing VMs
Get-ClusterSetVM -CimSession $CsMaster | Set-ClusterSetVm -AvailabilitySetName $AvailabilitySetName
 
# Display VMs
Get-ClusterSetVM -CimSession $CsMaster
Get-ClusterSetVM -CimSession $CsMaster | Format-Table VMName,AvailabilitySet,FaultDomain,UpdateDomain

# Identify node to create VM
$memoryinMB = 1GB
$cpucount = 1
$AS = Get-ClusterSetAvailabilitySet -CimSession $CsMaster
Get-ClusterSetOptimalNodeForVM -CimSession $CsMaster -VMMemory $memoryinMB -VMVirtualCoreCount $cpucount -VMCpuReservation 10 -AvailabilitySet $AS

# Move VMs around
$VMName = "Cluster1_VM1"
$DestinationNode = "3-S2D1"
Get-ClusterSetVM -CimSession $CsMaster
Move-ClusterSetVM -CimSession $CsMaster -VMName $VMName -MoveType Live -Node $DestinationNode
Get-ClusterSetVM -CimSession $CsMaster
