## Get Free Disk Space on List
##### Get Free & Used Disk Space on a list of servers - report to CSV
##### author: Kristopher F. Haughey
Import-Module ActiveDirectory
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerList = Get-Content c:\Temp\ServerList.txt

$ErrorActionPreference = 'silentlycontinue'
Write-Host "Gathering info. Depending on your searbase, this might take some time... Grab a coffee?" -ForegroundColor Green
$Array = @()
foreach ($Server in $ServerList){
$colItems = Get-WmiObject Win32_LogicalDisk -ComputerName $Server.DNSHostName
  foreach ($Drive in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
      'ServerName' = $Drive.PSComputerName
      'DriveName' = $Drive.Name
      'Freespace(GB)' = [Math]::Round($Drive.Freespace / 1GB)
      'TotalSize(GB)' = [Math]::Round($Drive.Size / 1GB)})
    }
}
$Array | export-csv c:\Temp\Disk_Freespace_$timestamp.csv -NoTypeInformation
Write-Host "export = c:\Temp\Disk_Freespace_$timestamp.csv" -ForegroundColor Cyan
