Param(
    [Parameter(Mandatory=$false)]
    [string]
    $SourcePath,

    [Parameter(Mandatory=$false)]
    [switch]
    $Publish,

    [Parameter(Mandatory=$false)]
    [string]
    $ResultsPath
)

$pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}

if (!$pesterModule) {
    try {
        Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck -MinimumVersion "5.*"
    }
    catch {
        Write-Error "Failed to install the Pester module."
    }
}

$pesterModule | Import-Module

$config = New-PesterConfiguration
$config.Run.Path = $SourcePath
if ($Publish) {
    $config.CodeCoverage.Enabled = $true
    $config.CodeCoverage.OutputFormat = 'CoverageGutters'
    $config.CodeCoverage.OutputPath = "$ResultsPath\codecoverage.xml"
    $config.CodeCoverage.OutputEncoding = 'UTF8'
}

Invoke-Pester -Configuration $config