#Windows Server Update Cleanup
Set-NetFirewallProfile -Profile Domain -Enabled False
Start-Service mpssvc
Stop-Service wuauserv -Force
Remove-Item C:\Windows\SoftwareDistribution\ -Recurse -Force
Start-Service wuauserv
