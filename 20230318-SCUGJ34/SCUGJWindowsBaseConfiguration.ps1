Configuration SCUGJWindowsBaseConfiguration {
    Import-DscResource -ModuleName Scugj34SampleDscResource -Name SCUGJFile
    Node SCUGJ34WindowsBaseConfig {
        SCUGJFile WelcomeFile {
            path = "C:\SCUGJ34-Demo.txt"
            ensure = "Present"
            content = "Welcome to SCUGJ34 !!`nCustom DSC Resource: SCUGJFile"
        }
    }
}
