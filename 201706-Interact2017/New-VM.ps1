$VMCount = 10
$StartNum = 1
$VMNamePrefix = "NanoHV-"
$MemSize = 2GB
$VHDSize = 20GB
$ConnectedVMSwitch = "Network"
$VMBase = "C:\Hyper-V"

$StartNum..$VMCount | % {
    $VMName = $VMNamePrefix + $_.ToString("0000000")
    $VHDPath = "$VMBase\$VMName\Virtual Hard Disks\$VMName.vhdx"
    New-VM -Name $VMName -MemoryStartupBytes $MemSize -Generation 2 -BootDevice NetworkAdapter -SwitchName $ConnectedVMSwitch -Path $VMBase -NewVHDPath $VHDPath -NewVHDSizeBytes $VHDSize
    Start-Sleep -Seconds 1

    Start-VM $VMName
    Start-Sleep -Seconds 1
}
