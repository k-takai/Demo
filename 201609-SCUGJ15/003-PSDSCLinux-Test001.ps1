Configuration SampleLinuxConfig {

    param (
        [parameter(mandatory)]
        [string[]]$Node
    )

    Import-DscResource -Module nx

    Node $Node {

        nxFile TestFile {
            Type = "File"
            Ensure = "Present"
            DestinationPath = "/tmp/testfile"
            Contents = "System Center User Group Japan #15`nWelcome!!`n"
        }

    }

}

SampleLinuxConfig -Node ubuntu1604 -OutputPath $env:TEMP

$Node = "ubuntu1604"
Test-Connection $Node

$cred = Get-Credential -UserName "root" -Message "Enter password."
$opt = New-CimSessionOption -UseSsl:$true -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true
$s = New-CimSession -ComputerName $Node -Credential $cred -Port:5986 -Authentication Basic -SessionOption:$opt -OperationTimeoutSec:90
Get-CimSession

Start-DscConfiguration -Path $env:TEMP -CimSession $s -Wait -Verbose -Force
