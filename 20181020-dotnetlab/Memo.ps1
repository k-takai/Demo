# 10min-----

Get-VM ws2019demo01 | Set-VMProcessor -ExposeVirtualizationExtensions $true
Start-VM ws2019demo01

Get-WindowsFeature Hyper-V,Containers
Get-WindowsFeature Hyper-V,Containers | Install-WindowsFeature -IncludeManagementTools
Restart-Computer

Install-Module -Name DockerProvider -Repository PSGallery -Force
Find-Package -Name docker -ProviderName DockerProvider -AllVersions
Find-Package -Name docker -ProviderName DockerProvider -AllVersions | select -Property Version | Sort-Object -Property Version | Get-Unique -AsString
Install-Package -Name docker -ProviderName DockerProvider -RequiredVersion 18.03 -Force

services.msc
Get-Service docker

# -----

docker run --isolation hyperv hello-world:nanoserver-1803

docker version
docker info

docker pull --platform=linux microsoft/azure-cli
# "--platform" is only supported on a Docker daemon with experimental features enabled

%programdata%\docker\config\daemon.json

Restart-Service docker
docker version
docker info

Invoke-WebRequest -Uri 'https://github.com/linuxkit/lcow/releases/download/4.14.29-0aea33bc/release.zip' -UseBasicParsing -OutFile .\Downloads\release.zip
Expand-Archive .\Downloads\release.zip -DestinationPath "$Env:ProgramFiles\Linux Containers\."
dir $env:ProgramFiles
dir 'C:\Program Files\Linux Containers\'

docker pull --platform=linux alpine
docker run --platform=linux alpine uname -a

docker run --isolation hyperv --rm -d -p 80:80 microsoft/iis

docker run --isolation hyperv --rm microsoft/dotnet-samples:dotnetapp-nanoserver-1803
docker run --platform=linux --rm microsoft/dotnet-samples:dotnetapp-stretch

docker run --isolation hyperv -it --rm -p 8080:80 microsoft/dotnet-samples:aspnetapp-nanoserver-1803
docker run --platform=linux -it --rm -p 8081:80 microsoft/dotnet-samples:aspnetapp-stretch

# --------------

# .NET Core SDK
# VS Code + C#

cd .\Documents\
dotnet /?

dotnet new webapp -o DemoPages01
cd DemoPages01
dotnet run

# COPY Dockerfile .dockerignore

docker build -t demo01 .
docker run --isolation hyperv --rm -d -p 8080:80 demo01
