Configuration SampleConfig {
    
    Node "WebServer" {

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

    Node "DNSServer" {

        WindowsFeature DNS {
            Name = "DNS"
            Ensure = "Present"
        }

        WindowsFeature DNSTools {
            Name = "RSAT-DNS-Server"
            Ensure = "Present"
        }

        WindowsFeature xTelnet {
            Name = "Telnet-Client"
            Ensure = "Absent"
        }

    }

}