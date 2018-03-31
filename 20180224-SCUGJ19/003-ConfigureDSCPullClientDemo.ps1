[DSCLocalConfigurationManager()]
Configuration PullClientConfigID
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [string]$ConfId
    )

    Node localhost
    {
        Settings
        {
            RefreshMode = 'Pull'
            ConfigurationID = $ConfId
            RefreshFrequencyMins = 30 
            RebootNodeIfNeeded = $true
        }

        ConfigurationRepositoryWeb PullSvr
        {
            ServerURL = 'https://10.0.0.4:8080/PSDSCPullServer.svc'
        }      
    }
}

# Pull Server の証明書をインポートしておくこと

$id = New-Guid
$id
Get-DscLocalConfigurationManager

PullClientConfigID -ConfId $id -OutputPath $env:TEMP
Set-DSCLocalConfigurationManager localhost –Path $env:TEMP –Verbose

Get-DscLocalConfigurationManager
