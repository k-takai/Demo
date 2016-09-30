#Requires -Version 5
#Requires -RunAsAdministrator

Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value *

#$ConfigData = @{
#    AllNodes = @(
#        @{ NodeName = "*"; SetupDefaultUsers = $false ; PSDscAllowPlainTextPassword = $false }
#        @{ NodeName = "win2016tp4"; SetupDefaultUsers = $true ; PSDscAllowPlainTextPassword = $true }
#    );
#    DefaultUserCredential = New-Object System.Management.Automation.PSCredential "user1",$(ConvertTo-SecureString "replace password!!" -AsPlainText -Force);
#}

#Configuration LocalUsers
#{
#    Import-DscResource –ModuleName PSDesiredStateConfiguration
#    Node $AllNodes.Where{$_.SetupDefaultUsers}.NodeName
#    {
#        User User1
#        {
#            UserName = "user1"
#            Ensure = "Present"
#            Disabled = $false
#            FullName = "User 1"
#            Password = $ConfigData.DefaultUserCredential
#            PasswordChangeRequired = $false
#            PasswordNeverExpires = $true
#        }
#
#        Group RestrictedAdmins
#        {
#            GroupName = "Restricted Admins"
#            Ensure = "Present"
#            MembersToInclude = "user1"
#            DependsOn = @("[User]User1")
#        }
#
#    }
#
#}

#LocalUsers -OutputPath $env:TEMP -ConfigurationData $ConfigData
#Start-DscConfiguration -Path $env:TEMP -ComputerName $env:COMPUTERNAME -Verbose -Wait -Debug -Force

$OperatorGroup = New-ADGroup -Name "JEA Operators" -GroupScope DomainLocal -PassThru
$HelpDeskGroup = New-ADGroup -Name "JEA HelpDesk Users" -GroupScope DomainLocal -PassThru
$TestGroup = New-ADGroup -Name "Test Group 01" -GroupScope DomainLocal -PassThru
$OperatorUser = New-ADUser -Name "operator1" -AccountPassword (ConvertTo-SecureString "replace password!!" -AsPlainText -Force) -PassThru
Enable-ADAccount -Identity $OperatorUser
$HelpDeskUser = New-ADUser -Name "helpdesk1" -AccountPassword (ConvertTo-SecureString "replace password!!" -AsPlainText -Force) -PassThru
Enable-ADAccount -Identity $HelpDeskUser
Add-ADGroupMember -Identity $OperatorGroup -Members $OperatorUser
Add-ADGroupMember -Identity $HelpDeskGroup -Members $HelpDeskUser 
New-ADGroup $TestGroup -GroupScope DomainLocal
