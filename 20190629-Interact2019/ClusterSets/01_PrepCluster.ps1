#Requires -RunAsAdministrator

# Execute on DC.
# Before execute this scripts, copy vhdx to DC VM.

$Clusters = @()
$Clusters += @{ Nodes = "1-S2D1","1-S2D2"; Name = "Cluster1"; IP = "10.0.0.211"; Volumenames = "CL1Mirror1","CL1Mirror2"; VolumeSize = 2TB }
$Clusters += @{ Nodes = "2-S2D1","2-S2D2"; Name = "Cluster2"; IP = "10.0.0.212"; Volumenames = "CL2Mirror1","CL2Mirror2"; VolumeSize = 2TB }
$Clusters += @{ Nodes = "3-S2D1","3-S2D2"; Name = "Cluster3"; IP = "10.0.0.213"; Volumenames = "CL3Mirror1","CL3Mirror2"; VolumeSize = 2TB }

[reflection.assembly]::loadwithpartialname("System.Windows.Forms")
$openFile = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    Title = "Please select parent VHDx."
}
$openFile.Filter = "VHDx files (*.vhdx)|*.vhdx"
If ($openFile.ShowDialog() -eq "OK")
{
    Write-Host "File $($openfile.FileName) selected" -ForegroundColor Cyan
}
if (!$openFile.FileName)
{
    Write-Host "No VHD was selected... Skipping VM Creation" -ForegroundColor Red
}
$VHDPath = $openFile.FileName

$WindowsInstallationType = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name InstallationType
if ($WindowsInstallationType -eq "Server")
{
    Install-WindowsFeature -Name RSAT-Clustering,RSAT-Clustering-Mgmt,RSAT-Clustering-PowerShell,RSAT-Hyper-V-Tools,RSAT-Feature-Tools-BitLocker-BdeAducExt,RSAT-Storage-Replica,RSAT-AD-PowerShell
}
elseif ($WindowsInstallationType -eq "Server Core")
{
    Install-WindowsFeature -Name RSAT-Clustering,RSAT-Clustering-PowerShell,RSAT-Hyper-V-Tools,RSAT-Storage-Replica,RSAT-AD-PowerShell
}

Invoke-Command -computername $Clusters.nodes -ScriptBlock {
    Install-WindowsFeature -Name "Failover-Clustering","Hyper-V-PowerShell","Hyper-V"
}

Restart-Computer $Clusters.nodes -Protocol WSMan -Wait -For PowerShell
Start-Sleep 20

#create clusters
foreach ($Cluster in $Clusters) {
    New-Cluster -Name $Cluster.Name -Node $Cluster.Nodes -StaticAddress $Cluster.IP
}

#add file share witnesses
foreach ($Cluster in $Clusters) {
    $WitnessName = $Cluster.name + "Witness"
    Invoke-Command -ComputerName DC -ScriptBlock { New-Item -Path C:\Shares -Name $using:WitnessName -ItemType Directory }
    $accounts = @()
    $accounts += "corp\$($Cluster.Name)$"
    $accounts += "corp\Domain Admins"
    New-SmbShare -Name $WitnessName -Path "C:\Shares\$WitnessName" -FullAccess $accounts -CimSession DC
    Invoke-Command -ComputerName DC -ScriptBlock { (Get-SmbShare $using:WitnessName).PresetPathAcl | Set-Acl }
    Set-ClusterQuorum -Cluster $Cluster.name -FileShareWitness "\\DC\$WitnessName"
}

#enable s2d
foreach ($Cluster in $Clusters) {
    Enable-ClusterS2D -CimSession $Cluster.Name -confirm:$false -Verbose
}

#create volumes
foreach ($Cluster in $Clusters) {
    New-Volume -StoragePoolFriendlyName "S2D on $($Cluster.Name)" -FriendlyName $Cluster.VolumeNames[0] -FileSystem CSVFS_ReFS -StorageTierFriendlyNames Capacity -StorageTierSizes $Cluster.VolumeSize -CimSession $Cluster.Name
    New-Volume -StoragePoolFriendlyName "S2D on $($Cluster.Name)" -FriendlyName $Cluster.VolumeNames[1] -FileSystem CSVFS_ReFS -StorageTierFriendlyNames Capacity -StorageTierSizes $Cluster.VolumeSize -CimSession $Cluster.Name
}

#create VM on each volume
if ($VHDPath)
{
    foreach ($Cluster in $Clusters) {
        $VMName = "$($Cluster.Name)_VM1"
        $VolumeName = $Cluster.VolumeNames[0]
        New-Item -Path "\\$($Cluster.Name)\ClusterStorage$\$VolumeName\$VMName\Virtual Hard Disks" -ItemType Directory
        Copy-Item -Path $VHDPath -Destination "\\$($Cluster.Name)\ClusterStorage$\$VolumeName\$VMName\Virtual Hard Disks\$($VMName)_Disk1.vhdx"
        New-VM -Name $VMName -MemoryStartupBytes 256MB -Generation 2 -Path "C:\ClusterStorage\$VolumeName" -VHDPath "C:\ClusterStorage\$VolumeName\$VMName\Virtual Hard Disks\$($VMName)_Disk1.vhdx" -ComputerName $Cluster.Nodes[0]
        Start-VM -Name $VMName -ComputerName $Cluster.Nodes[0]
        Add-ClusterVirtualMachineRole -VMName $VMName -Cluster $Cluster.Name

        $VMName = "$($Cluster.Name)_VM2"
        $VolumeName = $Cluster.VolumeNames[1]
        New-Item -Path "\\$($Cluster.Name)\ClusterStorage$\$VolumeName\$VMName\Virtual Hard Disks" -ItemType Directory
        Copy-Item -Path $VHDPath -Destination "\\$($Cluster.Name)\ClusterStorage$\$VolumeName\$VMName\Virtual Hard Disks\$($VMName)_Disk1.vhdx"
        New-VM -Name $VMName -MemoryStartupBytes 256MB -Generation 2 -Path "C:\ClusterStorage\$VolumeName" -VHDPath "c:\ClusterStorage\$VolumeName\$VMName\Virtual Hard Disks\$($VMName)_Disk1.vhdx" -ComputerName $Cluster.Nodes[1]
        Start-VM -Name $VMName -ComputerName $Cluster.Nodes[1]
        Add-ClusterVirtualMachineRole -VMName $VMName -Cluster $Cluster.Name
    }
}
