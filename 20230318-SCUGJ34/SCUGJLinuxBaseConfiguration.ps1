Configuration SCUGJLinuxBaseConfiguration {
    Import-DscResource -ModuleName Scugj34SampleDscResource -Name SCUGJFile
    Node SCUGJ34LinuxBaseConfig {
        SCUGJFile WelcomeFile {
            path = "/etc/motd"
            ensure = "Present"
            content = "*******************************************`n* Welcome to SCUGJ34 Linux Demo !!        *`n*                                         *`n* Notice: This is PRODUCTION environment  *`n*******************************************`nCreated by Custom DSC Resource : SCUGJFile`n"
        }
    }
}
