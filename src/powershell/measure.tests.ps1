
Describe "mesure.ps1" {
    It "Should exit without any errors" {
        $script:count = 0
        Mock -CommandName Invoke-RestMethod -MockWith {
            if ($script:count -le 1000) {
                $obj = [PSCustomObject]@{
                    state = "inProgress"
                    url = "https://api.dummy.com"
                }
            } else {
                $obj = [PSCustomObject]@{
                    state = "completed"
                    createdDate = (Get-DAte).AddSeconds(-77)
                    finishedDate = Get-Date
                }
            }

            $script:count++
            return $obj
        }

        Mock -CommandName Start-Sleep -MockWith {}

        $splat = @{
            PersonalAccessToken = "dummy"
            Organization = "dummy"
            Project = "dummy"
            PipelineId = "1337"
        }
        { & "$PSScriptRoot/mesure.ps1" @splat } | Should -Not -Throw

    }
}