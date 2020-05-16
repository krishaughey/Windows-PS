## Get Free Disk Space
##### Get Free & Used Disk Space on remote computers - local disks C: and D: - report to CSV
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerList = get-adcomputer -Filter * -SearchBase "OU=Servers,DC=CARD,DC=COM" | Select-Object Name,dnshostname

$Array = @()
foreach ($Server in $ServerList){
$colItems = Get-WmiObject Win32_LogicalDisk -ComputerName $Server.DNSHostName | Where-Object {($_.DeviceID -eq "C:") -or ($_.DeviceID -eq "D:")}
  foreach ($Item in $colItems){
    $Array += New-Object PsObject -Property @{
      'Server' = $Item.PSComputerName
      'Letter' = $Item.Name
      'Freespace' = $Item.Freespace
      'TotalSize' = $Item.TotalSize}
    }
}
$Array | export-csv c:\Temp\WinServer-Freespace.csv -NoTypeInformation


## $disks = Get-WmiObject Win32_LogicalDisk -Computername WSUS1 | Where-Object {($_.DeviceID -eq "C:") -or ($_.DeviceID -eq "D:")} | Select-Object Name,Size,Freespace
