#Requires -Version 5
#Requires -RunAsAdministrator

$domain = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain
$SCName = "SCUGJ14_DemoEP"

$credadmin = Get-Credential -UserName "$domain\Administrator" -Message "Enter password for Administrator."
$credope1 = Get-Credential -UserName "$domain\operator1" -Message "Enter password for operator1."

# Normal Remoting
$s1 = New-PSSession -ComputerName localhost -Credential $credadmin
# Can't connect
$s2 = New-PSSession -ComputerName localhost -Credential $credope1
# JEA (Administrator account) - Can't connect
$s3 = New-PSSession -ComputerName localhost -Credential $credadmin -ConfigurationName $SCName
# JEA (user1 account)
$s4 = New-PSSession -ComputerName localhost -Credential $credope1 -ConfigurationName $SCName

Enter-PSSession $s1
exit

Enter-PSSession $s4
Get-Command
Restart-Service -Name Spooler
Restart-Service -Name wuauserv
exit

Get-PSSession | Remove-PSSession

## EP2
$SCName2 = "SCUGJ14_DemoEP2"
$s5 = New-PSSession -ComputerName localhost -Credential $credope1 -ConfigurationName $SCName2

Enter-PSSession $s5
Get-Command
Restart-Service -Name Spooler
Restart-Service -Name wuauserv
Stop-Process -Name notepad
Stop-Process -Name mspaint
exit

Get-PSSession | Remove-PSSession
