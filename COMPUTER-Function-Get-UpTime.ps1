Function Global:Get-UpTime {
    <#
    .SYNOPSIS
    PowerShell function to calculate computer uptime
    .DESCRIPTION
    Uses Win32_OperatingSystem to get LastBootUpTime for current computer
    .EXAMPLE
    Get-UpTime
    #>
    Param (
    [String]$CompVictim = "LocalHost"
          ) # End of parameter section
    Begin {
    Clear-Host
            }
    Process {
    $Booted = Get-WmiObject -Class Win32_OperatingSystem -Computer $CompVictim
    $Calc = [DateTime]::Now – $Booted.ConvertToDateTime($Booted.LastBootUpTime)
    Write-Host "Computer Uptime for:" `
    $CompVictim, $Calc.days "days and", $Calc.hours "hours"
         } # End of Process
    }
    
    Get-UpTime
    