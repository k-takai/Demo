Get-WindowsCapability -Online
Add-WindowsCapability -Online -Name ServerCore.Appcompatibility~~~~0.0.1.0
Add-WindowsCapability -Online -LimitAccess -Name ServerCore.Appcompatibility~~~~0.0.1.0 -Source D:\

Add-WindowsCapability -Online -Name Browser.InternetExplorer~~~~0.0.11.0

mmc
eventvwr
perfmon
devmgmt
explorer
cluadmin
powershell_ise

cd "C:\Program Files\internet explorer"
iexplore.exe

$s = New-PSSession -VMName ws2019sql02 -Credential (Get-Credential)
Copy-Item -Path .\SQLInstallConf.ini -ToSession $s -Destination C:\Users\Administrator\Documents\

D:
.\Setup.exe /QS /ConfigurationFile=C:\Users\Administrator\Documents\SQLInstallConf.ini

https://docs.microsoft.com/en-us/sql/ssms/sql-server-management-studio-changelog-ssms?view=sql-server-2017#ssms-179-latest-ga-release

Copy-Item -Path .\SSMS-Setup-ENU.exe -ToSession $s -Destination C:\Users\Administrator\Documents\

$s = New-PSSession -VMName ws2019exs01 -Credential $cred
Copy-Item -Path .\vcredist_x64.exe -ToSession $s -Destination C:\Users\Administrator\Documents\

C:\Users\Administrator\Documents\vcredist_x64.exe

Install-WindowsFeature Server-Media-Foundation, RSAT-ADDS

.\Setup.exe /IAcceptExchangeServerLicenseTerms /PrepareSchema
.\Setup.exe /IAcceptExchangeServerLicenseTerms /PrepareAD /OrganizationName:"Contoso Corporation"
.\Setup.exe /IAcceptExchangeServerLicenseTerms /PrepareAllDomains

.\UCMARedist\Setup.exe

.\Setup.exe /m:install /roles:m /IAcceptExchangeServerLicenseTerms /InstallWindowsComponents

launchEMS

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Restart-Computer
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile .\Downloads\Ubuntu.zip -UseBasicParsing
New-Item -ItemType Directory -Path C:\Distros -Force
Expand-Archive -Path .\Downloads\Ubuntu.zip -DestinationPath C:\Distros\Ubuntu
cd C:\Distros\Ubuntu\
.\ubuntu1804.exe

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
