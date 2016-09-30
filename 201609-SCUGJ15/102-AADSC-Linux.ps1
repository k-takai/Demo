Configuration SampleLinuxConfig{

    Import-DscResource -Module nx

    Node "Test"{

        nxFile TestFile {
            Type = "File"
            Ensure = "Present"
            DestinationPath = "/tmp/testfile"
            Contents = "System Center User Group Japan #15`nWelcome!!`n"
        }

    }

    Node "ApacheWebServer" {

        nxGroup ScugjGroup {
            GroupName = "scugj"
            Ensure = "Present"
        }

        nxUser ScugjUser {
            UserName = "scugj"
            Ensure = "Present"
            #Password  = '$6$fZAne/Qc$MZejMrOxDK0ogv9SLiBP5J5qZFBvXLnDu8HY1Oy7ycX.Y3C7mGPUfeQy3A82ev3zIabhDQnj2ayeuGn02CqE/0'
            HomeDirectory = "/home/scugj"
            Description = "scugj user"
            GroupID = "scugj"
            DependsOn = "[nxGroup]ScugjGroup"
        }

        nxSshAuthorizedKeys ScugjSSHKey {
            UserName = "scugj"
            Key = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCX8+lLrYjJYYJv0XPIinEkuUpudcj2Z7TzFMxY+QEFfKXIOC8a2hOmA5kSOchYowDQjujVWOJv07cB9756ce2CJ9BGEmRKUq1ws0fUix9fTziN7n7f/I2UO6rOkUoZwcUdNVXeDdx0CR8IWxXrP1q490nLwFYfL/Tee6RVmn9DVPx6uS/ZAJkBqDcD189BpeKcps18y8tcYUaIe7ner7j30bj+6icqOgYLfHShc62L8DK6v8YDumLY76PhHGCkCZwl8SA4upuMEQJeROcOaSsIBMq4KU1Ljezgu54L4VCIyN71itw/wtIx+7gVagVjx0sGm4BxDWNoyM3ObpFaTSqx scugj@ubuntu'
            Ensure = "Present"
            KeyComment = "SSH RSA for scugj"
            DependsOn = "[nxUser]ScugjUser"
        }

    }

}
