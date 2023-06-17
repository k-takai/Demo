#Requires -RunAsAdministrator

Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

Set-Location .\Desktop

$filename = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
$vclibsfilename = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'

Add-AppxPackage $vclibsfilename
Add-AppxPackage $filename

#Add-AppxPackage "Microsoft.WindowsAppRuntime.1.3_3000.851.1712.0_x64__8wekyb3d8bbwe.msix"
#Add-AppxPackage "3139db9bf92d42b2974dec80f83733a0.msixbundle"

winget --version
