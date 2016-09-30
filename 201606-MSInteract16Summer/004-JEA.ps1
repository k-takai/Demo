explorer  $env:USERPROFILE\Downloads\JEAHelperTool20

cd  $env:USERPROFILE\Downloads\JEAHelperTool20
dir

.\JEAHelperTool.ps1

####
# 別コンソールで

Get-PSSessionCapability -ConfigurationName JEA_DemoXYZ -Username "example\HelpDeskUser"
Get-PSSessionCapability -ConfigurationName JEA_DemoXYZ -Username "example\OperatorUser"

$NonAdminOperatorGroup = New-ADGroup -Name "JEA_NonAdmin_Operator" -GroupScope DomainLocal -PassThru
$NonAdminHelpDeskGroup = New-ADGroup -Name "JEA_NonAdmin_HelpDesk" -GroupScope DomainLocal -PassThru
$TestGroup = New-ADGroup -Name "Test_Group" -GroupScope DomainLocal -PassThru
