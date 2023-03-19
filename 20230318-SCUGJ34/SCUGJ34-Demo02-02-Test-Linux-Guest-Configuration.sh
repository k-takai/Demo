cat /etc/lsb-release
sudo apt update
sudo apt upgrade
sudo apt install wget apt-transport-https software-properties-common
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install powershell

pwsh

: << 'EXEC_ON_POWERSHELL'
Get-Module -ListAvailable
Install-Module -Name GuestConfiguration
Get-Module -Name GuestConfiguration -ListAvailable
Get-Module -ListAvailable
exit
EXEC_ON_POWERSHELL

ls -lha ./.local/share/powershell/Modules/

ls -lha /etc/motd
sudo pwsh -c 'Get-GuestConfigurationPackageComplianceStatus -Path ./SCUGJ34LinuxBaseConfig.zip'

sudo pwsh -c 'Start-GuestConfigurationPackageRemediation -Path ./SCUGJ34LinuxBaseConfig.zip'
ls -lha /etc/motd
cat /etc/motd

#exit
#ssh -i .\.ssh\id_rsa takai@ubuntu18-dev
