#Remove File from Remote Machines (same file and location for each)
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

write-host 'Starting the Remove-Item Process'
write-host $timestamp

$list = (Get-Content C:\Temp\ServerList.txt)

Foreach ($server in $list)
{
  Remove-Item \\$server\c$\Temp\SentinelAgent_windows_v3_2_4_54.exe
}

write-host 'Process Complete'
write-host $timestamp
