Configuration SampleConfigIIS {
    
    Node "IISWebServer" {

        WindowsFeature IIS {
            Name = "Web-Server"
            Ensure = "Present"
        }

        WindowsFeature IISTools {
            Name = "Web-Mgmt-Tools"
            Ensure = "Present"
        }

        WindowsFeature xTelnet {
            Name = "Telnet-Client"
            Ensure = "Absent"
        }
        
    }

}