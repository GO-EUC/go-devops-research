param(
    [string]
    $PersonalAccessToken,

    [string]
    $Organization,

    [string]
    $Project,

    [string]
    $PipelineId
)

$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
$header = @{
    Authorization = "Basic $token"
}

$body = [PSCustomObject]@{
    stagesToSkip = @()
    resources = [PSCustomObject]@{
        repositories = [PSCustomObject]@{
            self = [PSCustomObject]@{
                refName = "refs/heads/feature/setup"
            }
        }
    }
    variables = @{}
}

$startSplat = @{
    Uri = "https://dev.azure.com/${Organization}/${Project}/_apis/pipelines/${PipelineId}/runs?api-version=7.1-preview.1"
    Method = "POST"
    ContentType = "application/json"
    Headers = $header
    Body = $body | ConvertTo-Json -Depth 3
}

$run = Invoke-RestMethod @startSplat

while ($run.state -ne 'completed') {

    Write-Output "Current state: $($run.State)"
    $runSplat = @{
        Uri = $run.url
        Method = "GET"
        ContentType = "application/json"
        Headers = $header
    }

    $run = Invoke-RestMethod @runSplat

    Start-Sleep 1
}

$timeSpan = $run.finishedDate - $run.createdDate

Write-Output "Total time: $($timeSpan.TotalSeconds)"