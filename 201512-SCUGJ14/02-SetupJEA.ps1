#Requires -Version 5
#Requires -RunAsAdministrator

$MaintenanceRoleCapabilityCreationParams = @{
    Author = "SCUGJ";
    ModulesToImport = "Microsoft.PowerShell.Core";
    VisibleCmdlets = "Restart-Service";
    CompanyName = "SCUGJ";
    FunctionDefinitions = @{ Name = 'Get-UserInfo'; ScriptBlock = {$PSSenderInfo}; };
}

# Create the demo module
$basepath = "$env:ProgramFiles\WindowsPowerShell\Modules\SCUGJ14_Demo"
New-Item -Path $basepath -ItemType Directory
New-ModuleManifest -Path "$basepath\SCUGJ14_Demo.psd1"
New-Item -Path "$basepath\RoleCapabilities" -ItemType Directory 

# Create the Role Capability file
New-PSRoleCapabilityFile -Path "$basepath\RoleCapabilities\Maintenance.psrc" @MaintenanceRoleCapabilityCreationParams

if(!(Test-Path "$env:ProgramData\JEAConfiguration")) {
    New-Item -Path "$env:ProgramData\JEAConfiguration" -ItemType Directory
}

$domain = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain
$target = "$domain\JEA Operators"

# PS Session Configuration Name
$SCName = "SCUGJ14_DemoEP"
if(Get-PSSessionConfiguration -Name $SCName -ErrorAction SilentlyContinue) {
    Unregister-PSSessionConfiguration -Name $SCName -ErrorAction Stop
}

$JEAConfigParams = @{
    SessionType = "RestrictedRemoteServer";
    #RunAsVirtualAccount = $false;
    RunAsVirtualAccount = $true;
    RoleDefinitions = @{ $target = @{ RoleCapabilities = 'Maintenance' }; };
    TranscriptDirectory = "$env:ProgramData\JEAConfiguration\Transcripts";
}

New-PSSessionConfigurationFile -Path "$env:ProgramData\JEAConfiguration\$SCName.pssc" @JEAConfigParams
Register-PSSessionConfiguration -Name $SCName -Path "$env:ProgramData\JEAConfiguration\$SCName.pssc"

Restart-Service WinRM 

## EP2
$MaintenanceRoleCapabilityCreationParams2 = @{
    Author = "SCUGJ";
    ModulesToImport = "Microsoft.PowerShell.Core";
    VisibleCmdlets = "Restart-Service";
    CompanyName = "SCUGJ";
    FunctionDefinitions = @{ Name = 'Get-UserInfo'; ScriptBlock = {$PSSenderInfo}; };
}
# 編集済みのファイルを配置済み
#New-PSRoleCapabilityFile -Path "$basepath\RoleCapabilities\Maintenance2.psrc" @MaintenanceRoleCapabilityCreationParams2
ise "$basepath\RoleCapabilities\Maintenance2.psrc"

$SCName2 = "SCUGJ14_DemoEP2"
if(Get-PSSessionConfiguration -Name $SCName2 -ErrorAction SilentlyContinue) {
    Unregister-PSSessionConfiguration -Name $SCName2 -ErrorAction Stop
}

$JEAConfigParams2 = @{
    SessionType = "RestrictedRemoteServer";
    RunAsVirtualAccount = $true;
    RoleDefinitions = @{ $target = @{ RoleCapabilities = 'Maintenance2' }; };
    TranscriptDirectory = "$env:ProgramData\JEAConfiguration\Transcripts";
}

New-PSSessionConfigurationFile -Path "$env:ProgramData\JEAConfiguration\$SCName2.pssc" @JEAConfigParams2
Register-PSSessionConfiguration -Name $SCName2 -Path "$env:ProgramData\JEAConfiguration\$SCName2.pssc"

Restart-Service WinRM 
ise "$env:ProgramData\JEAConfiguration\$SCName2.pssc"
