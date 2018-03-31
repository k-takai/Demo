## @svr02
Get-WindowsFeature | ? Installed

## portal で 202-AzureVMDSCExtensionDemo.ps1 をアップロード

Get-CloudDrive
Get-PSDrive
cd Y:\
Get-ChildItem

$resourceGroup = "dsc-demo"
$vmName = "svr02"
$storageName = "dscdemodiag104"

Publish-AzureRmVMDscConfiguration -ConfigurationPath .\202-AzureVMDSCExtensionDemo02.ps1 -ResourceGroupName $resourceGroup -StorageAccountName $storageName -Force

## portal でファイルを確認

Set-AzureRmVmDscExtension -Version 2.74 -ResourceGroupName $resourceGroup -VMName $vmName -ArchiveStorageAccountName $storageName -ArchiveBlobName 202-AzureVMDSCExtensionDemo02.ps1.zip -AutoUpdate:$true -ConfigurationName "SampleWebServer"

## @svr02
Get-WindowsFeature | ? Installed
