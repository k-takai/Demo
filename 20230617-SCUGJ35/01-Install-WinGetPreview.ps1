#Requires -RunAsAdministrator

Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

Set-Location $env:TEMP

$uri = 'https://aka.ms/getwingetpreview'
$h = Invoke-WebRequest -Uri $uri -Method Head -UseBasicParsing
$filename = $h.Headers['Content-Disposition'].Split('=')[-1]
Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile "./$filename"

$vclibsfilename = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
$vclibsuri = "https://aka.ms/$vclibsfilename"
Invoke-WebRequest -Uri $vclibsuri -UseBasicParsing -OutFile "./$vclibsfilename"

Start-Sleep -Seconds 3

Test-Path $vclibsfilename -ErrorAction Stop
Test-Path $filename -ErrorAction Stop

xAdd-AppxPackage $vclibsfilename
Add-AppxPackage $filename

#winget install --id Microsoft.DevHome -e

winget --version
