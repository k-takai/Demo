Configuration SampleWebServer
{
    Node "localhost"
    {
        WindowsFeature IIS
        {
            Name = "Web-Server"
            Ensure = "Present"
        }
    }
}