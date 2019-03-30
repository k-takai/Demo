
docker pull microsoft/windowsservercore
docker pull microsoft/nanoserver
docker pull microsoft/windowsservercore-insider
docker pull microsoft/nanoserver-insider

docker pull microsoft/nanoserver-insider-powershell
docker pull microsoft/nanoserver-insider-dotnet

Install-Module -Name DockerProvider -Repository PSGallery -Force
Install-Package -Name docker -ProviderName DockerProvider -RequiredVersion Preview
Restart-Computer -Force

