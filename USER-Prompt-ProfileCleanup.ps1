## Local User Profile Cleanup
##### takes ownership, looks for user folders older than x days, and deletes them real good

$Computer = Read-Host -Prompt "Enter the computer name --->"
$Days = Read-Host -Prompt "Delete folder(s) older than how many days? --->"

icacls \\$Computer\c$\Users\*.* /T /grant administrators:F

Get-ChildItem -Path "\\$Computer\c$\Users\" -Directory | where {$_.LastWriteTime -le $(get-date).Adddays(-$days)} | Remove-Item -recurse

invoke-command -scriptblock {dir -Include build -Depth 1} | where {$_.LastWriteTime -le $(get-date).Adddays(-$180)} | Remove-Item -recurse -Force -whatif
