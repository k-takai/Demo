Install-Module SecurityPolicyDsc

Configuration SampleServer
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [string]$NodeName
    )

    Import-DscResource -ModuleName SecurityPolicyDsc

    Node $NodeName
    {
        WindowsFeature Telnet
        {
            Name = "Telnet-Client"
            Ensure = "Present"
        }

        AccountPolicy AccountPolicies
        {
            Name = 'PasswordPolicies'
            Enforce_password_history = 3
            Maximum_Password_Age = 90
            Minimum_Password_Age = 1
            Minimum_Password_Length = 12
            Password_must_meet_complexity_requirements = 'Enabled'
            Store_passwords_using_reversible_encryption = 'Disabled'
        }
    }
}

#GUIDを入力
$id = "1c3732ee-de71-4933-b9c2-f7eee915f863"
SampleServer -NodeName $id -OutputPath $env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration
