<#
    .DESCRIPTION
    Simple script that will call a public API and return the app count

    .OUTPUTS
    Application count or null
#>

$appCount = $null

$appsSplat = @{
    Uri = "https://evergreen-api.stealthpuppy.com/apps"
    Method = "GET"
    ContentType = "application/json"
}

try {
    $apps = Invoke-RestMethod @appsSplat
} catch {
    throw "Failed to collect the apps."
}

if ($apps) {
    $appCount = $apps.Count
}

return $appCount