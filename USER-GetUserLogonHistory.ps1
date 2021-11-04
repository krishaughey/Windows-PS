$logons = @()
Get-EventLog "Security"  `
    | Where -FilterScript {$_.EventID -eq 4648 -or $_.EventID -eq 4624 -and $_.ReplacementStrings[5] -notlike "*$" } `
    | foreach-Object {
        $row = "" | Select UserName, LoginTime
        $row.UserName = $_.ReplacementStrings[5]
        $row.LoginTime = $_.TimeGenerated
        $logons += $row
        }
$logons
