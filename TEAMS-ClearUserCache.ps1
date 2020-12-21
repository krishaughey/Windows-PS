$Teams = Get-Process | Where-Object {$_.ProcessName -eq "Teams"}
$Teams | Stop-Process
$TeamsAppData = Get-ChildItem -Recurse "$env:userprofile\AppData\Roaming\Microsoft\Teams"
$TeamsAppData | Remove-Item
Start-Process -FilePath "$env:userprofile\AppData\Local\Microsoft\Teams\current\Teams.exe"
