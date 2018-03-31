Get-DscConfiguration
Enable-PSRemoting -Force

Install-Module SecurityPolicyDsc

Configuration SampleServer
{
    Import-DscResource -ModuleName SecurityPolicyDsc

    Node "localhost"
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

SampleServer -OutputPath $env:TEMP
Start-DscConfiguration -Path $env:TEMP -Wait -Verbose
