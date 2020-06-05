## Get Registry Key Value
##### Get Registry Key Value on a list of computers. Prompted for file location and REG key
##### author: Kristopher F. Haughey
# $ErrorActionPreference = 'silentlycontinue'
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$FileLocation = Read-Host -Prompt "Enter the path of your computer list file"
$ServerList = Get-Content -Path $($FileLocation.FilePath)
$KeyParent = Read-Host -Input "Enter the parent path to the REG Key you wish to get (1 level above your key)"
$KeyName = Read-Host -Input "Enter the name of the key you wish to query"

$Array = @()
foreach ($Server in $ServerList){
$colItems = Get-ItemProperty -Path $KeyParent -Name $KeyName | select *
  foreach ($KeyValue in $colItems){
    $Array += New-Object PSObject -Property ([ordered]@{
      'ComputerName' = $Server
      'KeyPath' = $KeyValue.PSPath
      'KeyValue' = $KeyValue."$KeyName"})
  }
}
$Array | Export-Csv "c:\Temp\RegKeyQuery_$timestamp.csv" -NoTypeInformation
Write-Host "results have been exported to "c:\Temp\RegKeyQuery_$timestamp.csv"" -ForegroundColor Cyan

***************************DRAFT****************************
