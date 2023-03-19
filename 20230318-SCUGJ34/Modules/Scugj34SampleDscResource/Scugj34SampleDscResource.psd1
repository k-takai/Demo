@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Scugj34SampleDscResource.psm1'

    # Version number of this module.
    ModuleVersion = '0.0.1'

    # ID used to uniquely identify this module
    GUID = '56ee5ab4-dcb6-4b34-8a12-4f667c7a1dd4'

    # Author of this module
    Author = 'Kazuki Takai'

    # Company or vendor of this module
    CompanyName = 'SCUGJ'

    # Copyright statement for this module
    Copyright = ''

    # Description of the functionality provided by this module
    Description = 'Create and set content of a file'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Functions to export from this module
    FunctionsToExport = @('Get-File','Set-File','Test-File')

    # DSC resources to export from this module
    DscResourcesToExport = @('SCUGJFile')

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @(Power Plan, Energy, Battery)

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    }
}
