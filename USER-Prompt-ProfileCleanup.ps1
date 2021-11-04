## Local User Profile Cleanup
##### takes ownership on folders older than x days and removes them
##### author: Kristopher F. Haughey

$Computer = Read-Host -Prompt "Enter the computer name --->" -ForegroundColor Green
$Days = Read-Host -Prompt "Delete folder(s) older than how many days? --->" -ForegroundColor Green

Write-Host "Granting Administrators Full Rights on \Users..."
icacls \\$Computer\c$\Users\*.* /T /grant administrators:F | where {$_.LastWriteTime -le $(get-date).Adddays(-$days)}

Write-Host "Removing User directories older than $Days..." -ForegroundColor Yellow
Get-ChildItem -Path "\\$Computer\c$\Users\" -Directory | where {$_.LastWriteTime -le $(get-date).Adddays(-$days)} | Remove-Item -recurse
Write-Host "Process completed on $Computer" -ForegroundColor Green
