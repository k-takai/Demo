Configuration LinuxConfig {

    param (
        [parameter(mandatory)]
        [string[]]$Node
    )

    Import-DscResource -Module nx

    Node $Node {

        nxGroup TestGroup {
            GroupName = "testgrp"
            Ensure = "Present"
        }

        nxUser TestUser {
            UserName = "testuser"
            Ensure = "Present"
            Password  = '$6$fZAne/Qc$MZejMrOxDK0ogv9SLiBP5J5qZFBvXLnDu8HY1Oy7ycX.Y3C7mGPUfeQy3A82ev3zIabhDQnj2ayeuGn02CqE/0'
            HomeDirectory = "/home/testuser"
            Description = "test user"
            GroupID = "testgrp"
            DependsOn = "[nxGroup]TestGroup"
        }

        nxSshAuthorizedKeys ScugjSSHKey {
            UserName = "testuser"
            Key = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCX8+lLrYjJYYJv0XPIinEkuUpudcj2Z7TzFMxY+QEFfKXIOC8a2hOmA5kSOchYowDQjujVWOJv07cB9756ce2CJ9BGEmRKUq1ws0fUix9fTziN7n7f/I2UO6rOkUoZwcUdNVXeDdx0CR8IWxXrP1q490nLwFYfL/Tee6RVmn9DVPx6uS/ZAJkBqDcD189BpeKcps18y8tcYUaIe7ner7j30bj+6icqOgYLfHShc62L8DK6v8YDumLY76PhHGCkCZwl8SA4upuMEQJeROcOaSsIBMq4KU1Ljezgu54L4VCIyN71itw/wtIx+7gVagVjx0sGm4BxDWNoyM3ObpFaTSqx testuser@linux'
            Ensure = "Present"
            KeyComment = "SSH RSA for testuser"
            DependsOn = "[nxUser]TestUser"
        }

        nxPackage Apache2 {
            Name = "httpd"
            Ensure = "Present"
            PackageManager = "yum"
        }

        nxService Apache2Service {
            Name = "httpd"
            State = "running"
            Enabled = $true
            Controller = "systemd"
            DependsOn = "[nxPackage]Apache2"
        }

        nxFile TestFile {
            Type = "File"
            Ensure = "Present"
            DestinationPath = "/var/www/html/welcome.html"
            Contents = "<h1>Merry Christmas!!</h1>"
            DependsOn = "[nxPackage]Apache2"
        }

    }

}

$Node = "centos72"
LinuxConfig -Node $Node -OutputPath $env:TEMP

Test-Connection $Node

$cred = Get-Credential -UserName "root" -Message "Enter password."
$opt = New-CimSessionOption -UseSsl:$true -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true
$s = New-CimSession -ComputerName $Node -Credential $cred -Port:5986 -Authentication Basic -SessionOption:$opt -OperationTimeoutSec:90
Get-CimSession

Start-DscConfiguration -Path $env:TEMP -CimSession $s -Wait -Verbose -Force
