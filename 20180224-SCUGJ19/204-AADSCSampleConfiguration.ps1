Configuration AADSCSampleConfiguration
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration

    Node "WebServer"
    {
        WindowsFeature IIS
        {
            Name = "Web-Server"
            Ensure = "Present"
        }

        WindowsFeature IISTools
        {
            Name = "Web-Mgmt-Tools"
            Ensure = "Present"
        }

        WindowsFeature xDHCP
        {
            Name = "DHCP"
            Ensure = "Absent"
        }
    }

    Node "DNSServer"
    {
        WindowsFeature DNS
        {
            Name = "DNS"
            Ensure = "Present"
        }

        WindowsFeature DNSTools
        {
            Name = "RSAT-DNS-Server"
            Ensure = "Present"
        }
    }
}
