 ## System Hardware Information
##### Get Hardware Info from WMI of Local Computer - report to CSV
##### author: Kristopher F. Haughey

$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

#!!DRAFT!!
$Array = @()
$BIOS = Get-CimInstance Win32_BIOS
$CPU = Get-CimInstance Win32_Processor
$Display = Get-CimInstance CIM_Display
$OS = Get-CimInstance Win32_OperatingSystem
$Storage = Get-CimInstance Win32_LogicalDisk
$SYS = Get-CimInstance Win32_ComputerSystem
$IPAddress = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.ipaddress -notlike $null}
$PhysicalMemory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % { [Math]::Round(($_.sum / 1GB), 2) }

  foreach ($Drive in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
      'Name' = $OS.Name
      'Manufacturer' = $SYS.Manufacturer
      'Model' = $SYS.Model
      'Asset Type' = Chassis Type
      'Serial Number' = $BIOS.SerialNumber
      'Location' = 
      'IP Address' = $IPAddress.IPaddress[0]
      'Operating System' = $CompInfo.WindowsProductName
      'Operating System Version' = $SYS.OsVersion
      'Firmware' = $CompInfo.BiosCaption
      'Storage Capacity' = [Math]::Round($Storage.Size / 1GB)
      'RAM' = $PhysicalMemory
      'Monitor Manufacturer' =  $Display.Name[0,1] 
      'Monitor Model' =  $Display.MonitorManufacturer[0,1]
      })
    }

$Array | export-csv C:\%USERPROFILE%\Downloads\SystemReport_$timestamp.csv -NoTypeInformation
Write-Host "export = C:\%USERPROFILE%\Downloads\SystemReport_$timestamp.csv" -ForegroundColor Cyan
