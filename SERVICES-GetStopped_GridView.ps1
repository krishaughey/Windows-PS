## get all stopped service on local machine, sort by Name, and send to GridView ##
write-host "Finding all STOPPED services on localhost..."

Get-Service | where status -eq "Stopped" | sort -Property Name | Out-GridView

Write-Host "PROCESS COMPLETE" -ForegroundColor Cyan
Read-Host -Prompt "press any key to exit"
## END SCRIPT ##
