enum Ensure {
    Absent
    Present
}

class Reason {
    [DscProperty()]
    [string] $Code

    [DscProperty()]
    [string] $Phrase
}

function Get-File {
    param(
        [Ensure]$ensure,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$path,

        [String]$content
    )
    $fileContent = [Reason]::new()
    $fileContent.code = 'file:file:content'

    $filePresent = [Reason]::new()
    $filePresent.code = 'file:file:path'

    $ensureReturn = 'Absent'

    $fileExists = Test-Path $path -ErrorAction SilentlyContinue

    if ($true -eq $fileExists) {
        $filePresent.phrase = "The file was expected to be: $ensure`nThe file exists at path: $path"

        $existingFileContent = Get-Content $path -Raw
        if ([string]::IsNullOrEmpty($existingFileContent)) {
            $existingFileContent = ''
        }

        if ($false -eq ([string]::IsNullOrEmpty($content))) {
            $content = $content | ConvertTo-SpecialChars
        }

        $fileContent.phrase = "The file was expected to contain: $content`nThe file contained: $existingFileContent"

        if ($content -eq $existingFileContent) {
            $ensureReturn = 'Present'
        }
    }
    else {
        $filePresent.phrase = "The file was expected to be: $ensure`nThe file does not exist at path: $path"
        $path = 'file not found'
    }

    return @{
        ensure  = $ensureReturn
        path    = $path
        content = $existingFileContent
        Reasons = @($filePresent, $fileContent)
    }
}

function Set-File {
    param(
        [Ensure]$ensure = "Present",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$path,

        [String]$content
    )
    Remove-Item $path -Force -ErrorAction SilentlyContinue
    if ($ensure -eq "Present") {
        New-Item $path -ItemType File -Force
        if ([ValidateNotNullOrEmpty()]$content) {
            $content | ConvertTo-SpecialChars | Set-Content $path -NoNewline -Force
        }
    }
}

function Test-File {
    param(
        [Ensure]$ensure = "Present",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$path,

        [String]$content
    )
    $test = $false
    $get = Get-File @PSBoundParameters

    if ($get.ensure -eq $ensure) {
        $test = $true
    }
    return $test
}

function ConvertTo-SpecialChars {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$string
    )
    $specialChars = @{
        '`n'  = "`n"
        '\\n' = "`n"
        '`r'  = "`r"
        '\\r' = "`r"
        '`t'  = "`t"
        '\\t' = "`t"
    }
    foreach ($char in $specialChars.Keys) {
        $string = $string -replace ($char, $specialChars[$char])
    }
    return $string
}

[DscResource()]
class SCUGJFile {

    [DscProperty(Key)]
    [string] $path

    [DscProperty(Mandatory)]
    [Ensure] $ensure

    [DscProperty()]
    [string] $content

    [DscProperty(NotConfigurable)]
    [Reason[]] $Reasons

    [SCUGJFile] Get() {
        $get = Get-File -ensure $this.ensure -path $this.path -content $this.content
        return $get
    }

    [void] Set() {
        $set = Set-File -ensure $this.ensure -path $this.path -content $this.content
    }

    [bool] Test() {
        $test = Test-File -ensure $this.ensure -path $this.path -content $this.content
        return $test
    }
}
