Install-Module xPSDesiredStateConfiguration

New-SelfSignedCertificate -DnsName "10.0.0.4","10.0.0.8" -KeyUsage CertSign,DigitalSignature -KeyExportPolicy Exportable
Get-ChildItem Cert:\LocalMachine\My\ | ? Subject -like "CN*"
$cert = Get-ChildItem Cert:\LocalMachine\My\ | ? Subject -like "CN*"
$cert.Thumbprint
$pass = ConvertTo-SecureString -String "password" -AsPlainText -Force
Export-PfxCertificate -Cert $cert -FilePath .\cert.pfx -Password $pass
Import-PfxCertificate -Exportable -Password $pass -CertStoreLocation Cert:\LocalMachine\Root\ -FilePath .\cert.pfx

Configuration DSCPullServer
{
    param
    (
        [string[]]$NodeName = 'localhost',
        [ValidateNotNullOrEmpty()]
        [string]$CertThumbPrint,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RegistrationKey
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource –ModuleName PSDesiredStateConfiguration

    Node $NodeName
    {
        WindowsFeature DSCService
        {
            Ensure = 'Present'
            Name = 'DSC-Service'
        }

        xDscWebService PSDSCPullServer
        {
            Ensure = 'Present'
            EndpointName = 'PSDSCPullServer'
            Port = 8080
            PhysicalPath = "$env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint = $CertThumbPrint
            ModulePath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            State = 'Started'
            DependsOn = '[WindowsFeature]DSCService'
            UseSecurityBestPractices = $false
        }

        File RegistrationKeyFile
        {
            Ensure = 'Present'
            Type = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents = $RegistrationKey
        }
    }
}

$regKey = New-Guid
$regKey

DSCPullServer -CertThumbPrint $cert.Thumbprint -RegistrationKey $regKey -OutputPath $env:TEMP
Start-DscConfiguration -Path $env:TEMP -Wait -Verbose
