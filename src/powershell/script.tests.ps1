
Describe "Script test" {
    It "Should return 3 apps count" {
        $appsMock = @()
        $appsMock += [PSCustomObject]@{
            Name = "Dummy1"
            Application = "Dummy1"
            Link = "www.go-euc.com"
        }

        $appsMock +=  [PSCustomObject]@{
            Name = "Dummy2"
            Application = "Dummy2"
            Link = "www.go-euc.com"
        }

        $appsMock += [PSCustomObject]@{
            Name = "Dummy3"
            Application = "Dummy3"
            Link = "www.go-euc.com"
        }

        Mock -CommandName Invoke-RestMethod -MockWith {$appsMock}

        & "$PSScriptRoot/script.ps1"  | Should -BeExactly 3
    }

    It "Should return null" {
        Mock -CommandName Invoke-RestMethod -MockWith {}
        & "$PSScriptRoot/script.ps1"  | Should -BeExactly $null
    }

    It "Should throw when calling Invoke-RestMethod" {
        Mock -CommandName Invoke-RestMethod -MockWith {throw "simulation error"}

        { & "$PSScriptRoot/script.ps1"  } | Should -Throw
    }
}