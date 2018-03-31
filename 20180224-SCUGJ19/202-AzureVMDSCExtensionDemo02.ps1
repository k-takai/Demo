Configuration SampleWebServer
{
    Node "localhost"
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

        WindowsFeature Telnet
        {
            Name = "Telnet-Client"
            Ensure = "Present"
        }
    }
}