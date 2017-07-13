$MediaPath = "F:\"
$OutputBaseDir = "D:\Shares\Share\nano\images\"
$ImageName = "nano-sv"
$ImageType = "wim" # vhd or vhdx or wim
$OutputDir = $OutputBaseDir + $ImageName
$LogDir = $OutputDir + "\Logs\" + (Get-Date -Format "yyyyMMdd-HHmmss")
$ServicingPackagePath = ('D:\Shares\Share\nano\updates\Windows10.0-KB4022715-x64.cab', 'D:\Shares\Share\nano\updates\Windows10.0-KB4023834-x64.cab')
#$ServicingPackagePath = 'D:\Shares\Share\nano\updates\'

New-Item -ItemType Directory -Path $OutputDir
Set-Location -Path $OutputDir
Copy-Item -Recurse ($MediaPath + "NanoServer\NanoServerImageGenerator") .\
Import-Module .\NanoServerImageGenerator\NanoServerImageGenerator -Verbose

# Minimum
New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $MediaPath -BasePath .\Base -TargetPath (".\" + $ImageName + "." + $ImageType) -LogPath $LogDir -Verbose

# Base
#New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $MediaPath -BasePath .\Base -TargetPath (".\" + $ImageName + "." + $ImageType) -ServicingPackagePath $ServicingPackagePath -EnableEMS -EMSPort 1 -EMSBaudRate 115200 -SetupCompleteCommand ('tzutil.exe /s "Tokyo Standard Time"') -LogPath $LogDir -Verbose

# Hyper-V Cluster Host
#New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $MediaPath -BasePath .\Base -TargetPath (".\" + $ImageName + "." + $ImageType) -Compute -Clustering -Storage -Defender -Package Microsoft-NanoServer-DSC-Package -ServicingPackagePath $ServicingPackagePath -EnableEMS -EMSPort 1 -EMSBaudRate 115200 -SetupCompleteCommand ('tzutil.exe /s "Tokyo Standard Time"') -LogPath $LogDir -Verbose

# Container Host
#New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $MediaPath -BasePath .\Base -TargetPath (".\" + $ImageName + "." + $ImageType) -Containers -Defender -Package Microsoft-NanoServer-DSC-Package -ServicingPackagePath $ServicingPackagePath -EnableEMS -EMSPort 1 -EMSBaudRate 115200 -SetupCompleteCommand ('tzutil.exe /s "Tokyo Standard Time"') -LogPath $LogDir -Verbose
