# Get Local Administrators Group Membership
## Get the Local Administrators Group Membership for a prompted Group against a prompted OU of Servers (using 'net localgroup')
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerList = Get-Content c:\Temp\ServerList.txt

$Array = @()
foreach($ServerObject in $ServerList){
$colItems = PsExec.exe \\$ServerObject net localgroup administrators | Select-Object -Skip 11 | Select-Object -SkipLast 2
    foreach ($Server in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'Name' = $ServerObject
            'Member' = $Server})
      }
    }
$Array | export-csv C:\Temp\LocalGroup_Membership_Report_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\Temp\LocalGroup_Membership_Report_$timestamp.csv" -ForegroundColor Cyan
